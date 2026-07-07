import 'dart:convert';

import 'package:latlong2/latlong.dart';

/// Anillo exterior de un polígono GeoJSON → puntos [lat, lng].
List<LatLng> parseGeoJsonPolygonRing(String? raw) {
  if (raw == null || raw.trim().isEmpty) return [];

  try {
    dynamic decoded = jsonDecode(raw);
    if (decoded is String) {
      decoded = jsonDecode(decoded);
    }
    return _extractOuterRing(decoded);
  } catch (_) {
    return [];
  }
}

List<LatLng> _extractOuterRing(dynamic geo) {
  if (geo is! Map) return [];

  final type = geo['type']?.toString();
  if (type == 'Feature') {
    return _extractOuterRing(geo['geometry']);
  }
  if (type == 'FeatureCollection') {
    final features = geo['features'];
    if (features is List && features.isNotEmpty) {
      return _extractOuterRing(features.first);
    }
    return [];
  }
  if (type == 'Polygon') {
    return _ringToLatLng(geo['coordinates']);
  }
  if (type == 'MultiPolygon') {
    final polys = geo['coordinates'];
    if (polys is List && polys.isNotEmpty) {
      return _ringToLatLng(polys.first);
    }
  }
  return [];
}

List<LatLng> _ringToLatLng(dynamic coordinates) {
  if (coordinates is! List || coordinates.isEmpty) return [];
  final ring = coordinates.first;
  if (ring is! List) return [];

  final points = <LatLng>[];
  for (final coord in ring) {
    if (coord is List && coord.length >= 2) {
      final lng = (coord[0] as num).toDouble();
      final lat = (coord[1] as num).toDouble();
      points.add(LatLng(lat, lng));
    }
  }
  if (points.length > 1 &&
      points.first.latitude == points.last.latitude &&
      points.first.longitude == points.last.longitude) {
    points.removeLast();
  }
  return points;
}

String encodeGeoJsonPolygon(List<LatLng> points) {
  if (points.length < 3) return '';

  final ring = points.map((p) => [p.longitude, p.latitude]).toList();
  final first = ring.first;
  final last = ring.last;
  if (first[0] != last[0] || first[1] != last[1]) {
    ring.add([first[0], first[1]]);
  }

  return jsonEncode({
    'type': 'Polygon',
    'coordinates': [ring],
  });
}

bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
  if (polygon.length < 3) return false;

  var inside = false;
  for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final xi = polygon[i].longitude;
    final yi = polygon[i].latitude;
    final xj = polygon[j].longitude;
    final yj = polygon[j].latitude;

    final intersects = ((yi > point.latitude) != (yj > point.latitude)) &&
        (point.longitude <
            (xj - xi) * (point.latitude - yi) / (yj - yi + 0.0) + xi);
    if (intersects) inside = !inside;
  }
  return inside;
}

/// Todos los vértices de [sub] deben estar dentro de [parent].
bool isPolygonContainedInParent(List<LatLng> sub, List<LatLng> parent) {
  if (sub.length < 3 || parent.length < 3) return false;
  for (final point in sub) {
    if (!isPointInPolygon(point, parent)) return false;
  }
  return true;
}

LatLng? centerOfPoints(List<LatLng> points) {
  if (points.isEmpty) return null;
  var lat = 0.0;
  var lng = 0.0;
  for (final p in points) {
    lat += p.latitude;
    lng += p.longitude;
  }
  return LatLng(lat / points.length, lng / points.length);
}

double boundsZoomForPoints(List<LatLng> points, {double padding = 0.002}) {
  if (points.isEmpty) return 13;
  var minLat = points.first.latitude;
  var maxLat = points.first.latitude;
  var minLng = points.first.longitude;
  var maxLng = points.first.longitude;

  for (final p in points) {
    if (p.latitude < minLat) minLat = p.latitude;
    if (p.latitude > maxLat) maxLat = p.latitude;
    if (p.longitude < minLng) minLng = p.longitude;
    if (p.longitude > maxLng) maxLng = p.longitude;
  }

  final latSpan = (maxLat - minLat).abs() + padding;
  final lngSpan = (maxLng - minLng).abs() + padding;
  final span = latSpan > lngSpan ? latSpan : lngSpan;

  if (span > 2) return 8;
  if (span > 0.5) return 10;
  if (span > 0.1) return 12;
  if (span > 0.02) return 14;
  return 16;
}
