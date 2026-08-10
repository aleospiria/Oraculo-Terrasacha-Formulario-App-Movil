import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/coordenada_actual.dart';
import '../utils/servicio_ubicacion_actual.dart';
import '../theme.dart';

enum EstadoUbicacion {
  inicial,
  sinPermiso,
  permisoDenegadoPermanente,
  servicioDeshabilitado,
  obteniendo,
  activa,
  error,
}

/// Panel de coordenadas GPS: captura automática y visualización de solo lectura.
class CoordenadaActualPanel extends StatefulWidget {
  final bool soloLectura;
  final bool colapsable;
  final bool inicialmenteExpandido;
  final String titulo;
  final ValueChanged<CoordenadaActual?>? onCoordenadaChanged;
  final Color primaryColor;
  final double mapHeight;

  const CoordenadaActualPanel({
    super.key,
    this.soloLectura = true,
    this.colapsable = false,
    this.inicialmenteExpandido = true,
    this.titulo = 'Tu posición actual',
    this.onCoordenadaChanged,
    this.primaryColor = terrasachaPrimaryColor,
    this.mapHeight = 180,
  });

  @override
  State<CoordenadaActualPanel> createState() => _CoordenadaActualPanelState();
}

class _CoordenadaActualPanelState extends State<CoordenadaActualPanel> {
  final MapController _mapController = MapController();

  StreamSubscription<CoordenadaActual>? _suscripcion;
  CoordenadaActual? _coordenada;
  EstadoUbicacion _estado = EstadoUbicacion.inicial;
  String? _mensajeError;
  EstadoPermisoUbicacion? _estadoPermiso;
  late bool _expandido;

  @override
  void initState() {
    super.initState();
    _expandido = widget.inicialmenteExpandido;
    _iniciarEscucha();
  }

  void _alternarExpandido() {
    if (!widget.colapsable) return;
    setState(() => _expandido = !_expandido);
  }

  String _resumenColapsado() {
    if (_estado == EstadoUbicacion.obteniendo) {
      return 'Obteniendo coordenadas GPS…';
    }
    if (_coordenada != null) {
      return _coordenada!.textoFormateado;
    }
    return _mensajeError ?? 'Ubicación no disponible';
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }

  Future<void> _iniciarEscucha() async {
    setState(() {
      _estado = EstadoUbicacion.obteniendo;
      _mensajeError = null;
    });

    final permiso = await GeolocatorPermissionHelper.verificar();
    _estadoPermiso = permiso.estado;

    if (!permiso.tienePermiso) {
      if (!mounted) return;
      setState(() {
        _estado = switch (permiso.estado) {
          EstadoPermisoUbicacion.denegadoPermanentemente =>
            EstadoUbicacion.permisoDenegadoPermanente,
          EstadoPermisoUbicacion.gpsDesactivado =>
            EstadoUbicacion.servicioDeshabilitado,
          _ => EstadoUbicacion.sinPermiso,
        };
        _mensajeError = permiso.mensaje;
      });
      widget.onCoordenadaChanged?.call(null);
      return;
    }

    await _suscripcion?.cancel();
    _suscripcion = ServicioUbicacionActual.escucharPosicion().listen(
      (coord) {
        if (!mounted) return;
        setState(() {
          _coordenada = coord;
          _estado = EstadoUbicacion.activa;
        });
        widget.onCoordenadaChanged?.call(coord);
        _mapController.move(coord.latLng, 16);
      },
      onError: (_) {
        if (!mounted) return;
        setState(() {
          _estado = EstadoUbicacion.error;
          _mensajeError = 'No se pudo obtener la señal GPS';
        });
        widget.onCoordenadaChanged?.call(null);
      },
    );
  }

