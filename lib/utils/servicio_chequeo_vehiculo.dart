import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chequeo_vehiculo.dart';

/// Gestiona el chequeo de transporte: plantilla de ítems, historial global para
/// clonación, almacenamiento de evidencias/firma en disco y validación de
/// licencia. La fuente de verdad por salida vive en [EjecucionSalida]; este
/// servicio mantiene un historial aparte para reutilizar el último chequeo.
class ServicioChequeoVehiculo {
  ServicioChequeoVehiculo._();

  static const _historialKey = 'chequeos_vehiculo_v1';

  /// Categorías de licencia aceptadas por defecto (Colombia). Configurable.
  static const Set<String> categoriasPermitidasPorDefecto = {
    'B1',
    'B2',
    'B3',
    'C1',
    'C2',
    'C3',
  };

  /// Ítems fijos del chequeo de transporte (formato del formato físico).
  static const List<({String id, String titulo})> _plantillaItems = [
    (id: 'transporte_01', titulo: 'Conductor autorizado'),
    (id: 'transporte_02', titulo: 'Documentos del vehículo al día'),
    (
      id: 'transporte_03',
      titulo: 'Fluidos del vehículo (aceite, líquido de frenos, refrigerante, agua)',
    ),
    (id: 'transporte_04', titulo: 'Frenos'),
    (id: 'transporte_05', titulo: 'Luces y direccionales'),
    (id: 'transporte_06', titulo: 'Kit carretera completo'),
    (id: 'transporte_07', titulo: 'Extintor vigente'),
    (id: 'transporte_08', titulo: 'Ruta definida y compartida'),
    (id: 'transporte_09', titulo: 'Hora máxima retorno definida (no nocturno)'),
    (id: 'transporte_10', titulo: 'Revisión y atención de ruidos extraños en el vehículo'),
  ];

  static String generarId() =>
      'chq-veh-${DateTime.now().microsecondsSinceEpoch}';

  static String _nuevoEvidenciaId() =>
      'ev-${DateTime.now().microsecondsSinceEpoch}';

  /// Lista de ítems vacíos (sin responder) para un chequeo nuevo.
  static List<ItemChequeoTransporte> plantillaItems() {
    return _plantillaItems
        .map((p) => ItemChequeoTransporte(id: p.id, titulo: p.titulo))
        .toList();
  }

  /// Crea un chequeo nuevo en blanco para una salida.
  static ChequeoVehiculoSalida nuevo(String salidaId) {
    final ahora = DateTime.now();
    return ChequeoVehiculoSalida(
      id: generarId(),
      salidaId: salidaId,
      items: plantillaItems(),
      creadoEn: ahora,
      actualizadoEn: ahora,
    );
  }

  // ── Validación de licencia ─────────────────────────────────────────────────

  /// Valida la licencia del conductor: no vencida y con categoría permitida.
  /// Devuelve null si es válida, o un mensaje de error legible.
  static String? validarLicencia(
    ConductorVehiculo conductor, {
    Set<String>? categoriasPermitidas,
  }) {
    if (conductor.nombre.trim().isEmpty) {
      return 'Ingresa el nombre del conductor';
    }
    if (conductor.numeroLicencia.trim().isEmpty) {
      return 'Ingresa el número de licencia';
    }
    if (conductor.vencimientoLicencia == null) {
      return 'Ingresa la fecha de vencimiento de la licencia';
    }
    if (conductor.licenciaVencida) {
      return 'La licencia está vencida';
    }
    final categorias = categoriasPermitidas ?? categoriasPermitidasPorDefecto;
    final cat = conductor.categoriaLicencia.trim().toUpperCase();
    if (cat.isEmpty) {
      return 'Selecciona la categoría de licencia';
    }
    if (!categorias.contains(cat)) {
      return 'Categoría de licencia no autorizada para este vehículo';
    }
    return null;
  }

  // ── Almacenamiento de archivos (evidencias / firma) ────────────────────────

