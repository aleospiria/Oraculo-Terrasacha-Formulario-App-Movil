import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/ModelProvider.dart';
import 'geojson_topology_helpers.dart';

class ServicioTopologia {
  static const Duration _timeout = Duration(seconds: 12);

  static const _listTopologiasQuery = r'''
    query ListTopologiesConRelaciones($limit: Int) {
      listTopologies(limit: $limit) {
        items {
          id
          name
          string_code
          number_code
          status
          polygon
          project {
            id
            name
            status
          }
          topologyParent {
            id
            name
          }
        }
      }
    }
  ''';

  static const _topologiasPorProyectoQuery = r'''
    query TopologiasPorProyecto($id: ID!) {
      getProject(id: $id) {
        id
        name
        status
        topologies {
          items {
            id
            name
            string_code
            number_code
            status
            polygon
            topologyParent {
              id
              name
            }
          }
        }
      }
    }
  ''';

  /// Proyectos: API primero (no bloquea por DataStore), luego caché local.
  static Future<List<Project>> cargarProyectos() async {
    try {
      final desdeApi = await _listarProyectosApi();
      if (desdeApi.isNotEmpty) return desdeApi;
    } catch (e) {
      safePrint('ServicioTopologia proyectos API: $e');
    }

    try {
      return await Amplify.DataStore.query(Project.classType).timeout(
        _timeout,
        onTimeout: () => <Project>[],
      );
    } catch (e) {
      safePrint('ServicioTopologia proyectos DataStore: $e');
      return [];
    }
  }

  static Future<List<Project>> _listarProyectosApi() async {
    final request = ModelQueries.list(Project.classType, limit: 200);
    final response = await Amplify.API
        .query(request: request)
        .response
        .timeout(_timeout);

    if (response.errors.isNotEmpty) {
      throw Exception(response.errors.map((e) => e.message).join(', '));
    }

    return response.data?.items.whereType<Project>().toList() ?? [];
  }

  /// Topologías: API primero, DataStore como respaldo con reintentos cortos.
  static Future<List<Topology>> cargarTopologias() async {
    try {
      final desdeApi = await _listarTopologiasApi();
      if (desdeApi.isNotEmpty) return desdeApi;
    } catch (e) {
      safePrint('ServicioTopologia topologías API: $e');
    }

    for (var i = 0; i < 3; i++) {
      try {
        final items = await Amplify.DataStore.query(Topology.classType).timeout(
          const Duration(seconds: 4),
          onTimeout: () => <Topology>[],
        );
        if (items.isNotEmpty) return items;
      } catch (e) {
        safePrint('ServicioTopologia topologías DataStore intento ${i + 1}: $e');
      }
      if (i < 2) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
      }
    }

