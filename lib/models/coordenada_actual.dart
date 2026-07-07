import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Posición GPS capturada en campo (dispositivo o RTK futuro).
class CoordenadaActual {
  final double latitud;
  final double longitud;
  final double? precisionMetros;
  final DateTime capturadaEn;

  const CoordenadaActual({
    required this.latitud,
    required this.longitud,
    this.precisionMetros,
    required this.capturadaEn,
  });

  LatLng get latLng => LatLng(latitud, longitud);

  String get textoFormateado =>
      '${latitud.toStringAsFixed(6)}, ${longitud.toStringAsFixed(6)}';

  factory CoordenadaActual.desdePosition(Position position) {
    return CoordenadaActual(
      latitud: position.latitude,
      longitud: position.longitude,
      precisionMetros: position.accuracy,
      capturadaEn: position.timestamp,
    );
  }

  factory CoordenadaActual.fromJson(Map<String, dynamic> json) {
    return CoordenadaActual(
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      precisionMetros: (json['precisionMetros'] as num?)?.toDouble(),
      capturadaEn: DateTime.parse(json['capturadaEn'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'latitud': latitud,
        'longitud': longitud,
        if (precisionMetros != null) 'precisionMetros': precisionMetros,
        'capturadaEn': capturadaEn.toIso8601String(),
      };
}

/// Indica si la plantilla incluye captura de coordenadas GPS.
bool plantillaRequiereCoordenadasGps(List<String> featureNombres) {
  return featureNombres.any((nombre) {
    final n = nombre.toLowerCase();
    return n.contains('coordenad') ||
        n.contains('gps') ||
        n.contains('ubicación') ||
        n.contains('ubicacion');
  });
}
