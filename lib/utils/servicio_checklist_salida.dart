import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/checklist_salida_ejecucion.dart';

/// Almacenamiento local de evidencias del checklist de salida de campo.
class ServicioChecklistSalida {
  ServicioChecklistSalida._();

  static String _nuevoEvidenciaId() =>
      'ev-chk-${DateTime.now().microsecondsSinceEpoch}';

  static Future<Directory> _directorioChecklist() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/checklist_salida');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<EvidenciaChecklistSalida> guardarEvidencia({
    required String rutaOrigen,
    String? descripcion,
  }) async {
    final dir = await _directorioChecklist();
    final extension = rutaOrigen.contains('.')
        ? rutaOrigen.substring(rutaOrigen.lastIndexOf('.'))
        : '.jpg';
    final id = _nuevoEvidenciaId();
    final destino = '${dir.path}/$id$extension';

    await File(rutaOrigen).copy(destino);

    return EvidenciaChecklistSalida(
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
      safePrint('No se pudo eliminar evidencia de checklist: $e');
    }
  }
}