  static Future<Directory> _directorioChequeos() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/chequeos_vehiculo');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Copia un archivo de evidencia al almacenamiento de la app y devuelve la
  /// entidad [EvidenciaChequeoVehiculo] con la ruta local persistente.
  static Future<EvidenciaChequeoVehiculo> guardarEvidencia({
    required String rutaOrigen,
    TipoEvidenciaVehiculo tipo = TipoEvidenciaVehiculo.foto,
    String? descripcion,
  }) async {
    final dir = await _directorioChequeos();
    final extension = rutaOrigen.contains('.')
        ? rutaOrigen.substring(rutaOrigen.lastIndexOf('.'))
        : (tipo == TipoEvidenciaVehiculo.video ? '.mp4' : '.jpg');
    final id = _nuevoEvidenciaId();
    final destino = '${dir.path}/$id$extension';

    await File(rutaOrigen).copy(destino);

    return EvidenciaChequeoVehiculo(
      id: id,
      rutaLocal: destino,
      tipo: tipo,
      descripcion: descripcion,
      capturadaEn: DateTime.now(),
    );
  }

  /// Persiste los bytes de la firma como PNG local y devuelve la ruta.
  static Future<String> guardarFirmaPng(List<int> bytes) async {
    final dir = await _directorioChequeos();
    final ruta =
        '${dir.path}/firma_${DateTime.now().microsecondsSinceEpoch}.png';
    await File(ruta).writeAsBytes(bytes, flush: true);
    return ruta;
  }

  /// Elimina un archivo local silenciosamente (evidencia o firma reemplazada).
  static Future<void> eliminarArchivo(String? ruta) async {
    if (ruta == null || ruta.isEmpty) return;
    try {
      final file = File(ruta);
      if (await file.exists()) await file.delete();
    } catch (e) {
      safePrint('No se pudo eliminar archivo de chequeo: $e');
    }
  }

  // ── Historial global (para clonar) ─────────────────────────────────────────

  static Future<List<ChequeoVehiculoSalida>> _leerHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historialKey) ?? [];
    final lista = <ChequeoVehiculoSalida>[];
    for (final s in raw) {
      try {
        lista.add(
          ChequeoVehiculoSalida.fromJson(jsonDecode(s) as Map<String, dynamic>),
        );
      } catch (e) {
        safePrint('Historial chequeo corrupto: $e');
      }
    }
    return lista;
  }

  static Future<void> _guardarHistorial(
    List<ChequeoVehiculoSalida> historial,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _historialKey,
      historial.map((c) => jsonEncode(c.toJson())).toList(),
    );
  }

  /// Registra (o actualiza) un chequeo completado en el historial global.
  static Future<void> registrarEnHistorial(
    ChequeoVehiculoSalida chequeo,
  ) async {
    if (!chequeo.completado) return;
    final historial = await _leerHistorial();
    historial.removeWhere((c) => c.id == chequeo.id);
    historial.add(chequeo);
    historial.sort((a, b) {
      final fa = a.completadoEn ?? a.actualizadoEn;
      final fb = b.completadoEn ?? b.actualizadoEn;
      return fb.compareTo(fa);
    });
    await _guardarHistorial(historial);
  }

  /// Devuelve el último chequeo completado. Si se indica [placa], prioriza la
  /// misma placa; si no hay coincidencia, devuelve el más reciente en general.
  static Future<ChequeoVehiculoSalida?> obtenerUltimoCompletado({
    String? placa,
  }) async {
    final historial = await _leerHistorial();
    if (historial.isEmpty) return null;

    if (placa != null && placa.trim().isNotEmpty) {
      final normal = placa.trim().toUpperCase();
      for (final c in historial) {
        if (c.placa.trim().toUpperCase() == normal) return c;
      }
    }
    return historial.first;
  }

  /// Construye un chequeo NUEVO (borrador) copiando datos del último chequeo:
  /// placa, marca, ítems, observaciones y conductor. No copia firma ni
  /// evidencias (cada salida debe registrar su propia evidencia y firma).
  static ChequeoVehiculoSalida clonarDesde(
    ChequeoVehiculoSalida origen, {
    required String salidaId,
  }) {
    final ahora = DateTime.now();
    return ChequeoVehiculoSalida(
      id: generarId(),
      salidaId: salidaId,
      aplicaTransporte: origen.aplicaTransporte,
      placa: origen.placa,
      marcaModelo: origen.marcaModelo,
      conductor: origen.conductor.copyWith(),
      items: origen.items
          .map((i) => ItemChequeoTransporte(
                id: i.id,
                titulo: i.titulo,
                respuesta: i.respuesta,
              ))
          .toList(),
      observaciones: origen.observaciones,
      evidencias: const [],
      firma: null,
      clonadoDesdeId: origen.id,
      completado: false,
      creadoEn: ahora,
      actualizadoEn: ahora,
    );
  }
}