  Future<void> _abrirAjustesUbicacion() async {
    if (_estadoPermiso == EstadoPermisoUbicacion.gpsDesactivado) {
      await Geolocator.openLocationSettings();
    } else {
      await Geolocator.openAppSettings();
    }
    await _iniciarEscucha();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.colapsable ? _alternarExpandido : null,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: widget.colapsable
                    ? const EdgeInsets.symmetric(vertical: 2)
                    : EdgeInsets.zero,
                child: Row(
                  children: [
                    Icon(Icons.my_location, color: widget.primaryColor, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.titulo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          if (widget.colapsable && !_expandido) ...[
                            const SizedBox(height: 4),
                            Text(
                              _resumenColapsado(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.soloLectura && (!widget.colapsable || _expandido))
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Solo lectura',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: widget.primaryColor,
                          ),
                        ),
                      ),
                    if (widget.colapsable) ...[
                      const SizedBox(width: 4),
                      Icon(
                        _expandido ? Icons.expand_less : Icons.expand_more,
                        color: widget.primaryColor,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.soloLectura) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Las coordenadas se capturan del GPS al finalizar el registro. No se pueden editar manualmente.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
                const SizedBox(height: 12),
                _buildContenido(),
              ],
            ),
            crossFadeState: !widget.colapsable || _expandido
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }

  Widget _buildContenido() {
    if (_estado == EstadoUbicacion.obteniendo) {
      return _buildEstadoCarga();
    }

    if (_estado == EstadoUbicacion.sinPermiso ||
        _estado == EstadoUbicacion.permisoDenegadoPermanente ||
        _estado == EstadoUbicacion.servicioDeshabilitado ||
        _estado == EstadoUbicacion.error) {
      return _buildEstadoError();
    }

    if (_coordenada == null) {
      return _buildEstadoCarga();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMapa(_coordenada!.latLng),
        const SizedBox(height: 12),
        _buildFilaDato('Latitud', _coordenada!.latitud.toStringAsFixed(6)),
        const SizedBox(height: 6),
        _buildFilaDato('Longitud', _coordenada!.longitud.toStringAsFixed(6)),
        if (_coordenada!.precisionMetros != null) ...[
          const SizedBox(height: 6),
          _buildFilaDato(
            'Precisión',
            '± ${_coordenada!.precisionMetros!.toStringAsFixed(1)} m',
          ),
        ],
        const SizedBox(height: 6),
        Text(
          _coordenada!.textoFormateado,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildFilaDato(String etiqueta, String valor) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            etiqueta,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
        Expanded(
          child: Text(
            valor,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapa(LatLng punto) {
    final interaccion = widget.soloLectura
        ? const InteractionOptions(flags: InteractiveFlag.none)
        : const InteractionOptions(
            flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: widget.mapHeight,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: punto,
            initialZoom: 16,
            interactionOptions: interaccion,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.example.capturador_datos_offline',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: punto,
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.location_on,
                    color: widget.primaryColor,
                    size: 36,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoCarga() {
    return SizedBox(
      height: widget.mapHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: widget.primaryColor),
            const SizedBox(height: 12),
            Text(
              'Obteniendo coordenadas GPS…',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoError() {
    final esPermiso = _estado == EstadoUbicacion.sinPermiso ||
        _estado == EstadoUbicacion.permisoDenegadoPermanente;
    final esGps = _estado == EstadoUbicacion.servicioDeshabilitado;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          esGps
              ? Icons.location_disabled
              : esPermiso
                  ? Icons.location_off
                  : Icons.gps_off,
          size: 40,
          color: Colors.orange.shade700,
        ),
        const SizedBox(height: 8),
        Text(
          _mensajeError ?? 'Ubicación no disponible',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
        ),
        const SizedBox(height: 12),
        if (_estado == EstadoUbicacion.sinPermiso)
          FilledButton.icon(
            onPressed: _iniciarEscucha,
            icon: const Icon(Icons.location_searching),
            label: const Text('Permitir ubicación'),
            style: FilledButton.styleFrom(
              backgroundColor: widget.primaryColor,
            ),
          ),
        if (_estado == EstadoUbicacion.permisoDenegadoPermanente ||
            _estado == EstadoUbicacion.servicioDeshabilitado)
          OutlinedButton.icon(
            onPressed: _abrirAjustesUbicacion,
            icon: const Icon(Icons.settings),
            label: Text(
              esGps ? 'Activar GPS' : 'Abrir configuración',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: widget.primaryColor,
              side: BorderSide(color: widget.primaryColor),
            ),
          ),
        if (_estado == EstadoUbicacion.error) ...[
          OutlinedButton.icon(
            onPressed: _iniciarEscucha,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: widget.primaryColor,
              side: BorderSide(color: widget.primaryColor),
            ),
          ),
        ],
      ],
    );
  }
}

/// Resultado de verificación de permisos de ubicación.
class GeolocatorPermissionHelper {
  static Future<
      ({
        bool tienePermiso,
        EstadoPermisoUbicacion estado,
        String mensaje,
      })> verificar() async {
    final estado = await ServicioUbicacionActual.solicitarPermiso();

    return switch (estado) {
      EstadoPermisoUbicacion.concedido => (
          tienePermiso: true,
          estado: estado,
          mensaje: '',
        ),
      EstadoPermisoUbicacion.denegado => (
          tienePermiso: false,
          estado: estado,
          mensaje:
              'Terrasacha necesita acceso a tu ubicación para mostrar las coordenadas del registro en campo.',
        ),
      EstadoPermisoUbicacion.denegadoPermanentemente => (
          tienePermiso: false,
          estado: estado,
          mensaje:
              'El permiso de ubicación fue denegado. Ábrelo en la configuración del celular para continuar.',
        ),
      EstadoPermisoUbicacion.gpsDesactivado => (
          tienePermiso: false,
          estado: estado,
          mensaje:
              'Activa el GPS del celular para ver tu posición actual.',
        ),
    };

  }
}
