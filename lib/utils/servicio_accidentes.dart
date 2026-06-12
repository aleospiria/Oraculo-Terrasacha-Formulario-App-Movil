import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/reporte_accidente.dart';

class ServicioAccidentes {
  static final ServicioAccidentes _instancia = ServicioAccidentes._();
  factory ServicioAccidentes() => _instancia;
  ServicioAccidentes._();

  Directory? _directorio;

  Future<Directory> get directorio async {
    if (_directorio != null) return _directorio!;
    final appDir = await getApplicationDocumentsDirectory();
    _directorio = Directory('${appDir.path}/reportes_accidentes');
    if (!await _directorio!.exists()) {
      await _directorio!.create(recursive: true);
    }
    return _directorio!;
  }

  Future<String> _rutaArchivo(String id) async => '${(await directorio).path}/$id.json';

  Future<List<ReporteAccidente>> listar() async {
    final dir = await directorio;
    final files = dir.listSync().whereType<File>().toList();
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    final reportes = <ReporteAccidente>[];
    for (final file in files) {
      if (!file.path.endsWith('.json')) continue;
      try {
        final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        reportes.add(ReporteAccidente.fromJson(json));
      } catch (_) {}
    }
    return reportes;
  }

  Future<ReporteAccidente?> obtener(String id) async {
    final file = File(await _rutaArchivo(id));
    if (!await file.exists()) return null;
    try {
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return ReporteAccidente.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> guardar(ReporteAccidente reporte) async {
    final file = File(await _rutaArchivo(reporte.id));
    await file.writeAsString(jsonEncode(reporte.toJson()));
  }

  Future<void> eliminar(String id) async {
    final file = File(await _rutaArchivo(id));
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<int> contar() async {
    final dir = await directorio;
    return dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).length;
  }
}
