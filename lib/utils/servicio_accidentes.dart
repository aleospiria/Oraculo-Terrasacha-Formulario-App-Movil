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

  Future<Directory> _directorioFotos(String id) async {
    final dir = Directory('${(await directorio).path}/${id}_fotos');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

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

  Future<String> guardarFoto(String id, File foto) async {
    final dir = await _directorioFotos(id);
    final ts = DateTime.now();
    final nombre = 'foto_${ts.year}${ts.month.toString().padLeft(2, '0')}${ts.day.toString().padLeft(2, '0')}_'
        '${ts.hour.toString().padLeft(2, '0')}${ts.minute.toString().padLeft(2, '0')}${ts.second.toString().padLeft(2, '0')}.jpg';
    final destino = File('${dir.path}/$nombre');
    await foto.copy(destino.path);
    return nombre;
  }

  Future<void> eliminarFoto(String id, String nombreFoto) async {
    final dir = await _directorioFotos(id);
    final file = File('${dir.path}/$nombreFoto');
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<String> obtenerRutaFoto(String id, String nombreFoto) async {
    final dir = await _directorioFotos(id);
    return '${dir.path}/$nombreFoto';
  }

  Future<void> eliminar(String id) async {
    final file = File(await _rutaArchivo(id));
    if (await file.exists()) {
      await file.delete();
    }
    final fotosDir = await _directorioFotos(id);
    if (await fotosDir.exists()) {
      await fotosDir.delete(recursive: true);
    }
  }

  Future<int> contar() async {
    final dir = await directorio;
    return dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).length;
  }
}
