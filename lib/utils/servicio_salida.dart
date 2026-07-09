import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/checklist_salida_ejecucion.dart';
import '../models/chequeo_vehiculo.dart';
import '../models/coordenada_actual.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';

class ServicioSalida {
  ServicioSalida._();

  static const _salidasKey = 'salidas_campo_v1';
  static const _ejecucionesKey = 'ejecuciones_salida_v1';
  static const _legacyBorradoresKey = 'planes_campo_borradores';
  static const _migracionHechaKey = 'salidas_migracion_legacy_v1';

  static String generarId() => 'salida-${DateTime.now().microsecondsSinceEpoch}';

  static String _nuevaAsignacionId() =>
      'asig-${DateTime.now().microsecondsSinceEpoch}';

  static Future<void> _asegurarMigracionLegacy() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_migracionHechaKey) == true) return;

    final legacy = prefs.getStringList(_legacyBorradoresKey) ?? [];
    if (legacy.isEmpty) {
      await prefs.setBool(_migracionHechaKey, true);
      return;
    }

    final salidas = await _leerSalidasSinMigrar();
    final ahora = DateTime.now();

    for (final raw in legacy) {
      try {
        final plan = PlanCampoBorrador.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
        final id = generarId();
        salidas.add(
          SalidaCampo.desdePlan(plan, id: id).copyWith(
            estado: EstadoSalida.programada,
            publicadoEn: plan.creadoEn,
            actualizadoEn: ahora,
          ),
        );
        await _guardarEjecucion(
          _crearEjecucionVacia(id, salidas.last),
        );
      } catch (e) {
        safePrint('Migración borrador legacy: $e');
      }
    }

    await _guardarSalidas(salidas);
    await prefs.setBool(_migracionHechaKey, true);
  }

  static Future<List<SalidaCampo>> _leerSalidasSinMigrar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_salidasKey) ?? [];
    return raw
        .map((s) => SalidaCampo.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _guardarSalidas(List<SalidaCampo> salidas) async {
    final prefs = await SharedPreferences.getInstance();
    salidas.sort((a, b) => b.actualizadoEn.compareTo(a.actualizadoEn));
    await prefs.setStringList(
      _salidasKey,
      salidas.map((s) => jsonEncode(s.toJson())).toList(),
    );
  }

  static Future<List<SalidaCampo>> listar() async {
    await _asegurarMigracionLegacy();
    return _leerSalidasSinMigrar();
  }

  static Future<SalidaCampo?> obtener(String id) async {
    final salidas = await listar();
    for (final s in salidas) {
      if (s.id == id) return s;
    }
    return null;
  }

  static Future<SalidaCampo> guardar(SalidaCampo salida) async {
    final salidas = await listar();
    final index = salidas.indexWhere((s) => s.id == salida.id);
    final actualizada = salida.copyWith(actualizadoEn: DateTime.now());

    if (index >= 0) {
      salidas[index] = actualizada;
    } else {
      salidas.add(actualizada);
    }

    await _guardarSalidas(salidas);
    return actualizada;
  }

  /// Elimina una salida y su ejecución asociada del dispositivo.
  static Future<bool> eliminar(String salidaId) async {
    final salidas = await listar();
    final index = salidas.indexWhere((s) => s.id == salidaId);
    if (index < 0) return false;

    salidas.removeAt(index);
    await _guardarSalidas(salidas);

    final prefs = await SharedPreferences.getInstance();
    final ejecucionesRaw = prefs.getStringList(_ejecucionesKey) ?? [];
    final ejecucionesRestantes = ejecucionesRaw.where((raw) {
      try {
        final ej = EjecucionSalida.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
        return ej.salidaId != salidaId;
      } catch (_) {
        return true;
      }
    }).toList();
    await prefs.setStringList(_ejecucionesKey, ejecucionesRestantes);

    return true;
  }

  static EjecucionSalida _crearEjecucionVacia(
    String salidaId,
    SalidaCampo salida,
  ) {
    return EjecucionSalida(
      salidaId: salidaId,
      asignaciones: salida.asignacionesPlantillas
          .map(
            (a) => AsignacionEjecucionSalida(asignacionId: a.id),
          )
          .toList(),
      checklistItems: (salida.checklist?.items ?? [])
          .map((i) => ChecklistItemEjecucionSalida(itemId: i.id))
          .toList(),
      actualizadoEn: DateTime.now(),
    );
  }

  static Future<void> _guardarEjecucion(EjecucionSalida ejecucion) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_ejecucionesKey) ?? [];
    final lista = raw
        .map((s) => EjecucionSalida.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .where((e) => e.salidaId != ejecucion.salidaId)
        .toList();
    lista.add(ejecucion);
    await prefs.setStringList(
      _ejecucionesKey,
      lista.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<EjecucionSalida> obtenerEjecucion(String salidaId) async {
    await _asegurarMigracionLegacy();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_ejecucionesKey) ?? [];

    for (final s in raw) {
      final ejecucion =
          EjecucionSalida.fromJson(jsonDecode(s) as Map<String, dynamic>);
      if (ejecucion.salidaId == salidaId) return ejecucion;
    }

    final salida = await obtener(salidaId);
    if (salida == null) {
      return EjecucionSalida(
        salidaId: salidaId,
        actualizadoEn: DateTime.now(),
      );
    }

    final nueva = _crearEjecucionVacia(salidaId, salida);
    await _guardarEjecucion(nueva);
    return nueva;
  }

  static int calcularProgreso(EjecucionSalida ejecucion) {
    var total = 0;
    var completados = 0;

    for (final a in ejecucion.asignaciones) {
      total++;
      if (a.estado == EstadoAsignacionEjecucion.completada) completados++;
    }
    for (final c in ejecucion.checklistItems) {
      total++;
      if (c.completado || ejecucion.checklistCompletado) completados++;
    }

    final chequeo = ejecucion.chequeoVehiculo;
    if (chequeo != null && chequeo.aplicaTransporte) {
      total++;
      if (chequeo.completado) completados++;
    }

    if (total == 0) return 0;
    return ((completados / total) * 100).round();
  }

  static Future<int> progresoSalida(String salidaId) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    return calcularProgreso(ejecucion);
  }

  static Future<SalidaCampo> publicar(SalidaCampo salida) async {
    final ahora = DateTime.now();
    final publicada = salida.copyWith(
      estado: EstadoSalida.programada,
      publicadoEn: salida.publicadoEn ?? ahora,
      actualizadoEn: ahora,
    );

    await guardar(publicada);

    final ejecucionExistente = await obtenerEjecucion(publicada.id);
    if (ejecucionExistente.asignaciones.isEmpty &&
        ejecucionExistente.checklistItems.isEmpty) {
      await _guardarEjecucion(_crearEjecucionVacia(publicada.id, publicada));
    }

    if (publicada.salidaOrigenId != null) {
      await _marcarOrigenAlClonar(publicada.salidaOrigenId!);
    }

    return publicada;
  }

  static Future<void> _marcarOrigenAlClonar(String origenId) async {
    final origen = await obtener(origenId);
    if (origen == null) return;

    final progreso = await progresoSalida(origenId);
    if (progreso >= 100) return;

    await guardar(
      origen.copyWith(
        estado: origen.estado == EstadoSalida.completada
            ? EstadoSalida.completada
            : EstadoSalida.incompleta,
      ),
    );
  }

  static bool puedeClonar(SalidaCampo salida, int progreso) {
    if (salida.estado == EstadoSalida.cancelada ||
        salida.estado == EstadoSalida.borrador) {
      return false;
    }
    return progreso < 100 ||
        salida.estado == EstadoSalida.incompleta ||
        salida.estado == EstadoSalida.enCurso;
  }

  /// Prepara una salida clonada en memoria (el wizard la publica al finalizar).
  static Future<SalidaCampo> prepararClon({
    required String salidaOrigenId,
    required ModoClonacionSalida modo,
  }) async {
    final origen = await obtener(salidaOrigenId);
    if (origen == null) {
      throw StateError('Salida origen no encontrada');
    }

    final ejecucion = await obtenerEjecucion(salidaOrigenId);
    final ahora = DateTime.now();
    final nuevoId = generarId();

    var asignaciones = List<AsignacionPlantillaPlan>.from(
      origen.asignacionesPlantillas,
    );
    ChecklistPlanAsignado? checklist = origen.checklist;

    if (modo == ModoClonacionSalida.soloPendientes) {
      final pendientes = ejecucion.asignaciones
          .where((a) => a.estado != EstadoAsignacionEjecucion.completada)
          .map((a) => a.asignacionId)
          .toSet();

      asignaciones =
          asignaciones.where((a) => pendientes.contains(a.id)).toList();

      if (checklist != null) {
        final itemsCompletos = ejecucion.checklistCompletado
            ? checklist.items.map((i) => i.id).toSet()
            : ejecucion.checklistItems
                .where((c) => c.completado)
                .map((c) => c.itemId)
                .toSet();
        checklist = ChecklistPlanAsignado(
          listaId: checklist.listaId,
          nombre: checklist.nombre,
          origen: checklist.origen,
          items: checklist.items
              .where((i) => !itemsCompletos.contains(i.id))
              .toList(),
        );
      }
    }

    asignaciones = asignaciones
        .map(
          (a) => AsignacionPlantillaPlan(
            id: _nuevaAsignacionId(),
            templateId: a.templateId,
            templateNombre: a.templateNombre,
            featureIds: List<String>.from(a.featureIds),
            featureNombres: List<String>.from(a.featureNombres),
            operadorNombre: a.operadorNombre,
            operadorRol: a.operadorRol,
            responsableUserId: a.responsableUserId,
            fechaSubArea: a.fechaSubArea,
          ),
        )
        .toList();

    final sufijo = modo == ModoClonacionSalida.soloPendientes
        ? '(continuación)'
        : '(replanificación)';

    return SalidaCampo(
      id: nuevoId,
      nombre: '${origen.nombre} $sufijo',
      estado: EstadoSalida.borrador,
      fechaInicio: origen.fechaInicio,
      fechaFin: origen.fechaFin,
      proyectoId: origen.proyectoId,
      proyectoNombre: origen.proyectoNombre,
      topologiaId: origen.topologiaId,
      ubicacionRuta: origen.ubicacionRuta,
      poligonoPadreGeoJson: origen.poligonoPadreGeoJson,
      subAreasPorDia: List<SubAreaPlanDia>.from(origen.subAreasPorDia),
      equipo: List<MiembroEquipoPlan>.from(origen.equipo),
      checklistNombre: checklist?.nombre ?? origen.checklistNombre,
      checklist: checklist,
      asignacionesPlantillas: asignaciones,
      salidaOrigenId: origen.id,
      motivoClonacion: modo == ModoClonacionSalida.soloPendientes
          ? MotivoClonacionSalida.incompleta
          : MotivoClonacionSalida.reasignacionOperador,
      creadoEn: ahora,
      actualizadoEn: ahora,
    );
  }

  static Future<void> actualizarEstadoAsignacion({
    required String salidaId,
    required String asignacionId,
    required EstadoAsignacionEjecucion estado,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final asignaciones = ejecucion.asignaciones.map((a) {
      if (a.asignacionId == asignacionId) {
        return a.copyWith(estado: estado);
      }
      return a;
    }).toList();

    if (!asignaciones.any((a) => a.asignacionId == asignacionId)) {
      asignaciones.add(
        AsignacionEjecucionSalida(
          asignacionId: asignacionId,
          estado: estado,
        ),
      );
    }

    await _guardarEjecucion(
      ejecucion.copyWith(
        asignaciones: asignaciones,
        actualizadoEn: DateTime.now(),
      ),
    );

    await _sincronizarEstadoSalida(salidaId);
  }

  static Future<void> actualizarChecklistItem({
    required String salidaId,
    required String itemId,
    required bool completado,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final items = ejecucion.checklistItems.map((c) {
      if (c.itemId == itemId) {
        return c.copyWith(completado: completado);
      }
      return c;
    }).toList();

    if (!items.any((c) => c.itemId == itemId)) {
      items.add(ChecklistItemEjecucionSalida(itemId: itemId, completado: completado));
    }

    await _guardarEjecucion(
      ejecucion.copyWith(
        checklistItems: items,
        actualizadoEn: DateTime.now(),
      ),
    );

    await _sincronizarEstadoSalida(salidaId);
  }

  /// Guarda el estado del checklist de salida (ítems, evidencias y cierre).
  static Future<void> guardarChecklistEjecucion({
    required String salidaId,
    required List<ChecklistItemEjecucionSalida> items,
    required List<EvidenciaChecklistSalida> evidencias,
    required String observaciones,
    required bool completado,
    String? completadoPorNombre,
    String? completadoPorUserId,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final ahora = DateTime.now();

    await _guardarEjecucion(
      ejecucion.copyWith(
        checklistItems: items,
        checklistEvidencias: evidencias,
        checklistObservaciones: observaciones,
        checklistCompletado: completado,
        checklistCompletadoPorNombre:
            completado ? completadoPorNombre : null,
        checklistCompletadoPorUserId:
            completado ? completadoPorUserId : null,
        checklistCompletadoEn: completado ? ahora : null,
        actualizadoEn: ahora,
      ),
    );

    await _sincronizarEstadoSalida(salidaId);
  }

  /// Chequeo de transporte de la salida (o null si aún no se ha iniciado).
  static Future<ChequeoVehiculoSalida?> obtenerChequeoVehiculo(
    String salidaId,
  ) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    return ejecucion.chequeoVehiculo;
  }

  /// Guarda (crea o actualiza) el chequeo de transporte dentro de la ejecución.
  static Future<void> guardarChequeoVehiculo({
    required String salidaId,
    required ChequeoVehiculoSalida chequeo,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    await _guardarEjecucion(
      ejecucion.copyWith(
        chequeoVehiculo: chequeo,
        actualizadoEn: DateTime.now(),
      ),
    );
    await _sincronizarEstadoSalida(salidaId);
  }

  static Future<void> _sincronizarEstadoSalida(String salidaId) async {
    final salida = await obtener(salidaId);
    if (salida == null) return;

    if (salida.estado == EstadoSalida.borrador ||
        salida.estado == EstadoSalida.cancelada ||
        salida.estado == EstadoSalida.caducada) {
      return;
    }

    final progreso = await progresoSalida(salidaId);
    EstadoSalida nuevoEstado;

    if (progreso >= 100) {
      nuevoEstado = EstadoSalida.completada;
    } else if (progreso > 0) {
      nuevoEstado = EstadoSalida.enCurso;
    } else {
      nuevoEstado = EstadoSalida.programada;
    }

    if (nuevoEstado != salida.estado) {
      await guardar(salida.copyWith(estado: nuevoEstado));
    }
  }

  static bool puedeAsignarPlantillas(SalidaCampo salida) {
    return salida.estado == EstadoSalida.programada ||
        salida.estado == EstadoSalida.enCurso ||
        salida.estado == EstadoSalida.incompleta;
  }

  static bool asignacionEsParaUsuario(
    AsignacionPlantillaPlan asignacion,
    UsuarioCampo usuario,
  ) {
    final userId = asignacion.responsableUserId;
    if (userId != null && userId.isNotEmpty && usuario.id.isNotEmpty) {
      return userId == usuario.id;
    }
    return asignacion.operadorNombre.toLowerCase() == usuario.nombre.toLowerCase();
  }

  static EstadoTareaSalida _estadoTareaDesdeEjecucion(
    EstadoAsignacionEjecucion estado,
  ) {
    switch (estado) {
      case EstadoAsignacionEjecucion.completada:
        return EstadoTareaSalida.completada;
      case EstadoAsignacionEjecucion.enCurso:
        return EstadoTareaSalida.enCurso;
      case EstadoAsignacionEjecucion.cancelada:
      case EstadoAsignacionEjecucion.pendiente:
        return EstadoTareaSalida.pendiente;
    }
  }

  /// Tareas de plantilla asignadas al usuario en salidas activas.
  static Future<List<TareaSalidaVista>> listarTareasParaUsuario(
    UsuarioCampo usuario,
  ) async {
    final salidas = await listar();
    final tareas = <TareaSalidaVista>[];

    for (final salida in salidas) {
      if (salida.estado == EstadoSalida.borrador ||
          salida.estado == EstadoSalida.cancelada) {
        continue;
      }

      final ejecucion = await obtenerEjecucion(salida.id);

      for (final asignacion in salida.asignacionesPlantillas) {
        if (!asignacionEsParaUsuario(asignacion, usuario)) continue;

        final estadoEj = ejecucion.asignaciones
            .where((a) => a.asignacionId == asignacion.id)
            .map((a) => a.estado)
            .firstOrNull;

        tareas.add(
          TareaSalidaVista(
            asignacionId: asignacion.id,
            salidaId: salida.id,
            salidaNombre: salida.nombre,
            templateNombre: asignacion.templateNombre,
            featureNombres: asignacion.featureNombres,
            ubicacionRuta: salida.ubicacionRuta,
            estado: _estadoTareaDesdeEjecucion(
              estadoEj ?? EstadoAsignacionEjecucion.pendiente,
            ),
          ),
        );
      }
    }

    tareas.sort((a, b) => a.salidaNombre.compareTo(b.salidaNombre));
    return tareas;
  }

  /// Agrega una asignación de plantilla a una salida publicada y sincroniza ejecución.
  static Future<SalidaCampo> agregarAsignacionPlantilla({
    required String salidaId,
    required AsignacionPlantillaPlan asignacion,
  }) async {
    final salida = await obtener(salidaId);
    if (salida == null) {
      throw StateError('Salida no encontrada');
    }
    if (!puedeAsignarPlantillas(salida)) {
      throw StateError(
        'No se pueden asignar plantillas en el estado ${salida.estado.etiqueta}',
      );
    }

    final asignaciones = List<AsignacionPlantillaPlan>.from(
      salida.asignacionesPlantillas,
    )..add(asignacion);

    final actualizada = await guardar(
      salida.copyWith(asignacionesPlantillas: asignaciones),
    );

    final ejecucion = await obtenerEjecucion(salidaId);
    final ejAsignaciones = List<AsignacionEjecucionSalida>.from(
      ejecucion.asignaciones,
    );

    if (!ejAsignaciones.any((a) => a.asignacionId == asignacion.id)) {
      ejAsignaciones.add(
        AsignacionEjecucionSalida(asignacionId: asignacion.id),
      );
      await _guardarEjecucion(
        ejecucion.copyWith(
          asignaciones: ejAsignaciones,
          actualizadoEn: DateTime.now(),
        ),
      );
    }

    await _sincronizarEstadoSalida(salidaId);
    return actualizada;
  }

  /// Guarda audio, observaciones y coordenadas GPS de una asignación.
  static Future<void> guardarRegistroAsignacion({
    required String salidaId,
    required String asignacionId,
    CoordenadaActual? coordenada,
    String? observaciones,
    String? rutaAudio,
    bool marcarCompletada = true,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final nuevoEstado = marcarCompletada
        ? EstadoAsignacionEjecucion.completada
        : EstadoAsignacionEjecucion.enCurso;

    final asignaciones = ejecucion.asignaciones.map((a) {
      if (a.asignacionId != asignacionId) return a;
      return a.copyWith(
        estado: nuevoEstado,
        latitud: coordenada?.latitud,
        longitud: coordenada?.longitud,
        precisionMetros: coordenada?.precisionMetros,
        coordenadasCapturadasEn: coordenada?.capturadaEn,
        observaciones: observaciones,
        rutaAudio: rutaAudio,
      );
    }).toList();

    if (!asignaciones.any((a) => a.asignacionId == asignacionId)) {
      asignaciones.add(
        AsignacionEjecucionSalida(
          asignacionId: asignacionId,
          estado: nuevoEstado,
          latitud: coordenada?.latitud,
          longitud: coordenada?.longitud,
          precisionMetros: coordenada?.precisionMetros,
          coordenadasCapturadasEn: coordenada?.capturadaEn,
          observaciones: observaciones,
          rutaAudio: rutaAudio,
        ),
      );
    }

    await _guardarEjecucion(
      ejecucion.copyWith(
        asignaciones: asignaciones,
        actualizadoEn: DateTime.now(),
      ),
    );

    await _sincronizarEstadoSalida(salidaId);
  }

  static Future<void> marcarAsignacionEnCurso({
    required String salidaId,
    required String asignacionId,
  }) async {
    await actualizarEstadoAsignacion(
      salidaId: salidaId,
      asignacionId: asignacionId,
      estado: EstadoAsignacionEjecucion.enCurso,
    );
  }

  // ── Ciclo de vida / retención ─────────────────────────────────────────────

  /// Marca la salida como sincronizada con la nube.
  /// Una vez marcada, sus datos NO deben modificarse localmente.
  static Future<void> marcarSincronizado(String salidaId) async {
    final salida = await obtener(salidaId);
    if (salida == null || salida.sincronizadoEn != null) return;
    await guardar(salida.copyWith(sincronizadoEn: DateTime.now()));
  }

  /// Purga registros del dispositivo siguiendo las reglas de retención:
  /// - Sincronizados y expirados → borrado inmediato (datos seguros en nube).
  /// - No sincronizados y en período de gracia → se marcan como [EstadoSalida.caducada].
  /// - No sincronizados y ya expirados (gracia agotada) → borrado forzoso.
  ///
  /// Devuelve un resumen de la operación.
  static Future<ResultadoPurga> purgarExpiradas() async {
    final salidas = await listar();
    final prefs = await SharedPreferences.getInstance();
    final ejecucionesRaw = prefs.getStringList(_ejecucionesKey) ?? [];

    final idsAEliminar = <String>{};
    int marcadasCaducadas = 0;
    int eliminadas = 0;
    int proximasAExpirar = 0;

    // Construimos la lista final en memoria para escribirla en una sola pasada.
    final salidasActualizadas = <SalidaCampo>[];

    for (final salida in salidas) {
      if (!salida.estaExpirada && salida.diasParaExpirar <= 5) {
        proximasAExpirar++;
        salidasActualizadas.add(salida);
        continue;
      }

      if (!salida.estaExpirada) {
        salidasActualizadas.add(salida);
        continue;
      }

      // La salida está expirada.
      if (salida.sincronizadoEn != null) {
        // Datos seguros en la nube → eliminar del dispositivo.
        idsAEliminar.add(salida.id);
        eliminadas++;
      } else if (salida.estado != EstadoSalida.caducada) {
        // Primera vez que expira sin sync → período de gracia.
        salidasActualizadas.add(
          salida.copyWith(estado: EstadoSalida.caducada),
        );
        marcadasCaducadas++;
      } else {
        // Ya estaba caducada (gracia agotada) → eliminar definitivamente.
        idsAEliminar.add(salida.id);
        eliminadas++;
      }
    }

    // Una sola escritura al final para evitar estados intermedios inconsistentes.
    final salidasFinales =
        salidasActualizadas.where((s) => !idsAEliminar.contains(s.id)).toList();
    await _guardarSalidas(salidasFinales);

    if (idsAEliminar.isNotEmpty) {
      final ejecucionesRestantes = ejecucionesRaw.where((raw) {
        try {
          final ej = EjecucionSalida.fromJson(
            jsonDecode(raw) as Map<String, dynamic>,
          );
          return !idsAEliminar.contains(ej.salidaId);
        } catch (_) {
          return false;
        }
      }).toList();
      await prefs.setStringList(_ejecucionesKey, ejecucionesRestantes);
    }

    return ResultadoPurga(
      eliminadas: eliminadas,
      marcadasCaducadas: marcadasCaducadas,
      proximasAExpirar: proximasAExpirar,
    );
  }

  /// Devuelve salidas ordenadas por urgencia de expiración para mostrar avisos al usuario.
  static Future<List<SalidaCampo>> listarConRiesgoExpiracion() async {
    final salidas = await listar();
    return salidas
        .where(
          (s) =>
              !s.estaSincronizada &&
              s.diasParaExpirar <= 5 &&
              !s.estaExpirada,
        )
        .toList()
      ..sort((a, b) => a.expiraEn.compareTo(b.expiraEn));
  }
}

/// Resultado de una operación de purga de datos del dispositivo.
class ResultadoPurga {
  final int eliminadas;
  final int marcadasCaducadas;
  final int proximasAExpirar;

  const ResultadoPurga({
    required this.eliminadas,
    required this.marcadasCaducadas,
    required this.proximasAExpirar,
  });

  bool get hayActividad =>
      eliminadas > 0 || marcadasCaducadas > 0 || proximasAExpirar > 0;

  @override
  String toString() =>
      'Purga: $eliminadas eliminadas, $marcadasCaducadas caducadas, '
      '$proximasAExpirar próximas a expirar';
}