    return [];
  }

  static Future<List<Topology>> _listarTopologiasApi() async {
    final request = GraphQLRequest<String>(
      document: _listTopologiasQuery,
      variables: const {'limit': 500},
    );
    final response = await Amplify.API
        .query(request: request)
        .response
        .timeout(_timeout);

    if (response.errors.isNotEmpty) {
      throw Exception(response.errors.map((e) => e.message).join(', '));
    }
    if (response.data == null) return [];

    final jsonData = jsonDecode(response.data!) as Map<String, dynamic>;
    final items =
        jsonData['listTopologies']?['items'] as List<dynamic>? ?? [];

    return items
        .map((e) => Topology.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Carga topologías de un proyecto con relaciones (más fiable que filtrar en memoria).
  static Future<List<Topology>> cargarTopologiasPorProyecto(
    String projectId,
  ) async {
    try {
      final desdeProyecto = await _topologiasDesdeProyectoApi(projectId);
      if (desdeProyecto.isNotEmpty) return desdeProyecto;
    } catch (e) {
      safePrint('ServicioTopologia por proyecto API: $e');
    }

    final todas = await cargarTopologias();
    return todas.where((t) => idProyectoTopologia(t) == projectId).toList();
  }

  static Future<List<Topology>> _topologiasDesdeProyectoApi(
    String projectId,
  ) async {
    final request = GraphQLRequest<String>(
      document: _topologiasPorProyectoQuery,
      variables: {'id': projectId},
    );
    final response = await Amplify.API
        .query(request: request)
        .response
        .timeout(_timeout);

    if (response.errors.isNotEmpty) {
      throw Exception(response.errors.map((e) => e.message).join(', '));
    }
    if (response.data == null) return [];

    final jsonData = jsonDecode(response.data!) as Map<String, dynamic>;
    final proyecto = jsonData['getProject'] as Map<String, dynamic>?;
    if (proyecto == null) return [];

    final items =
        proyecto['topologies']?['items'] as List<dynamic>? ?? [];
    final projectStub = {
      'id': proyecto['id'],
      'name': proyecto['name'],
      'status': proyecto['status'] ?? 'activo',
    };

    return items.map((raw) {
      final map = Map<String, dynamic>.from(raw as Map<String, dynamic>);
      map['project'] = projectStub;
      return Topology.fromJson(map);
    }).toList();
  }

  static String? idProyectoTopologia(Topology t) => t.project?.id;

  static String? idPadreTopologia(Topology t) {
    final padre = t.topologyParent;
    if (padre == null) return null;
    if (padre.id.isEmpty) return null;
    return padre.id;
  }

  static bool esRaiz(Topology t) => idPadreTopologia(t) == null;

  static List<Topology> raicesPorProyecto(
    List<Topology> todas,
    String projectId,
  ) {
    return todas
        .where(
          (t) => idProyectoTopologia(t) == projectId && esRaiz(t),
        )
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  static List<Topology> hijosDe(List<Topology> todas, String parentId) {
    return todas
        .where((t) => idPadreTopologia(t) == parentId)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  static bool tieneHijos(List<Topology> todas, String nodeId) {
    return todas.any((t) => idPadreTopologia(t) == nodeId);
  }

  static List<Topology> rutaJerarquica(
    Topology nodo,
    List<Topology> todas,
  ) {
    final byId = {for (final t in todas) t.id: t};
    final path = <Topology>[];
    Topology? current = nodo;
    final visited = <String>{};

    while (current != null && !visited.contains(current.id)) {
      visited.add(current.id);
      path.insert(0, current);
      final parentId = idPadreTopologia(current);
      if (parentId == null) break;
      current = byId[parentId];
    }
    return path;
  }

  static String etiquetaRuta(List<Topology> ruta) {
    if (ruta.isEmpty) return '';
    return ruta.map((t) => t.name).join(' › ');
  }

  /// Busca polígono en el nodo o en sus ancestros (como en ModelAI).
  static String? resolverPoligonoPadre(
    Topology nodo,
    List<Topology> todas,
  ) {
    for (final t in rutaJerarquica(nodo, todas)) {
      final poly = t.polygon;
      if (poly != null && poly.trim().isNotEmpty) return poly;
    }
    return null;
  }

  /// Refresca un nodo desde API para obtener `polygon` si DataStore no lo trajo.
  static Future<Topology?> obtenerTopologiaConPoligono(String id) async {
    try {
      final request = ModelQueries.get(
        Topology.classType,
        TopologyModelIdentifier(id: id),
      );
      final response = await Amplify.API
          .query(request: request)
          .response
          .timeout(_timeout);
      if (response.errors.isNotEmpty || response.data == null) return null;
      return response.data;
    } catch (e) {
      safePrint('Error getTopology $id: $e');
      return null;
    }
  }

  static Future<String?> cargarPoligonoPadre(
    Topology nodo,
    List<Topology> todas,
  ) async {
    final local = resolverPoligonoPadre(nodo, todas);
    if (local != null && parseGeoJsonPolygonRing(local).isNotEmpty) {
      return local;
    }

    for (final t in rutaJerarquica(nodo, todas)) {
      final remoto = await obtenerTopologiaConPoligono(t.id);
      final poly = remoto?.polygon;
      if (poly != null && parseGeoJsonPolygonRing(poly).isNotEmpty) {
        return poly;
      }
    }
    return local;
  }
}
