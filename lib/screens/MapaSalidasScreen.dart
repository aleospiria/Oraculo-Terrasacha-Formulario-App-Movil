import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../main.dart';
import '../models/plan_campo_borrador.dart';
import '../utils/geojson_topology_helpers.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_salida.dart';
import 'DetalleSalidaScreen.dart';
import '../theme.dart';

/// Mapa consolidado de las salidas de campo: dibuja las topologías
/// (polígono padre + subáreas por día) y ubica cada medición registrada al
/// finalizar una asignación de plantilla, con su información al tocarla.
///
/// El líder de proyecto y el líder de cuadrilla ven todas las salidas
/// activas; el operador solo ve las salidas donde participa, y dentro de
/// ellas ve todos los puntos registrados del predio/salida.
class MapaSalidasScreen extends StatefulWidget {
  const MapaSalidasScreen({super.key, this.embedded = false});

  /// Cuando es true, la barra inferior la provee [PanelControlScreen].
  final bool embedded;

  @override
  State<MapaSalidasScreen> createState() => _MapaSalidasScreenState();
}

/// Paleta estable para diferenciar visualmente cada salida en el mapa.
const List<Color> _paletaSalidas = [
  Color(0xFF2B6CB0), // azul
  Color(0xFFDD6B20), // naranja
  Color(0xFF6B46C1), // morado
  Color(0xFF2C7A7B), // teal
  Color(0xFFC53030), // rojo
  Color(0xFF9C4221), // marrón
  Color(0xFFB83280), // rosa
  Color(0xFF276749), // verde
];

Color _colorParaSalida(String salidaId) {
  final hash = salidaId.codeUnits.fold<int>(0, (sum, c) => sum + c);
  return _paletaSalidas[hash % _paletaSalidas.length];
}

/// Un punto de medición: la coordenada guardada al registrar una feature
/// concreta de una asignación de plantilla, junto con el contexto necesario
/// para mostrarla.
class _PuntoMedicion {
  final LatLng punto;
  final SalidaCampo salida;
  final AsignacionPlantillaPlan plantilla;
  final String featureNombre;
  final double? precisionMetros;
  final DateTime? capturadoEn;
  final String? observaciones;
  final String? rutaAudio;
  final Color color;

  const _PuntoMedicion({
    required this.punto,
    required this.salida,
    required this.plantilla,
    required this.featureNombre,
    this.precisionMetros,
    this.capturadoEn,
    this.observaciones,
    this.rutaAudio,
    required this.color,
  });
}

/// Todo lo que hay que dibujar de una salida: sus polígonos y sus puntos.
class _SalidaMapa {
  final SalidaCampo salida;
  final Color color;
  final List<LatLng> poligonoPadre;
  final List<List<LatLng>> subAreas;
  final List<_PuntoMedicion> puntos;

  const _SalidaMapa({
    required this.salida,
    required this.color,
    required this.poligonoPadre,
    required this.subAreas,
    required this.puntos,
  });

  List<LatLng> get todosLosPuntos => [
        ...poligonoPadre,
        for (final s in subAreas) ...s,
        for (final p in puntos) p.punto,
      ];
}

class _MapaSalidasScreenState extends State<MapaSalidasScreen> {
  static const Color primaryColor = terrasachaPrimaryColor;
  static const Color backgroundColor = terrasachaBackgroundColor;
  static const LatLng _centroPorDefecto = LatLng(4.6, -74.08);

  final MapController _mapController = MapController();

  bool _cargando = true;
  List<_SalidaMapa> _salidasMapa = [];
  String? _salidaSeleccionadaId;
  bool _mostrarPredios = true;
  bool _mostrarPuntos = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  bool get _esOperador => hasRole('operador');
  bool get _puedeVerDetalleSalida =>
      hasAnyRole(['lider_cuadrilla', 'lider_proyecto']);

