import 'package:flutter/material.dart';

import '../models/ModelProvider.dart';
import '../utils/servicio_topologia.dart';

class ResultadoSeleccionTopologia {
  final Project proyecto;
  final Topology topologia;
  final List<Topology> ruta;
  final String? poligonoPadreGeoJson;

  const ResultadoSeleccionTopologia({
    required this.proyecto,
    required this.topologia,
    required this.ruta,
    this.poligonoPadreGeoJson,
  });

  String get etiquetaRuta => ServicioTopologia.etiquetaRuta(ruta);
}

class SelectorTopologiaSheet extends StatefulWidget {
  final Color primaryColor;

  const SelectorTopologiaSheet({super.key, required this.primaryColor});

  static Future<ResultadoSeleccionTopologia?> mostrar(
    BuildContext context, {
    Color primaryColor = const Color(0xFF4A5C24),
  }) {
    return showModalBottomSheet<ResultadoSeleccionTopologia>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectorTopologiaSheet(primaryColor: primaryColor),
    );
  }

  @override
  State<SelectorTopologiaSheet> createState() => _SelectorTopologiaSheetState();
}

class _SelectorTopologiaSheetState extends State<SelectorTopologiaSheet> {
  bool _cargando = true;
  String? _error;

  List<Project> _proyectos = [];
  List<Topology> _todasTopologias = [];

  Project? _proyecto;
  final List<Topology> _pilaNavegacion = [];
  bool _resolviendoPoligono = false;
  bool _cargandoTopologiasProyecto = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _seleccionarProyecto(Project proyecto) async {
    setState(() {
      _proyecto = proyecto;
      _pilaNavegacion.clear();
      _cargandoTopologiasProyecto = true;
    });

    try {
      final delProyecto =
          await ServicioTopologia.cargarTopologiasPorProyecto(proyecto.id);
      if (!mounted) return;

      final idsVistos = {for (final t in _todasTopologias) t.id};
      final fusionadas = List<Topology>.from(_todasTopologias);
      for (final t in delProyecto) {
        if (!idsVistos.contains(t.id)) {
          fusionadas.add(t);
          idsVistos.add(t.id);
        } else {
          final idx = fusionadas.indexWhere((x) => x.id == t.id);
          if (idx >= 0) fusionadas[idx] = t;
        }
      }

      setState(() {
        _todasTopologias = fusionadas;
        _cargandoTopologiasProyecto = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargandoTopologiasProyecto = false);
      _mostrarAviso('No se pudieron cargar las topologías del proyecto: $e');
    }
  }

  void _mostrarAviso(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final resultados = await Future.wait([
        ServicioTopologia.cargarProyectos(),
        ServicioTopologia.cargarTopologias(),
      ]);

      if (!mounted) return;
      final proyectos = resultados[0] as List<Project>;
      final topologias = resultados[1] as List<Topology>;

      setState(() {
        _proyectos = List<Project>.from(proyectos)
          ..sort((a, b) => a.name.compareTo(b.name));
        _todasTopologias = topologias;
        _cargando = false;
        if (_proyectos.isEmpty && _todasTopologias.isEmpty) {
          _error =
              'No se encontraron proyectos ni topologías. Verifica tu conexión a internet o crea un proyecto en la app.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudieron cargar los datos: $e';
        _cargando = false;
      });
    }
  }

  List<Topology> get _nodosVisibles {
    if (_proyecto == null) return [];
    if (_pilaNavegacion.isEmpty) {
      return ServicioTopologia.raicesPorProyecto(
        _todasTopologias,
        _proyecto!.id,
      );
    }
    return ServicioTopologia.hijosDe(
      _todasTopologias,
      _pilaNavegacion.last.id,
    );
  }

  Future<void> _seleccionarNodo(Topology nodo) async {
    if (_proyecto == null) return;

    setState(() => _resolviendoPoligono = true);

    final ruta = ServicioTopologia.rutaJerarquica(nodo, _todasTopologias);
    final poligono = await ServicioTopologia.cargarPoligonoPadre(
      nodo,
      _todasTopologias,
    );

    if (!mounted) return;
    setState(() => _resolviendoPoligono = false);

    Navigator.pop(
      context,
      ResultadoSeleccionTopologia(
        proyecto: _proyecto!,
        topologia: nodo,
        ruta: ruta,
        poligonoPadreGeoJson: poligono,
      ),
    );
  }

  void _entrarEnNodo(Topology nodo) {
    setState(() => _pilaNavegacion.add(nodo));
  }

  void _retrocederNivel() {
    if (_pilaNavegacion.isNotEmpty) {
      setState(() => _pilaNavegacion.removeLast());
      return;
    }
    setState(() => _proyecto = null);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.88;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Seleccionar ubicación',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Cerrar',
                ),
              ],
            ),
          ),
          if (_proyecto != null || _pilaNavegacion.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _retrocederNivel,
                    tooltip: 'Atrás',
                  ),
                  Expanded(
                    child: Text(
                      _breadcrumb(),
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: _cargando || _cargandoTopologiasProyecto
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: widget.primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          'Cargando proyectos y topologías...',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : _error != null
                    ? _buildError()
                    : _buildContenido(),
          ),
          if (_resolviendoPoligono)
            const LinearProgressIndicator(minHeight: 2),
        ],
      ),
    );
  }

  String _breadcrumb() {
    final partes = <String>[];
    if (_proyecto != null) partes.add(_proyecto!.name);
    for (final n in _pilaNavegacion) {
      partes.add(n.name);
    }
    return partes.join(' › ');
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _cargarDatos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContenido() {
    if (_proyecto == null) {
      return _buildListaProyectos();
    }
    return _buildListaTopologias();
  }

  Widget _buildListaProyectos() {
    if (_proyectos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.folder_off_outlined,
                  size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text(
                'No hay proyectos disponibles',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Crea un proyecto en la sección Proyectos o revisa tu conexión.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _proyectos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final p = _proyectos[i];
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          leading: Icon(Icons.folder_outlined, color: widget.primaryColor),
          title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('Estado: ${p.status}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _seleccionarProyecto(p),
        );
      },
    );
  }

  Widget _buildListaTopologias() {
    final nodos = _nodosVisibles;

    if (nodos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_tree_outlined,
                  size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                _pilaNavegacion.isEmpty
                    ? 'Este proyecto no tiene topologías raíz.'
                    : 'No hay subniveles en este nodo.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                _pilaNavegacion.isEmpty
                    ? 'Crea la jerarquía en ModelAI (Topologías) y asígnala a este proyecto.'
                    : 'Puedes pulsar "Usar" en el nivel actual si es la ubicación final.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: nodos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final nodo = nodos[i];
        final tieneHijos = ServicioTopologia.tieneHijos(_todasTopologias, nodo.id);
        final tienePoligono =
            nodo.polygon != null && nodo.polygon!.trim().isNotEmpty;

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      tieneHijos ? Icons.account_tree_outlined : Icons.place_outlined,
                      color: widget.primaryColor,
                    ),
                    title: Text(
                      nodo.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      [
                        if (nodo.string_code != null) nodo.string_code!,
                        if (tienePoligono) 'Con polígono',
                        if (tieneHijos) 'Tiene subniveles',
                      ].join(' · '),
                    ),
                  ),
                ),
                if (tieneHijos)
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: 'Entrar',
                    onPressed: () => _entrarEnNodo(nodo),
                  ),
                TextButton(
                  onPressed: () => _seleccionarNodo(nodo),
                  child: const Text('Usar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
