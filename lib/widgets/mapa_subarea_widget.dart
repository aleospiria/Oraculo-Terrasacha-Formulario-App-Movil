import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../utils/geojson_topology_helpers.dart';
import '../theme.dart';

class MapaSubareaWidget extends StatefulWidget {
  final List<LatLng> poligonoPadre;
  final List<LatLng> puntosSubarea;
  final ValueChanged<List<LatLng>> onPuntosChanged;
  final Color primaryColor;

  const MapaSubareaWidget({
    super.key,
    required this.poligonoPadre,
    required this.puntosSubarea,
    required this.onPuntosChanged,
    this.primaryColor = terrasachaPrimaryColor,
  });

  @override
  State<MapaSubareaWidget> createState() => _MapaSubareaWidgetState();
}

class _MapaSubareaWidgetState extends State<MapaSubareaWidget> {
  late List<LatLng> _puntos;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _puntos = List<LatLng>.from(widget.puntosSubarea);
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centrarMapa());
  }

  @override
  void didUpdateWidget(MapaSubareaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.puntosSubarea != widget.puntosSubarea) {
      _puntos = List<LatLng>.from(widget.puntosSubarea);
    }
    if (oldWidget.poligonoPadre != widget.poligonoPadre) {
      _centrarMapa();
    }
  }

  void _centrarMapa() {
    final all = [...widget.poligonoPadre, ..._puntos];
    final center = centerOfPoints(all) ?? const LatLng(4.6, -74.08);
    final zoom = boundsZoomForPoints(all);
    _mapController.move(center, zoom);
  }

  void _handleTap(TapPosition tapPosition, LatLng point) {
    setState(() => _puntos.add(point));
    widget.onPuntosChanged(_puntos);
  }

  void _deshacerPunto() {
    if (_puntos.isEmpty) return;
    setState(() => _puntos.removeLast());
    widget.onPuntosChanged(_puntos);
  }

  void _limpiar() {
    setState(() => _puntos.clear());
    widget.onPuntosChanged(_puntos);
  }

  @override
  Widget build(BuildContext context) {
    final padreCerrado = widget.poligonoPadre.length >= 3
        ? [...widget.poligonoPadre, widget.poligonoPadre.first]
        : <LatLng>[];
    final subCerrado =
        _puntos.length >= 3 ? [..._puntos, _puntos.first] : _puntos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 300,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    centerOfPoints(widget.poligonoPadre) ??
                        const LatLng(4.6, -74.08),
                initialZoom: boundsZoomForPoints(widget.poligonoPadre),
                onTap: _handleTap,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.capturador_datos_offline',
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap',
                      onTap: () {},
                    ),
                    TextSourceAttribution(
                      'CARTO',
                      onTap: () {},
                    ),
                  ],
                ),
                if (padreCerrado.length >= 4)
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: padreCerrado,
                        color: Colors.blue.withValues(alpha: 0.12),
                        borderColor: Colors.blue.shade700,
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                if (subCerrado.length >= 2)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: subCerrado,
                        color: widget.primaryColor,
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                if (_puntos.isNotEmpty)
                  MarkerLayer(
                    markers: _puntos
                        .map(
                          (p) => Marker(
                            point: p,
                            width: 14,
                            height: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                'Toca el mapa (dentro del área azul) para añadir vértices. ${_puntos.length}/3 mínimo.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            TextButton(onPressed: _deshacerPunto, child: const Text('Deshacer')),
            TextButton(onPressed: _limpiar, child: const Text('Limpiar')),
          ],
        ),
        Row(
          children: [
            Icon(Icons.crop_square, size: 14, color: Colors.blue.shade700),
            const SizedBox(width: 4),
            Text(
              'Polígono padre',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(Icons.pentagon_outlined, size: 14, color: widget.primaryColor),
            const SizedBox(width: 4),
            Text(
              'Subárea del día',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );

  }
}
