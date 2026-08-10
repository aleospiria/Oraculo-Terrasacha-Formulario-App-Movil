import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/plan_campo_borrador.dart';

/// Almacenamiento local de evidencias fotográficas de un registro de
/// feature/sub-área (ver [RegistroFeatureEjecucion]).
class ServicioEvidenciaRegistro {
  ServicioEvidenciaRegistro._();

  static String _nuevoEvidenciaId() =>
      'ev-reg-${DateTime.now().microsecondsSinceEpoch}';

  static Future<Directory> _directorioEvidencias() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/registros_feature_evidencias');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<EvidenciaRegistroFeature> guardarEvidencia({
    required String rutaOrigen,
    String? descripcion,
  }) async {
    final dir = await _directorioEvidencias();
    final extension = rutaOrigen.contains('.')
        ? rutaOrigen.substring(rutaOrigen.lastIndexOf('.'))
        : '.jpg';
    final id = _nuevoEvidenciaId();
    final destino = '${dir.path}/$id$extension';

    await File(rutaOrigen).copy(destino);

    return EvidenciaRegistroFeature(
      id: id,
      rutaLocal: destino,
      descripcion: descripcion,
      capturadaEn: DateTime.now(),
    );
  }

  static Future<void> eliminarArchivo(String? ruta) async {
    if (ruta == null || ruta.isEmpty) return;
    try {
      final file = File(ruta);
      if (await file.exists()) await file.delete();
    } catch (e) {
      safePrint('No se pudo eliminar evidencia de registro: $e');
    }
  }
}