  Future<void> _cargar() async {
    setState(() => _cargando = true);

    final usuario = await servicioAutenticacion.getUsuarioActual();
    final todas = await ServicioSalida.listar();
    final salidasPermitidasOperador = <String>{};
    if (_esOperador && usuario != null) {
      final permitidas = await ServicioSalida.listarSalidasParaUsuario(usuario);
      salidasPermitidasOperador.addAll(permitidas.map((s) => s.id));
    }

    final activas = todas.where(
      (s) =>
          s.estado != EstadoSalida.borrador &&
          s.estado != EstadoSalida.cancelada &&
          s.estado != EstadoSalida.caducada,
    );

    final salidasMapa = <_SalidaMapa>[];

    for (final salida in activas) {
      if (_esOperador) {
        if (usuario == null) continue;
        if (!salidasPermitidasOperador.contains(salida.id)) continue;
      }

      // El operador ve todos los puntos de la salida donde participa.
      final plantillas = salida.asignacionesPlantillas;

      final color = _colorParaSalida(salida.id);
      final poligonoPadre = parseGeoJsonPolygonRing(salida.poligonoPadreGeoJson);
      final subAreas = salida.subAreasPorDia
          .map((d) => parseGeoJsonPolygonRing(d.subAreaGeoJson))
          .where((pts) => pts.length >= 3)
          .toList();

      final ejecucion = await ServicioSalida.obtenerEjecucion(salida.id);
      final puntos = <_PuntoMedicion>[];

      for (final plantilla in plantillas) {
        final ejec = ejecucion.asignaciones
            .where((a) => a.asignacionId == plantilla.id)
            .toList();
        if (ejec.isEmpty) continue;
        final asignacionEjec = ejec.first;

        if (asignacionEjec.registrosFeatures.isNotEmpty) {
          for (final registro in asignacionEjec.registrosFeatures) {
            if (!registro.tieneCoordenadas) continue;
            puntos.add(
              _PuntoMedicion(
                punto: LatLng(registro.latitud!, registro.longitud!),
                salida: salida,
                plantilla: plantilla,
                featureNombre: registro.featureNombre,
                precisionMetros: registro.precisionMetros,
                capturadoEn: registro.coordenadasCapturadasEn,
                observaciones: registro.observaciones,
                rutaAudio: registro.rutaAudio,
                color: color,
              ),
            );
          }
        } else if (asignacionEjec.tieneCoordenadas) {
          // Dato legacy de antes del registro granular por feature: una
          // sola coordenada para toda la asignación.
          puntos.add(
            _PuntoMedicion(
              punto: LatLng(asignacionEjec.latitud!, asignacionEjec.longitud!),
              salida: salida,
              plantilla: plantilla,
              featureNombre: plantilla.featureNombres.join(', '),
              precisionMetros: asignacionEjec.precisionMetros,
              capturadoEn: asignacionEjec.coordenadasCapturadasEn,
              observaciones: asignacionEjec.observaciones,
              rutaAudio: asignacionEjec.rutaAudio,
              color: color,
            ),
          );
        }
      }

      if (poligonoPadre.isEmpty && subAreas.isEmpty && puntos.isEmpty) {
        continue;
      }

      salidasMapa.add(
        _SalidaMapa(
          salida: salida,
          color: color,
          poligonoPadre: poligonoPadre,
          subAreas: subAreas,
          puntos: puntos,
        ),
      );
    }

    if (!mounted) return;
    final seleccionAnterior = _salidaSeleccionadaId;
    String? seleccionActualizada;
    if (seleccionAnterior != null &&
        salidasMapa.any((s) => s.salida.id == seleccionAnterior)) {
      seleccionActualizada = seleccionAnterior;
    }
    setState(() {
      _salidasMapa = salidasMapa;
      _salidaSeleccionadaId = seleccionActualizada;
      _cargando = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _centrarEnTodo());
  }

  List<LatLng> get _todosLosPuntos =>
      _salidasMapa.expand((s) => s.todosLosPuntos).toList();

  void _centrarEnTodo() {
    final puntos = _todosLosPuntos;
    if (puntos.isEmpty) return;
    final centro = centerOfPoints(puntos) ?? _centroPorDefecto;
    final zoom = boundsZoomForPoints(puntos);
    _mapController.move(centro, zoom);
  }

  void _centrarEnSalida(_SalidaMapa s) {
    final puntosPredio = s.poligonoPadre.length >= 3
        ? s.poligonoPadre
        : (s.subAreas.isNotEmpty ? s.subAreas.first : s.todosLosPuntos);
    if (puntosPredio.isEmpty) return;
    final centro = centerOfPoints(puntosPredio) ?? _centroPorDefecto;
    final zoomCalculado = boundsZoomForPoints(puntosPredio);
    // Acercamiento moderado para ubicar el predio sin sobre-zoom.
    final zoom = zoomCalculado < 13.2 ? 13.2 : zoomCalculado;
    _mapController.move(centro, zoom);
  }

  bool _esSalidaActiva(_SalidaMapa salidaMapa) {
    if (_salidaSeleccionadaId == null) return true;
    return salidaMapa.salida.id == _salidaSeleccionadaId;
  }

  void _seleccionarDesdeLeyenda(_SalidaMapa salidaMapa) {
    setState(() {
      if (_salidaSeleccionadaId == salidaMapa.salida.id) {
        _salidaSeleccionadaId = null;
      } else {
        _salidaSeleccionadaId = salidaMapa.salida.id;
      }
    });
    if (_salidaSeleccionadaId != null) {
      _centrarEnSalida(salidaMapa);
    }
  }

  _SalidaMapa? get _salidaSeleccionada {
    final id = _salidaSeleccionadaId;
    if (id == null) return null;
    for (final s in _salidasMapa) {
      if (s.salida.id == id) return s;
    }
    return null;
  }

  Future<void> _abrirDetalleSalidaSeleccionada() async {
    final salidaMapa = _salidaSeleccionada;
    if (salidaMapa == null) return;
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleSalidaScreen(salidaId: salidaMapa.salida.id),
      ),
    );
    if (mounted) await _cargar();
  }

  String _formatFechaHora(DateTime? fecha) {
    if (fecha == null) return '—';
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    final h = fecha.hour.toString().padLeft(2, '0');
    final min = fecha.minute.toString().padLeft(2, '0');
    return '$d/$m/${fecha.year} · $h:$min';
  }

  Future<void> _mostrarInfoPunto(_PuntoMedicion p) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (ctx, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: p.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p.salida.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${p.plantilla.templateNombre} · ${p.featureNombre}',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
              const Divider(height: 24),
              _buildFilaInfo(
                Icons.person_outline,
                'Responsable',
                '${p.plantilla.operadorNombre} · ${p.plantilla.operadorRol}',
              ),
              const SizedBox(height: 10),
              _buildFilaInfo(
                Icons.schedule,
                'Registrado',
                _formatFechaHora(p.capturadoEn),
              ),
              const SizedBox(height: 10),
              _buildFilaInfo(
                Icons.my_location,
                'Coordenadas',
                '${p.punto.latitude.toStringAsFixed(6)}, ${p.punto.longitude.toStringAsFixed(6)}',
              ),
              if (p.precisionMetros != null) ...[
                const SizedBox(height: 10),
                _buildFilaInfo(
                  Icons.gps_fixed,
                  'Precisión GPS',
                  '± ${p.precisionMetros!.toStringAsFixed(1)} m',
                ),
              ],
              if ((p.observaciones ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                const Text(
                  'Observaciones',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  p.observaciones!.trim(),
                  style: TextStyle(color: Colors.grey[800], fontSize: 13),
                ),
              ],
              if (p.rutaAudio != null) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.mic_outlined, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 6),
                    Text(
                      'Audio adjunto',
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilaInfo(IconData icono, String etiqueta, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 18, color: primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final puntosIniciales = _todosLosPuntos;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: widget.embedded
            ? null
            : IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: !widget.embedded,
        title: const Text(
          'Mapa de salidas',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh, color: primaryColor),
            onPressed: _cargar,
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _salidasMapa.isEmpty
              ? _buildVacio()
              : Column(
                  children: [
                    Expanded(
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter:
                              centerOfPoints(puntosIniciales) ?? _centroPorDefecto,
                          initialZoom: boundsZoomForPoints(puntosIniciales),
                          onTap: (_, tapPosition) {
                            if (_salidaSeleccionadaId != null) {
                              setState(() => _salidaSeleccionadaId = null);
                            }
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                            subdomains: const ['a', 'b', 'c', 'd'],
                            userAgentPackageName:
                                'com.example.capturador_datos_offline',
                          ),
                          RichAttributionWidget(
                            attributions: [
                              TextSourceAttribution('OpenStreetMap', onTap: () {}),
                              TextSourceAttribution('CARTO', onTap: () {}),
                            ],
                          ),
                          if (_mostrarPredios)
                            PolygonLayer(
                              polygons: [
                                for (final s in _salidasMapa)
                                  if (s.poligonoPadre.length >= 3)
                                    Polygon(
                                      points: [
                                        ...s.poligonoPadre,
                                        s.poligonoPadre.first,
                                      ],
                                      color: s.color.withValues(
                                        alpha: _esSalidaActiva(s) ? 0.12 : 0.03,
                                      ),
                                      borderColor: _esSalidaActiva(s)
                                          ? s.color
                                          : s.color.withValues(alpha: 0.35),
                                      borderStrokeWidth: _esSalidaActiva(s) ? 2.4 : 1.2,
                                    ),
                                for (final s in _salidasMapa)
                                  for (final sub in s.subAreas)
                                    Polygon(
                                      points: [...sub, sub.first],
                                      color: s.color.withValues(
                                        alpha: _esSalidaActiva(s) ? 0.20 : 0.05,
                                      ),
                                      borderColor: _esSalidaActiva(s)
                                          ? s.color
                                          : s.color.withValues(alpha: 0.35),
                                      borderStrokeWidth: _esSalidaActiva(s) ? 1.8 : 1.1,
                                      pattern: const StrokePattern.dotted(),
                                    ),
                              ],
                            ),
                          if (_mostrarPuntos)
                            MarkerLayer(
                              markers: [
                                for (final s in _salidasMapa)
                                  for (final p in s.puntos)
                                    Marker(
                                      point: p.punto,
                                      width: _esSalidaActiva(s) ? 34 : 28,
                                      height: _esSalidaActiva(s) ? 34 : 28,
                                      child: GestureDetector(
                                        onTap: () => _mostrarInfoPunto(p),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _esSalidaActiva(s)
                                                ? p.color
                                                : p.color.withValues(alpha: 0.5),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.25,
                                                ),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    _buildControlesMapa(),
                    if (_salidaSeleccionada != null) _buildPanelSeleccion(),
                    _buildLeyenda(),
                  ],
                ),
    );
  }

  Widget _buildVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 56, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _esOperador
                  ? 'No tienes salidas con topología o mediciones registradas'
                  : 'No hay salidas con topología o mediciones registradas',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeyenda() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _salidasMapa.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final s = _salidasMapa[index];
            final seleccionada = _salidaSeleccionadaId == s.salida.id;
            final colorTexto = seleccionada ? s.color : Colors.black87;
            return Theme(
              data: Theme.of(context).copyWith(
                chipTheme: Theme.of(context).chipTheme.copyWith(
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorTexto,
                      ),
                      secondaryLabelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorTexto,
                      ),
                    ),
              ),
              child: ChoiceChip(
                avatar: CircleAvatar(backgroundColor: s.color, radius: 6),
                label: Text(
                  '${s.salida.nombre} (${s.puntos.length})',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        seleccionada ? FontWeight.w700 : FontWeight.w500,
                    color: colorTexto,
                  ),
                ),
                selected: seleccionada,
                onSelected: (_) => _seleccionarDesdeLeyenda(s),
                selectedColor: s.color.withValues(alpha: 0.18),
                backgroundColor: Colors.grey.shade100,
                surfaceTintColor: Colors.transparent,
                checkmarkColor: s.color,
                side: BorderSide(
                  color: seleccionada ? s.color : Colors.grey.shade400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlesMapa() {
    final totalPredios = _salidasMapa.length;
    final totalPuntos = _salidasMapa.fold<int>(0, (sum, s) => sum + s.puntos.length);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Predios: $totalPredios · Registros GPS: $totalPuntos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _salidaSeleccionada == null ? null : _mostrarListaPuntos,
                icon: const Icon(Icons.list_alt_outlined, size: 16),
                label: const Text('Ver puntos'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              FilterChip(
                selected: _mostrarPredios,
                label: const Text('Predios'),
                onSelected: (v) => setState(() => _mostrarPredios = v),
              ),
              FilterChip(
                selected: _mostrarPuntos,
                label: const Text('Puntos GPS'),
                onSelected: (v) => setState(() => _mostrarPuntos = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarListaPuntos() async {
    final salidaMapa = _salidaSeleccionada;
    if (salidaMapa == null || salidaMapa.puntos.isEmpty) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.65,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Puntos registrados · ${salidaMapa.salida.nombre}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: salidaMapa.puntos.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final punto = salidaMapa.puntos[index];
                      return ListTile(
                        dense: true,
                        leading: Icon(Icons.place, color: salidaMapa.color),
                        title: Text(
                          punto.featureNombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${punto.punto.latitude.toStringAsFixed(5)}, '
                          '${punto.punto.longitude.toStringAsFixed(5)}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(context);
                          _mapController.move(
                            punto.punto,
                            17,
                          );
                          _mostrarInfoPunto(punto);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPanelSeleccion() {
    final seleccion = _salidaSeleccionada;
    if (seleccion == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: seleccion.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: seleccion.color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seleccion.salida.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${seleccion.puntos.length} punto(s) · '
                    '${seleccion.subAreas.length} subárea(s)',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            if (_puedeVerDetalleSalida)
              TextButton(
                onPressed: _abrirDetalleSalidaSeleccionada,
                child: const Text('Ver detalle'),
              ),
            if (_puedeVerDetalleSalida) const SizedBox(width: 4),
            TextButton(
              onPressed: seleccion.puntos.isEmpty ? null : _mostrarListaPuntos,
              child: const Text('Ver puntos'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();

  }
}
