import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../models/coordenada_actual.dart';

enum EstadoPermisoUbicacion {
  concedido,
  denegado,
  denegadoPermanentemente,
  gpsDesactivado,
}

/// Servicio centralizado para obtener la posición GPS del dispositivo.
class ServicioUbicacionActual {
  ServicioUbicacionActual._();

  /// Solicita permiso si hace falta y comprueba que el GPS esté activo.
  static Future<EstadoPermisoUbicacion> solicitarPermiso() async {
    var permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.deniedForever) {
      return EstadoPermisoUbicacion.denegadoPermanentemente;
    }

    if (permiso == LocationPermission.denied) {
      return EstadoPermisoUbicacion.denegado;
    }

    final servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      return EstadoPermisoUbicacion.gpsDesactivado;
    }

    return EstadoPermisoUbicacion.concedido;
  }

  /// Comprueba permisos y que el GPS esté habilitado.
  static Future<bool> asegurarPermisos() async {
    final estado = await solicitarPermiso();
    return estado == EstadoPermisoUbicacion.concedido;
  }

  /// Una lectura puntual (p. ej. al guardar el registro).
  static Future<CoordenadaActual?> obtenerUnaVez() async {
    final listo = await asegurarPermisos();
    if (!listo) return null;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return CoordenadaActual.desdePosition(position);
    } catch (_) {
      return null;
    }
  }

  /// Stream de posición en tiempo real para la UI del operador.
  static Stream<CoordenadaActual> escucharPosicion() async* {
    final estado = await solicitarPermiso();
    if (estado != EstadoPermisoUbicacion.concedido) {
      throw StateError('Ubicación no disponible: $estado');
    }

    yield* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).map(CoordenadaActual.desdePosition);
  }
}
