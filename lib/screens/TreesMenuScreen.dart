import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:async';

class TreesMenuScreen extends StatefulWidget {
  const TreesMenuScreen({super.key});

  @override
  State<TreesMenuScreen> createState() => _TreesMenuScreenState();
}

class _TreesMenuScreenState extends State<TreesMenuScreen> {
  List<Map<String, dynamic>> items = [];
  bool cargando = true;
  late String proyectoId;
  late String proyectoNombre;
  bool _isInitialized = false;

  // Paginación
  final int _limit = 100;
  String? _nextToken;
  final List<String?> _tokenHistory = [null];
  int _paginaActual = 0;

  // Buscador
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // ✅ NUEVO: flag para saber si estamos en modo búsqueda
  bool _enModoBusqueda = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute
          .of(context)!
          .settings
          .arguments as Map<String, dynamic>;
      proyectoId = args['proyecto_id'];
      proyectoNombre = args['proyecto_nombre'];
      _isInitialized = true;
      _cargarDatosDeLaNube();
    }
  }

  // ✅ CAMBIO: carga normal SIN filtro de texto, solo paginación
  Future<void> _cargarDatosDeLaNube({String? token}) async {
    if (!mounted) return;
    setState(() => cargando = true);

    const query = r'''
      query ListTrees($filter: ModelTreeFilterInput, $limit: Int, $nextToken: String) {
        listTrees(filter: $filter, limit: $limit, nextToken: $nextToken) {
          items {
            id
            name
            status
            projectTreesId
            createdAt
          }
          nextToken
        }
      }
    ''';

    try {
      // ✅ CAMBIO: filtro limpio, solo por proyecto, sin texto
      final Map<String, dynamic> filter = {
        'projectTreesId': {'eq': proyectoId}
      };


      final variables = {
        'filter': filter,
        'limit': _limit, // ✅ CAMBIO: siempre 100, nunca 3000
        if (token != null) 'nextToken': token,
      };

      final request = GraphQLRequest<String>(
        document: query,
        variables: variables,
      );

      final response = await Amplify.API
          .query(request: request)
          .response;

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final list = jsonData['listTrees']['items'] as List<dynamic>;
        final newNextToken = jsonData['listTrees']['nextToken'] as String?;

        if (mounted) {
          setState(() {
            items = List<Map<String, dynamic>>.from(list);
            _nextToken = newNextToken;
            cargando = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error cargando Trees: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  // ✅ NUEVO: búsqueda recursiva que recorre páginas hasta encontrar todos los resultados
  Future<void> _buscarEnTodasLasPaginas(String termino) async {
    if (!mounted) return;
    setState(() => cargando = true);

    const query = r'''
      query ListTrees($filter: ModelTreeFilterInput, $limit: Int, $nextToken: String) {
        listTrees(filter: $filter, limit: $limit, nextToken: $nextToken) {
          items {
            id
            name
            status
            projectTreesId
            createdAt
          }
          nextToken
        }
      }
    ''';

    List<Map<String, dynamic>> resultados = [];
    String? tokenActual;
    int paginasRevisadas = 0;
    const int maxPaginas = 30; // Límite de seguridad: máximo 3000 registros

    try {
      do {
        final Map<String, dynamic> filter = {
          'projectTreesId': {'eq': proyectoId},
          'name': {'contains': termino},
        };

        final variables = {
          'filter': filter,
          'limit': 100,
          if (tokenActual != null) 'nextToken': tokenActual,
        };

        final request = GraphQLRequest<String>(
          document: query,
          variables: variables,
        );

        final response = await Amplify.API
            .query(request: request)
            .response;
        if (response.data == null) break;

        final jsonData = jsonDecode(response.data!);
        final list = jsonData['listTrees']['items'] as List<dynamic>;
        final nextToken = jsonData['listTrees']['nextToken'] as String?;

        resultados.addAll(List<Map<String, dynamic>>.from(list));
        tokenActual = nextToken;
        paginasRevisadas++;

        /*  muestra resultados mientras sigue buscando en caso de que hayan mas (Uno puede
            estar entre los primeros registros y otro entre los ultimos)
         */
        if (resultados.isNotEmpty && mounted) {
          setState(() {
            items = resultados;
            _nextToken = null;
            cargando = false;
          });
        }

        // pausa de 100ms para no saturar AppSync
        await Future.delayed(const Duration(milliseconds: 100));
      } while (tokenActual != null && paginasRevisadas < maxPaginas && mounted);

      // Resultado final consolidado
      if (mounted) {
        setState(() {
          items = resultados;
          _nextToken = null;
          cargando = false;
        });
      }

      debugPrint('🔍 Búsqueda: ${resultados
          .length} resultados en $paginasRevisadas páginas');
    } catch (e) {
      debugPrint('Error en búsqueda: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  // ✅ CAMBIO: debounce ahora decide entre modo normal y modo búsqueda
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce =
        Timer(const Duration(milliseconds: 600), () { // ✅ 600ms en vez de 500ms
          if (!mounted) return;

          if (value
              .trim()
              .isEmpty) {
            // ✅ CAMBIO: al borrar, vuelve a paginación normal desde página 1
            _enModoBusqueda = false;
            _paginaActual = 0;
            _tokenHistory
              ..clear()
              ..add(null);
            _cargarDatosDeLaNube();
          } else if (value
              .trim()
              .length >= 2) {
            // ✅ NUEVO: mínimo 2 caracteres para activar búsqueda
            _enModoBusqueda = true;
            _buscarEnTodasLasPaginas(value.trim());
          }
        });
  }

  void _irSiguientePagina() {
    if (_nextToken == null) return;
    _tokenHistory.add(_nextToken);
    _paginaActual++;
    _cargarDatosDeLaNube(token: _nextToken);
  }

  void _irPaginaAnterior() {
    if (_paginaActual == 0) return;
    _paginaActual--;
    _tokenHistory.removeLast();
    final tokenAnterior = _tokenHistory.last;
    _cargarDatosDeLaNube(token: tokenAnterior);
  }

  Future<void> _crearItem(String nombre) async {
    const mutation = r'''
      mutation CreateTree($input: CreateTreeInput!) {
        createTree(input: $input) {
          id
          name
          status
          projectTreesId
          createdAt
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'name': nombre,
            'status': 'Pendiente',
            'projectTreesId': proyectoId,
          }
        },
      );
      await Amplify.API
          .mutate(request: request)
          .response;


      _searchController.clear();
      _enModoBusqueda = false; // ✅ NUEVO: salir de modo búsqueda al crear
      _paginaActual = 0;
      _tokenHistory
        ..clear()
        ..add(null);
      _cargarDatosDeLaNube();
    } catch (e) {
      debugPrint('Error creando Tree: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF4A5C24);
    final bg = const Color(0xFFF7F8F6);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [

            // ---------- TOP BAR ----------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(blurRadius: 8,
                      color: Colors.black12,
                      offset: Offset(0, 2))


                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    proyectoNombre,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),


                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),

            // ---------- SEARCH ----------
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Buscar trees...",
                  prefixIcon: const Icon(Icons.search),
                  // ✅ NUEVO: botón X para limpiar búsqueda
                  suffixIcon: _enModoBusqueda
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),

            // ---------- HEADER + ACTION ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ✅ NUEVO: título cambia según el modo
                  Text(
                    _enModoBusqueda
                        ? "Resultados (${items.length})"
                        : "Active Forest",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),


                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),

                    ),
                    onPressed: () => _mostrarDialogoNuevo(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Nuevo Tree"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- LIST ----------
            Expanded(
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                  ? Center(
                child: Text(
                  _enModoBusqueda
                      ? "No se encontraron Trees con ese nombre"
                      : "No hay Trees en este proyecto",
                ),
              )
                  : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [

                  ...items.map((tree) => _buildTreeCard(tree, primary)),

                  const SizedBox(height: 20),

                  // ✅ CAMBIO: "Cargar más" solo aparece en modo normal, no en búsqueda
                  if (_nextToken != null && !_enModoBusqueda)
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary.withOpacity(0.1),
                          foregroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _irSiguientePagina,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),

                          child: Text(
                            "Cargar más",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeCard(Map<String, dynamic> tree, Color primary) {
    final status = (tree['status'] ?? 'Pendiente').toString();
    final health = 0.75;

    Color statusColor = primary;
    if (status.toLowerCase().contains("monitor")) {
      statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.pushNamed(context, '/captura', arguments: {
            'tree_id': tree['id'],
            'tree_name': tree['name'],
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tree['name'] ?? "Tree",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),

                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),

                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              "ID: ${tree['id'].toString().substring(0, 8)}...",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Estado", style: TextStyle(fontSize: 12)),


                Text(
                  "${(health * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: health,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _mostrarDialogoNuevo(BuildContext context) async {
    final controller = TextEditingController();
    final nombre = await showDialog<String>(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: const Text('Nombre del Tree'),
            content: TextField(controller: controller, autofocus: true),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, controller.text),
                child: const Text('Guardar'),
              ),
            ],
          ),
    );
    if (nombre != null && nombre.isNotEmpty) _crearItem(nombre);
  }
}