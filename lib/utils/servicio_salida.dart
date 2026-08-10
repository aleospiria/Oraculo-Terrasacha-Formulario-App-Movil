import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/checklist_salida_ejecucion.dart';
import '../models/chequeo_vehiculo.dart';
import '../models/coordenada_actual.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';
import 'roles_campo.dart';

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
            (a) => AsignacionEjecucionSalida(
              asignacionId: a.id,
              registrosFeatures: _registrosFeaturesVacios(a),
            ),
          )
          .toList(),
      // El checklist de cada persona se crea el primer día que el líder lo
      // abre para esa fecha (ver [guardarChecklistPersona]), no de antemano:
      // una salida de varios días no necesita N registros vacíos por persona
      // desde el momento de publicarse.
      actualizadoEn: DateTime.now(),
    );
  }

  static List<RegistroFeatureEjecucion> _registrosFeaturesVacios(
    AsignacionPlantillaPlan asignacion,
  ) {
    return List<int>.generate(asignacion.featureIds.length, (i) => i)
        .map(
          (i) => RegistroFeatureEjecucion(
            featureId: asignacion.featureIds[i],
            featureNombre: i < asignacion.featureNombres.length
                ? asignacion.featureNombres[i]
                : asignacion.featureIds[i],
          ),
        )
        .toList();
  }

  /// Asegura que [actual] tenga un [RegistroFeatureEjecucion] por cada
  /// feature vigente de [plantilla], conservando los que ya existan y
  /// creando los que falten como `pendiente` (asignaciones guardadas antes
  /// de introducir el registro granular por feature, o features agregadas
  /// después de publicar la salida). Devuelve la misma instancia si no hay
  /// nada que reconciliar.
  static AsignacionEjecucionSalida _reconciliarFeatures(
    AsignacionEjecucionSalida actual,
    AsignacionPlantillaPlan plantilla,
  ) {
    final existentes = {
      for (final r in actual.registrosFeatures) r.featureId: r,
    };
    var cambios = plantilla.featureIds.length != actual.registrosFeatures.length;
    final reconciliados = <RegistroFeatureEjecucion>[];

    for (var i = 0; i < plantilla.featureIds.length; i++) {
      final featureId = plantilla.featureIds[i];
      final featureNombre = i < plantilla.featureNombres.length
          ? plantilla.featureNombres[i]
          : featureId;
      final previo = existentes[featureId];
      if (previo == null) cambios = true;
      reconciliados.add(
        previo ??
            RegistroFeatureEjecucion(
              featureId: featureId,
              featureNombre: featureNombre,
            ),
      );
    }

    if (!cambios) return actual;
    return actual.copyWith(registrosFeatures: reconciliados);
  }

  /// Reconcilia todas las asignaciones de [ejecucion] contra las plantillas
  /// vigentes de [salida]: crea asignaciones y registros de feature que
  /// falten, sin tocar los que ya existen. Devuelve la misma instancia si no
  /// hubo cambios que persistir.
  static EjecucionSalida _reconciliarAsignaciones(
    EjecucionSalida ejecucion,
    SalidaCampo salida,
  ) {
    final existentes = {
      for (final a in ejecucion.asignaciones) a.asignacionId: a,
    };
    var cambios = false;
    final resultado = <AsignacionEjecucionSalida>[];

    for (final plantilla in salida.asignacionesPlantillas) {
      final previa = existentes[plantilla.id];
      final base =
          previa ?? AsignacionEjecucionSalida(asignacionId: plantilla.id);
      final reconciliada = _reconciliarFeatures(base, plantilla);
      if (previa == null || !identical(reconciliada, previa)) cambios = true;
      resultado.add(reconciliada);
    }

    final idsVigentes = salida.asignacionesPlantillas.map((a) => a.id).toSet();
    for (final a in ejecucion.asignaciones) {
      if (!idsVigentes.contains(a.asignacionId)) resultado.add(a);
    }

    if (!cambios && resultado.length == ejecucion.asignaciones.length) {
      return ejecucion;
    }
    return ejecucion.copyWith(asignaciones: resultado);
  }

  /// Clave estable para anclar el checklist individual de un miembro del
  /// equipo: su `userId` de Cognito si existe, o su nombre normalizado.
  static String personaIdDeMiembro(MiembroEquipoPlan miembro) {
    final id = miembro.userId;
    if (id != null && id.isNotEmpty) return id;
    return 'nombre:${miembro.nombre.toLowerCase().trim()}';
  }

  static bool _miembroEsUsuario(MiembroEquipoPlan miembro, UsuarioCampo usuario) {
    final id = miembro.userId;
    if (id != null && id.isNotEmpty && usuario.id.isNotEmpty) {
      return id == usuario.id;
    }
    return miembro.nombre.toLowerCase().trim() ==
        usuario.nombre.toLowerCase().trim();
  }

  /// Normaliza una fecha a solo año/mes/día, para comparar días sin
  /// importar la hora.
  static DateTime normalizarFecha(DateTime fecha) =>
      DateTime(fecha.year, fecha.month, fecha.day);

  /// Miembros del equipo que deben llenar un checklist diario: operadores y
  /// el líder de cuadrilla (el líder de proyecto no tiene checklist propio).
  static List<MiembroEquipoPlan> miembrosConChecklist(SalidaCampo salida) {
    return salida.equipo
        .where(
          (m) => RolesCampo.esOperador(m.rol) || RolesCampo.esLiderCuadrilla(m.rol),
        )
        .toList();
  }

  /// Un checklist por día calendario entre el inicio y el fin de la salida
  /// (inclusive). Si la salida no tiene fechas definidas, se asume un único
  /// día (hoy).
  static List<DateTime> diasSalida(SalidaCampo salida) {
    final inicio = salida.fechaInicio;
    if (inicio == null) return [normalizarFecha(DateTime.now())];

    final ini = normalizarFecha(inicio);
    final fin = normalizarFecha(salida.fechaFin ?? inicio);
    if (fin.isBefore(ini)) return [ini];

    final dias = <DateTime>[];
    var cursor = ini;
    while (!cursor.isAfter(fin)) {
      dias.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    return dias;
  }

  static DiaSuspendidoSalida? diaSuspendidoDe(
    SalidaCampo salida,
    DateTime fecha,
  ) {
    final norm = normalizarFecha(fecha);
    for (final d in salida.diasSuspendidos) {
      if (normalizarFecha(d.fecha) == norm) return d;
    }
    return null;
  }

  static bool esDiaSuspendido(SalidaCampo salida, DateTime fecha) =>
      diaSuspendidoDe(salida, fecha) != null;

  /// Siguiente día hábil sugerido tras [origen]: día siguiente, o el primero
  /// posterior que no esté ya suspendido.
  static DateTime sugerirDiaReprogramacion(
    SalidaCampo salida,
    DateTime origen,
  ) {
    var candidato = normalizarFecha(origen).add(const Duration(days: 1));
    for (var i = 0; i < 60; i++) {
      if (!esDiaSuspendido(salida, candidato)) return candidato;
      candidato = candidato.add(const Duration(days: 1));
    }
    return normalizarFecha(origen).add(const Duration(days: 1));
  }

  static bool _asignacionCompletadaEnEjecucion(
    AsignacionPlantillaPlan asignacion,
    EjecucionSalida ejecucion,
  ) {
    if (asignacion.featureIds.isEmpty) return false;
    final ej = ejecucion.asignaciones
        .where((a) => a.asignacionId == asignacion.id)
        .firstOrNull;
    if (ej == null) return false;
    return asignacion.featureIds.every((id) {
      final r = ej.registroDeFeature(id);
      return r?.estado == EstadoAsignacionEjecucion.completada;
    });
  }

  /// Cuenta asignaciones del [dia] que aún no están 100% completadas.
  static int contarAsignacionesPendientesDelDia(
    SalidaCampo salida,
    EjecucionSalida ejecucion,
    DateTime dia,
  ) {
    final norm = normalizarFecha(dia);
    return salida.asignacionesPlantillas.where((a) {
      if (a.fechaSubArea == null) return false;
      if (normalizarFecha(a.fechaSubArea!) != norm) return false;
      return !_asignacionCompletadaEnEjecucion(a, ejecucion);
    }).length;
  }

  /// Marca un día como no operable (clima/acceso) y mueve asignaciones
  /// pendientes (y subáreas de ese día) a [diaDestino]. Extiende [fechaFin]
  /// si el destino queda fuera del rango actual.
  static Future<SalidaCampo> suspenderYReprogramarDia({
    required String salidaId,
    required DateTime diaOrigen,
    required DateTime diaDestino,
    required String motivo,
    String? autorNombre,
  }) async {
    final salida = await obtener(salidaId);
    if (salida == null) throw StateError('Salida no encontrada');

    if (salida.estado == EstadoSalida.borrador ||
        salida.estado == EstadoSalida.cancelada ||
        salida.estado == EstadoSalida.completada ||
        salida.estado == EstadoSalida.caducada) {
      throw StateError(
        'No se puede reprogramar en el estado ${salida.estado.etiqueta}',
      );
    }

    final origen = normalizarFecha(diaOrigen);
    final destino = normalizarFecha(diaDestino);
    if (destino == origen) {
      throw ArgumentError('El día destino debe ser distinto al día suspendido');
    }

    final ejecucion = await obtenerEjecucion(salidaId);

    final asignaciones = salida.asignacionesPlantillas.map((a) {
      if (a.fechaSubArea == null) return a;
      if (normalizarFecha(a.fechaSubArea!) != origen) return a;
      if (_asignacionCompletadaEnEjecucion(a, ejecucion)) return a;
      return a.copyWith(fechaSubArea: destino);
    }).toList();

    final subAreas = salida.subAreasPorDia.map((s) {
      if (normalizarFecha(s.fecha) != origen) return s;
      return SubAreaPlanDia(fecha: destino, subAreaGeoJson: s.subAreaGeoJson);
    }).toList();

    var fechaFin = salida.fechaFin;
    final finActual =
        fechaFin != null ? normalizarFecha(fechaFin) : origen;
    if (destino.isAfter(finActual)) {
      fechaFin = destino;
    }

    final suspendidos = List<DiaSuspendidoSalida>.from(salida.diasSuspendidos)
      ..removeWhere((d) => normalizarFecha(d.fecha) == origen)
      ..add(
        DiaSuspendidoSalida(
          fecha: origen,
          motivo: motivo,
          reprogramadoA: destino,
          suspendidoEn: DateTime.now(),
          suspendidoPorNombre: autorNombre,
        ),
      );

    return guardar(
      salida.copyWith(
        asignacionesPlantillas: asignaciones,
        subAreasPorDia: subAreas,
        fechaFin: fechaFin,
        diasSuspendidos: suspendidos,
        actualizadoEn: DateTime.now(),
      ),
    );
  }

  static AsignacionPlantillaPlan _conDiaPorDefecto(
    AsignacionPlantillaPlan asignacion,
    List<DateTime> dias,
  ) {
    if (asignacion.fechaSubArea != null || dias.isEmpty) return asignacion;
    return asignacion.copyWith(fechaSubArea: dias.first);
  }

  /// Para salidas de varios días, asigna automáticamente el primer día a
  /// cualquier asignación legacy que no tenga día específico.
  static Future<SalidaCampo> normalizarAsignacionesSinDiaEnSalida(
    String salidaId,
  ) async {
    final salida = await obtener(salidaId);
    if (salida == null) {
      throw StateError('Salida no encontrada');
    }

    final dias = diasSalida(salida);
    if (dias.isEmpty) return salida;

    var cambios = false;
    final normalizadas = salida.asignacionesPlantillas.map((a) {
      final conDia = _conDiaPorDefecto(a, dias);
      if (conDia.fechaSubArea != a.fechaSubArea) cambios = true;
      return conDia;
    }).toList();

    if (!cambios) return salida;

    return guardar(salida.copyWith(asignacionesPlantillas: normalizadas));
  }

  /// Indica si una feature de una asignación ya está completada en la ejecución.
  static bool featureCompletadaEnEjecucion({
    required EjecucionSalida? ejecucion,
    required String asignacionId,
    required String featureId,
  }) {
    if (ejecucion == null) return false;
    final asig = ejecucion.asignaciones
        .where((a) => a.asignacionId == asignacionId)
        .firstOrNull;
    if (asig == null) return false;

    final registro = asig.registroDeFeature(featureId);
    if (registro != null) {
      return registro.estado == EstadoAsignacionEjecucion.completada;
    }

    // Asignación legacy sin registros por feature: el estado global aplica.
    if (asig.registrosFeatures.isEmpty &&
        asig.estado == EstadoAsignacionEjecucion.completada) {
      return true;
    }
    return false;
  }

  /// Mapa de features ya presentes en otras asignaciones.
  /// [soloCompletadas]: si es true, solo incluye mediciones terminadas
  /// (no reasignables). Si es false, incluye todas (para UI de reasignación).
  static Map<String, FeatureAsignadaPrevio> featuresYaAsignadas({
    required List<AsignacionPlantillaPlan> asignaciones,
    EjecucionSalida? ejecucion,
    String? excluirAsignacionId,
    bool soloCompletadas = false,
  }) {
    final resultado = <String, FeatureAsignadaPrevio>{};

    for (final asignacion in asignaciones) {
      if (excluirAsignacionId != null && asignacion.id == excluirAsignacionId) {
        continue;
      }

      final fechaAsignacion = asignacion.fechaSubArea;
      final esSinDia = fechaAsignacion == null;
      final fechaNorm =
          esSinDia ? null : normalizarFecha(fechaAsignacion);

      for (var i = 0; i < asignacion.featureIds.length; i++) {
        final featureId = asignacion.featureIds[i];
        final featureNombre = i < asignacion.featureNombres.length
            ? asignacion.featureNombres[i]
            : featureId;
        final completada = featureCompletadaEnEjecucion(
          ejecucion: ejecucion,
          asignacionId: asignacion.id,
          featureId: featureId,
        );

        if (soloCompletadas && !completada) continue;

        final previo = FeatureAsignadaPrevio(
          featureId: featureId,
          featureNombre: featureNombre,
          asignacionId: asignacion.id,
          operadorNombre: asignacion.operadorNombre,
          fecha: fechaNorm,
          sinDiaEspecifico: esSinDia,
          completada: completada,
        );

        final existente = resultado[featureId];
        // Preferir el registro completado si hay varias menciones.
        if (existente == null ||
            (!existente.completada && previo.completada)) {
          resultado[featureId] = previo;
        }
      }
    }

    return resultado;
  }

  /// Features que no se pueden volver a asignar (ya completadas).
  static Map<String, FeatureAsignadaPrevio> featuresNoReasignables({
    required List<AsignacionPlantillaPlan> asignaciones,
    EjecucionSalida? ejecucion,
    String? excluirAsignacionId,
  }) {
    return featuresYaAsignadas(
      asignaciones: asignaciones,
      ejecucion: ejecucion,
      excluirAsignacionId: excluirAsignacionId,
      soloCompletadas: true,
    );
  }

  /// @deprecated Usar [featuresNoReasignables]. Se mantiene por compatibilidad.
  static Map<String, FeatureAsignadaPrevio> featuresEnDiasAnteriores({
    required List<AsignacionPlantillaPlan> asignaciones,
    required DateTime fechaReferencia,
    String? excluirAsignacionId,
    EjecucionSalida? ejecucion,
  }) {
    return featuresNoReasignables(
      asignaciones: asignaciones,
      ejecucion: ejecucion,
      excluirAsignacionId: excluirAsignacionId,
    );
  }

  /// Valida que no se reasignen mediciones ya completadas.
  static void validarAsignacionPlantillaPorDia({
    required List<DateTime> dias,
    required List<AsignacionPlantillaPlan> asignaciones,
    required AsignacionPlantillaPlan asignacion,
    String? excluirAsignacionId,
    EjecucionSalida? ejecucion,
  }) {
    if (dias.length > 1 && asignacion.fechaSubArea == null) {
      throw StateError(
        'Selecciona el día de trabajo para esta asignación.',
      );
    }

    final bloqueadas = featuresNoReasignables(
      asignaciones: asignaciones,
      ejecucion: ejecucion,
      excluirAsignacionId: excluirAsignacionId,
    );

    final conflictos = asignacion.featureIds
        .where((id) => bloqueadas.containsKey(id))
        .map((id) => bloqueadas[id]!.featureNombre)
        .toList();

    if (conflictos.isEmpty) return;

    throw StateError(
      'Estas mediciones ya están completadas y no se pueden reasignar: '
      '${conflictos.join(', ')}.',
    );
  }

  /// Quita de otras asignaciones las features que se están reasignando
  /// (solo si no están completadas). Elimina asignaciones que queden vacías.
  static List<AsignacionPlantillaPlan> reasignarFeaturesEnMemoria({
    required List<AsignacionPlantillaPlan> asignaciones,
    required AsignacionPlantillaPlan destino,
    EjecucionSalida? ejecucion,
  }) {
    final featureIds = destino.featureIds.toSet();
    final resultado = <AsignacionPlantillaPlan>[];

    for (final asignacion in asignaciones) {
      if (asignacion.id == destino.id) {
        resultado.add(destino);
        continue;
      }

      final ids = <String>[];
      final nombres = <String>[];
      for (var i = 0; i < asignacion.featureIds.length; i++) {
        final featureId = asignacion.featureIds[i];
        final nombre = i < asignacion.featureNombres.length
            ? asignacion.featureNombres[i]
            : featureId;

        if (featureIds.contains(featureId) &&
            !featureCompletadaEnEjecucion(
              ejecucion: ejecucion,
              asignacionId: asignacion.id,
              featureId: featureId,
            )) {
          continue;
        }
        ids.add(featureId);
        nombres.add(nombre);
      }

      if (ids.isEmpty) continue;
      if (ids.length == asignacion.featureIds.length) {
        resultado.add(asignacion);
      } else {
        resultado.add(
          asignacion.copyWith(featureIds: ids, featureNombres: nombres),
        );
      }
    }

    if (!resultado.any((a) => a.id == destino.id)) {
      resultado.add(destino);
    }

    return resultado;
  }

  static EjecucionSalida _moverRegistrosTrasReasignacion({
    required EjecucionSalida ejecucion,
    required List<AsignacionPlantillaPlan> asignacionesAntes,
    required AsignacionPlantillaPlan destino,
    required List<AsignacionPlantillaPlan> asignacionesDespues,
  }) {
    final featureIds = destino.featureIds.toSet();
    final idsVivos = asignacionesDespues.map((a) => a.id).toSet();
    final registrosMovidos = <RegistroFeatureEjecucion>[];

    var asignacionesEj = ejecucion.asignaciones.map((a) {
      if (a.asignacionId == destino.id) return a;
      if (!idsVivos.contains(a.asignacionId)) {
        // Guardar registros de features reasignadas antes de eliminar.
        for (final r in a.registrosFeatures) {
          if (featureIds.contains(r.featureId) &&
              r.estado != EstadoAsignacionEjecucion.completada) {
            registrosMovidos.add(r);
          }
        }
        return null;
      }

      final origenPlan = asignacionesAntes
          .where((p) => p.id == a.asignacionId)
          .firstOrNull;
      if (origenPlan == null) return a;

      final quedaron = <RegistroFeatureEjecucion>[];
      for (final r in a.registrosFeatures) {
        if (featureIds.contains(r.featureId) &&
            r.estado != EstadoAsignacionEjecucion.completada) {
          registrosMovidos.add(r);
        } else {
          quedaron.add(r);
        }
      }
      return a.copyWith(registrosFeatures: quedaron);
    }).whereType<AsignacionEjecucionSalida>().toList();

    final idxDestino = asignacionesEj.indexWhere(
      (a) => a.asignacionId == destino.id,
    );
    if (idxDestino < 0) {
      asignacionesEj = [
        ...asignacionesEj,
        AsignacionEjecucionSalida(
          asignacionId: destino.id,
          registrosFeatures: [
            ...registrosMovidos,
            ..._registrosFeaturesVacios(destino).where(
              (r) => !registrosMovidos.any((m) => m.featureId == r.featureId),
            ),
          ],
        ),
      ];
    } else {
      final actual = asignacionesEj[idxDestino];
      final porId = {
        for (final r in actual.registrosFeatures) r.featureId: r,
      };
      for (final r in registrosMovidos) {
        porId.putIfAbsent(r.featureId, () => r);
      }
      // Asegurar features nuevas del destino.
      for (final r in _registrosFeaturesVacios(destino)) {
        porId.putIfAbsent(r.featureId, () => r);
      }
      // Quitar features que ya no están en el destino.
      porId.removeWhere((id, _) => !featureIds.contains(id));
      asignacionesEj[idxDestino] = actual.copyWith(
        registrosFeatures: porId.values.toList(),
      );
    }

    return ejecucion.copyWith(
      asignaciones: asignacionesEj,
      actualizadoEn: DateTime.now(),
    );
  }

  /// Días calendario entre [fechaInicio] y [fechaFin] (inclusive).
  static List<DateTime> diasDesdeRango({
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) {
    if (fechaInicio == null) return [normalizarFecha(DateTime.now())];

    final ini = normalizarFecha(fechaInicio);
    final fin = normalizarFecha(fechaFin ?? fechaInicio);
    if (fin.isBefore(ini)) return [ini];

    final dias = <DateTime>[];
    var cursor = ini;
    while (!cursor.isAfter(fin)) {
      dias.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    return dias;
  }

  static ChecklistPersonaEjecucion? _buscarChecklistPersona(
    List<ChecklistPersonaEjecucion> lista, {
    required String personaId,
    required String nombre,
    required DateTime fecha,
  }) {
    final fechaNorm = normalizarFecha(fecha);
    final porId = lista.where(
      (c) => c.personaId == personaId && c.fecha == fechaNorm,
    );
    if (porId.isNotEmpty) return porId.first;

    final nombreNorm = nombre.toLowerCase().trim();
    final porNombre = lista.where(
      (c) => c.nombre.toLowerCase().trim() == nombreNorm && c.fecha == fechaNorm,
    );
    if (porNombre.isNotEmpty) return porNombre.first;
    return null;
  }

  /// Busca el checklist de un miembro del equipo para un día concreto,
  /// dentro de una ejecución ya cargada (líder viendo el consolidado de la
  /// salida).
  static ChecklistPersonaEjecucion? checklistDeMiembroEnFecha(
    EjecucionSalida ejecucion,
    MiembroEquipoPlan miembro,
    DateTime fecha,
  ) {
    return _buscarChecklistPersona(
      ejecucion.checklistsPersonales,
      personaId: personaIdDeMiembro(miembro),
      nombre: miembro.nombre,
      fecha: fecha,
    );
  }

  /// Checklists de días anteriores de una misma persona, del más reciente al
  /// más antiguo, para ofrecer "clonar de un día anterior" al líder.
  static Future<List<ChecklistPersonaEjecucion>> historialChecklistPersona({
    required String salidaId,
    required String personaId,
    DateTime? excluirFecha,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final excluir = excluirFecha != null ? normalizarFecha(excluirFecha) : null;

    final historial = ejecucion.checklistsPersonales
        .where((c) => c.personaId == personaId && c.fecha != excluir)
        .toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
    return historial;
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

    EjecucionSalida? existente;
    for (final s in raw) {
      final ejecucion =
          EjecucionSalida.fromJson(jsonDecode(s) as Map<String, dynamic>);
      if (ejecucion.salidaId == salidaId) {
        existente = ejecucion;
        break;
      }
    }

    final salida = await obtener(salidaId);

    if (existente == null) {
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

    if (salida == null) return existente;

    // Crea registros de feature/asignación que falten (asignaciones
    // guardadas antes del registro granular por feature, o agregadas
    // después de publicar), sin tocar los que ya existen.
    final reconciliada = _reconciliarAsignaciones(existente, salida);
    if (!identical(reconciliada, existente)) {
      await _guardarEjecucion(reconciliada);
    }
    return reconciliada;
  }

  /// El progreso cuenta cada combinación (persona, día) como una unidad
  /// independiente: una salida de 3 días con 4 personas con checklist
  /// necesita 12 checklists completados para llegar al 100%, sin importar
  /// que solo exista registro guardado de los días ya trabajados.
  static int calcularProgreso(SalidaCampo salida, EjecucionSalida ejecucion) {
    var total = 0;
    var completados = 0;

    for (final a in ejecucion.asignaciones) {
      if (a.registrosFeatures.isEmpty) {
        // Asignación legacy sin registro granular por feature: cuenta como
        // una sola unidad.
        total++;
        if (a.estado == EstadoAsignacionEjecucion.completada) completados++;
        continue;
      }
      for (final registro in a.registrosFeatures) {
        total++;
        if (registro.estado == EstadoAsignacionEjecucion.completada) {
          completados++;
        }
      }
    }

    final miembros = miembrosConChecklist(salida);
    final hayCatalogoChecklist = salida.checklist?.items.isNotEmpty ?? false;
    if (miembros.isNotEmpty && hayCatalogoChecklist) {
      for (final dia in diasSalida(salida)) {
        for (final miembro in miembros) {
          total++;
          if (checklistDeMiembroEnFecha(ejecucion, miembro, dia)?.completado ==
              true) {
            completados++;
          }
        }
      }
    }

    final chequeo = ejecucion.chequeoVehiculo;
    if (salida.requiereChequeoVehiculo &&
        chequeo != null &&
        chequeo.aplicaTransporte) {
      total++;
      if (chequeo.completado) completados++;
    }

    if (total == 0) return 0;
    return ((completados / total) * 100).round();
  }

  static Future<int> progresoSalida(String salidaId) async {
    final salida = await obtener(salidaId);
    if (salida == null) return 0;
    final ejecucion = await obtenerEjecucion(salidaId);
    return calcularProgreso(salida, ejecucion);
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
    if (ejecucionExistente.asignaciones.isEmpty) {
      await _guardarEjecucion(_crearEjecucionVacia(publicada.id, publicada));
    }

    if (!publicada.requiereChequeoVehiculo) {
      await quitarChequeoVehiculo(publicada.id);
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
    // El checklist preoperacional se reinicia completo en la salida clonada:
    // al ser por persona, cada quien debe volver a realizarlo en la nueva
    // jornada, sin importar el modo de clonación.
    final checklist = origen.checklist;

    if (modo == ModoClonacionSalida.soloPendientes) {
      final pendientes = ejecucion.asignaciones
          .where((a) => a.estado != EstadoAsignacionEjecucion.completada)
          .map((a) => a.asignacionId)
          .toSet();

      asignaciones =
          asignaciones.where((a) => pendientes.contains(a.id)).toList();
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
      requiereChequeoVehiculo: origen.requiereChequeoVehiculo,
    );
  }

  /// Guarda el checklist individual de una persona del equipo para un día
  /// concreto (ítems, evidencias y cierre). Si aún no existe un registro
  /// para esa combinación (persona, día), lo crea. Solo el líder de
  /// cuadrilla debe invocar esto, tanto para su propio checklist como para
  /// el de cualquier operador.
  ///
  /// [observacion] es la nota del titular del checklist; se pasa `null` para
  /// conservar las observaciones existentes cuando quien guarda no es el
  /// dueño (p. ej. el líder editando ítems del checklist de un operador).
  ///
  /// [observaciones] reemplaza la lista completa (p. ej. al clonar un día).
  static Future<void> guardarChecklistPersona({
    required String salidaId,
    required String personaId,
    required String personaNombre,
    required String personaRol,
    required DateTime fecha,
    required List<ChecklistItemEjecucionSalida> items,
    required List<EvidenciaChecklistSalida> evidencias,
    required bool completado,
    String? completadoPorNombre,
    String? completadoPorUserId,
    String? observacion,
    List<ObservacionChecklistPersona>? observaciones,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final ahora = DateTime.now();
    final fechaNorm = normalizarFecha(fecha);

    final lista = List<ChecklistPersonaEjecucion>.from(
      ejecucion.checklistsPersonales,
    );
    final index = lista.indexWhere(
      (c) => c.personaId == personaId && c.fecha == fechaNorm,
    );
    final existente = index >= 0 ? lista[index] : null;

    var actualizado = ChecklistPersonaEjecucion(
      personaId: personaId,
      nombre: personaNombre,
      rol: personaRol,
      fecha: fechaNorm,
      items: items,
      evidencias: evidencias,
      completado: completado,
      completadoPorNombre: completado ? completadoPorNombre : null,
      completadoPorUserId: completado ? completadoPorUserId : null,
      completadoEn: completado ? ahora : null,
      observaciones: observaciones ?? existente?.observaciones ?? const [],
    );

    if (observacion != null) {
      actualizado = actualizado.conObservacionUpsert(
        ObservacionChecklistPersona(
          texto: observacion,
          autorNombre: personaNombre,
          autorUserId: personaId,
          autorRol: personaRol,
          tipo: 'dueno',
          actualizadoEn: ahora,
        ),
      );
    }

    if (index >= 0) {
      lista[index] = actualizado;
    } else {
      lista.add(actualizado);
    }

    await _guardarEjecucion(
      ejecucion.copyWith(checklistsPersonales: lista, actualizadoEn: ahora),
    );

    await _sincronizarEstadoSalida(salidaId);
  }

  /// Guarda la observación de un autor concreto (titular del checklist o jefe
  /// de cuadrilla) en un día concreto. No toca ítems, evidencias ni el cierre.
  static Future<void> guardarObservacionChecklistPersona({
    required String salidaId,
    required String personaId,
    required String personaNombre,
    required String personaRol,
    required DateTime fecha,
    required String observacion,
    required String autorNombre,
    required String autorUserId,
    required String autorRol,
    required String tipo,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final ahora = DateTime.now();
    final fechaNorm = normalizarFecha(fecha);

    final lista = List<ChecklistPersonaEjecucion>.from(
      ejecucion.checklistsPersonales,
    );
    final index = lista.indexWhere(
      (c) => c.personaId == personaId && c.fecha == fechaNorm,
    );

    final nueva = ObservacionChecklistPersona(
      texto: observacion,
      autorNombre: autorNombre,
      autorUserId: autorUserId,
      autorRol: autorRol,
      tipo: tipo,
      actualizadoEn: ahora,
    );

    if (index >= 0) {
      lista[index] = lista[index].conObservacionUpsert(nueva);
    } else {
      lista.add(
        ChecklistPersonaEjecucion(
          personaId: personaId,
          nombre: personaNombre,
          rol: personaRol,
          fecha: fechaNorm,
          observaciones: observacion.trim().isEmpty ? const [] : [nueva],
        ),
      );
    }

    await _guardarEjecucion(
      ejecucion.copyWith(checklistsPersonales: lista, actualizadoEn: ahora),
    );
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

  /// Elimina el chequeo de transporte de la ejecución (p. ej. si el plan no lo requiere).
  static Future<void> quitarChequeoVehiculo(String salidaId) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    if (ejecucion.chequeoVehiculo == null) return;
    await _guardarEjecucion(
      ejecucion.copyWith(
        quitarChequeoVehiculo: true,
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
      if (userId == usuario.id) return true;
    }

    final nombreAsig = RolesCampo.normalizarNombre(
      asignacion.operadorNombre,
      rolCognito: asignacion.operadorRol,
    ).toLowerCase().trim();
    final nombreUser = RolesCampo.normalizarNombre(
      usuario.nombre,
      rolCognito: usuario.rolCognito,
    ).toLowerCase().trim();
    if (nombreAsig.isNotEmpty && nombreAsig == nombreUser) return true;

    // Fallback: comparación directa por si el nombre aún no se normalizó al asignar.
    return asignacion.operadorNombre.toLowerCase().trim() ==
        usuario.nombre.toLowerCase().trim();
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

  /// Salidas activas en las que participa [usuario].
  static Future<List<SalidaCampo>> listarSalidasParaUsuario(
    UsuarioCampo usuario,
  ) async {
    final salidas = await listar();
    return salidas.where((salida) {
      if (salida.estado == EstadoSalida.borrador ||
          salida.estado == EstadoSalida.cancelada) {
        return false;
      }
      return salida.equipo.any((m) => _miembroEsUsuario(m, usuario));
    }).toList()
      ..sort((a, b) => b.actualizadoEn.compareTo(a.actualizadoEn));
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

        final ejAsignacion = ejecucion.asignaciones
            .where((a) => a.asignacionId == asignacion.id)
            .firstOrNull;

        final features = <FeatureTareaVista>[];
        for (var i = 0; i < asignacion.featureIds.length; i++) {
          final featureId = asignacion.featureIds[i];
          final featureNombre = i < asignacion.featureNombres.length
              ? asignacion.featureNombres[i]
              : featureId;
          final registro = ejAsignacion?.registroDeFeature(featureId);
          features.add(
            FeatureTareaVista(
              featureId: featureId,
              featureNombre: featureNombre,
              estado: _estadoTareaDesdeEjecucion(
                registro?.estado ?? EstadoAsignacionEjecucion.pendiente,
              ),
            ),
          );
        }

        tareas.add(
          TareaSalidaVista(
            asignacionId: asignacion.id,
            salidaId: salida.id,
            salidaNombre: salida.nombre,
            templateNombre: asignacion.templateNombre,
            featureNombres: asignacion.featureNombres,
            features: features,
            ubicacionRuta: salida.ubicacionRuta,
            estado: _estadoTareaDesdeEjecucion(
              ejAsignacion?.estado ?? EstadoAsignacionEjecucion.pendiente,
            ),
            fechaAsignacion: asignacion.fechaSubArea == null
                ? null
                : normalizarFecha(asignacion.fechaSubArea!),
          ),
        );
      }
    }

    tareas.sort((a, b) {
      final fa = a.fechaAsignacion;
      final fb = b.fechaAsignacion;
      if (fa == null && fb == null) {
        return a.salidaNombre.compareTo(b.salidaNombre);
      }
      if (fa == null) return 1;
      if (fb == null) return -1;
      final porFecha = fa.compareTo(fb);
      if (porFecha != 0) return porFecha;
      return a.salidaNombre.compareTo(b.salidaNombre);
    });
    return tareas;
  }

  /// Indica si [usuario] es jefe de cuadrilla en el equipo de [salida].
  static bool usuarioEsLiderCuadrillaEnSalida(
    SalidaCampo salida,
    UsuarioCampo usuario,
  ) {
    return salida.equipo.any(
      (m) => _miembroEsUsuario(m, usuario) && RolesCampo.esLiderCuadrilla(m.rol),
    );
  }

  /// Tareas de operadores en salidas donde [lider] es jefe de cuadrilla.
  static Future<List<TareaEquipoVista>> listarTareasEquipoParaLiderCuadrilla(
    UsuarioCampo lider,
  ) async {
    if (!RolesCampo.esLiderCuadrilla(lider.rolCognito)) return [];

    final salidas = await listar();
    final tareas = <TareaEquipoVista>[];

    for (final salida in salidas) {
      if (!usuarioEsLiderCuadrillaEnSalida(salida, lider)) continue;
      if (salida.estado == EstadoSalida.borrador ||
          salida.estado == EstadoSalida.cancelada) {
        continue;
      }

      final ejecucion = await obtenerEjecucion(salida.id);

      for (final asignacion in salida.asignacionesPlantillas) {
        if (!RolesCampo.esOperador(asignacion.operadorRol)) continue;

        final ejAsignacion = ejecucion.asignaciones
            .where((a) => a.asignacionId == asignacion.id)
            .firstOrNull;

        final features = <FeatureTareaVista>[];
        for (var i = 0; i < asignacion.featureIds.length; i++) {
          final featureId = asignacion.featureIds[i];
          final featureNombre = i < asignacion.featureNombres.length
              ? asignacion.featureNombres[i]
              : featureId;
          final registro = ejAsignacion?.registroDeFeature(featureId);
          features.add(
            FeatureTareaVista(
              featureId: featureId,
              featureNombre: featureNombre,
              estado: _estadoTareaDesdeEjecucion(
                registro?.estado ?? EstadoAsignacionEjecucion.pendiente,
              ),
            ),
          );
        }

        tareas.add(
          TareaEquipoVista(
            asignacionId: asignacion.id,
            salidaId: salida.id,
            salidaNombre: salida.nombre,
            templateNombre: asignacion.templateNombre,
            operadorNombre: RolesCampo.normalizarNombre(
              asignacion.operadorNombre,
              rolCognito: asignacion.operadorRol,
            ),
            ubicacionRuta: salida.ubicacionRuta,
            estado: _estadoTareaDesdeEjecucion(
              ejAsignacion?.estado ?? EstadoAsignacionEjecucion.pendiente,
            ),
            features: features,
          ),
        );
      }
    }

    tareas.sort((a, b) {
      final porSalida = a.salidaNombre.compareTo(b.salidaNombre);
      if (porSalida != 0) return porSalida;
      return a.operadorNombre.compareTo(b.operadorNombre);
    });
    return tareas;
  }

  /// Checklists de salida individuales del usuario (como operador o como
  /// líder de cuadrilla), uno por cada combinación (salida, fecha) hasta hoy,
  /// para que vea únicamente su checklist diario y su observación.
  static Future<List<ChecklistSalidaVista>> listarChecklistsParaUsuario(
    UsuarioCampo usuario,
  ) async {
    final salidas = await listar();
    final vistas = <ChecklistSalidaVista>[];
    final hoy = normalizarFecha(DateTime.now());

    for (final salida in salidas) {
      if (salida.estado == EstadoSalida.borrador ||
          salida.estado == EstadoSalida.cancelada) {
        continue;
      }
      final checklist = salida.checklist;
      if (checklist == null || checklist.items.isEmpty) continue;

      final miembros = salida.equipo.where(
        (m) => _miembroEsUsuario(m, usuario),
      );
      if (miembros.isEmpty) continue;
      final miembro = miembros.first;

      final ejecucion = await obtenerEjecucion(salida.id);

      final diasVisibles = diasSalida(salida)
          .where((d) => !d.isAfter(hoy))
          .toList()
        ..sort((a, b) => b.compareTo(a));
      if (diasVisibles.isEmpty) continue;

      for (final dia in diasVisibles) {
        final personal = checklistDeMiembroEnFecha(ejecucion, miembro, dia);
        vistas.add(
          ChecklistSalidaVista(
            salidaId: salida.id,
            salidaNombre: salida.nombre,
            checklist: checklist,
            personaId: personaIdDeMiembro(miembro),
            personaNombre: miembro.nombre,
            personaRol: miembro.rol,
            fecha: dia,
            itemsCompletados:
                personal?.items.where((i) => i.completado).length ?? 0,
            completado: personal?.completado ?? false,
            observacion: personal?.observacion ?? '',
            observaciones: personal?.observaciones ?? const [],
          ),
        );
      }
    }

    vistas.sort((a, b) {
      final porSalida = a.salidaNombre.compareTo(b.salidaNombre);
      if (porSalida != 0) return porSalida;
      return b.fecha.compareTo(a.fecha);
    });
    return vistas;
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

    final dias = diasSalida(salida);
    final asignacionConDia = _conDiaPorDefecto(asignacion, dias);
    if (asignacionConDia.fechaSubArea != null &&
        esDiaSuspendido(salida, asignacionConDia.fechaSubArea!)) {
      throw StateError(
        'Ese día está suspendido por clima/acceso. Elige otro día de campo.',
      );
    }
    final ejecucion = await obtenerEjecucion(salidaId);

    validarAsignacionPlantillaPorDia(
      dias: dias,
      asignaciones: salida.asignacionesPlantillas,
      asignacion: asignacionConDia,
      ejecucion: ejecucion,
    );

    final asignacionesAntes =
        List<AsignacionPlantillaPlan>.from(salida.asignacionesPlantillas);
    final asignaciones = reasignarFeaturesEnMemoria(
      asignaciones: [...asignacionesAntes, asignacionConDia],
      destino: asignacionConDia,
      ejecucion: ejecucion,
    );

    final actualizada = await guardar(
      salida.copyWith(asignacionesPlantillas: asignaciones),
    );

    final ejecucionMovida = _moverRegistrosTrasReasignacion(
      ejecucion: ejecucion,
      asignacionesAntes: asignacionesAntes,
      destino: asignacionConDia,
      asignacionesDespues: asignaciones,
    );
    await _guardarEjecucion(ejecucionMovida);

    await _sincronizarEstadoSalida(salidaId);
    return actualizada;
  }

  /// Actualiza una asignación existente (misma id) y conserva su ejecución.
  static Future<SalidaCampo> actualizarAsignacionPlantilla({
    required String salidaId,
    required AsignacionPlantillaPlan asignacion,
  }) async {
    final salida = await obtener(salidaId);
    if (salida == null) {
      throw StateError('Salida no encontrada');
    }
    if (!puedeAsignarPlantillas(salida)) {
      throw StateError(
        'No se pueden editar asignaciones en el estado ${salida.estado.etiqueta}',
      );
    }

    final dias = diasSalida(salida);
    final asignacionConDia = _conDiaPorDefecto(asignacion, dias);
    if (asignacionConDia.fechaSubArea != null &&
        esDiaSuspendido(salida, asignacionConDia.fechaSubArea!)) {
      throw StateError(
        'Ese día está suspendido por clima/acceso. Elige otro día de campo.',
      );
    }
    final index = salida.asignacionesPlantillas.indexWhere(
      (a) => a.id == asignacionConDia.id,
    );
    if (index < 0) {
      throw StateError('Asignación no encontrada');
    }

    final ejecucion = await obtenerEjecucion(salidaId);

    validarAsignacionPlantillaPorDia(
      dias: dias,
      asignaciones: salida.asignacionesPlantillas,
      asignacion: asignacionConDia,
      excluirAsignacionId: asignacionConDia.id,
      ejecucion: ejecucion,
    );

    final asignacionesAntes =
        List<AsignacionPlantillaPlan>.from(salida.asignacionesPlantillas);
    final asignaciones = reasignarFeaturesEnMemoria(
      asignaciones: asignacionesAntes,
      destino: asignacionConDia,
      ejecucion: ejecucion,
    );

    final actualizada = await guardar(
      salida.copyWith(asignacionesPlantillas: asignaciones),
    );

    final ejecucionMovida = _moverRegistrosTrasReasignacion(
      ejecucion: ejecucion,
      asignacionesAntes: asignacionesAntes,
      destino: asignacionConDia,
      asignacionesDespues: asignaciones,
    );
    await _guardarEjecucion(ejecucionMovida);

    await _sincronizarEstadoSalida(salidaId);
    return actualizada;
  }

  /// Marca como "en curso" el registro de una feature/sub-área concreta al
  /// abrir su pantalla de ejecución, sin pisar un registro ya completado.
  static Future<void> marcarFeatureEnCurso({
    required String salidaId,
    required String asignacionId,
    required String featureId,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final asignaciones = ejecucion.asignaciones.map((a) {
      if (a.asignacionId != asignacionId) return a;
      final registros = a.registrosFeatures.map((r) {
        if (r.featureId != featureId ||
            r.estado != EstadoAsignacionEjecucion.pendiente) {
          return r;
        }
        return r.copyWith(estado: EstadoAsignacionEjecucion.enCurso);
      }).toList();
      return a.copyWith(registrosFeatures: registros);
    }).toList();

    await _guardarEjecucion(
      ejecucion.copyWith(
        asignaciones: asignaciones,
        actualizadoEn: DateTime.now(),
      ),
    );

    await _sincronizarEstadoSalida(salidaId);
  }

  /// Guarda audio, transcripción, observaciones, coordenadas GPS y
  /// evidencia fotográfica del registro de una feature/sub-área concreta
  /// dentro de una asignación. Cada feature se completa de forma
  /// independiente: completar una no afecta al resto de features de la
  /// misma tarea.
  static Future<void> guardarRegistroFeature({
    required String salidaId,
    required String asignacionId,
    required String featureId,
    required String featureNombre,
    CoordenadaActual? coordenada,
    String? observaciones,
    double? valorNumerico,
    String? rutaAudio,
    String? transcripcionAudio,
    List<EvidenciaRegistroFeature> evidencias = const [],
    bool marcarCompletada = true,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final nuevoEstado = marcarCompletada
        ? EstadoAsignacionEjecucion.completada
        : EstadoAsignacionEjecucion.enCurso;
    final ahora = DateTime.now();

    final asignaciones = ejecucion.asignaciones.map((a) {
      if (a.asignacionId != asignacionId) return a;

      var encontrado = false;
      final registros = a.registrosFeatures.map((r) {
        if (r.featureId != featureId) return r;
        encontrado = true;
        return r.copyWith(
          estado: nuevoEstado,
          latitud: coordenada?.latitud,
          longitud: coordenada?.longitud,
          precisionMetros: coordenada?.precisionMetros,
          coordenadasCapturadasEn: coordenada?.capturadaEn,
          observaciones: observaciones,
          valorNumerico: valorNumerico,
          rutaAudio: rutaAudio,
          transcripcionAudio: transcripcionAudio,
          evidencias: evidencias,
          completadoEn: marcarCompletada ? ahora : null,
        );
      }).toList();

      if (!encontrado) {
        registros.add(
          RegistroFeatureEjecucion(
            featureId: featureId,
            featureNombre: featureNombre,
            estado: nuevoEstado,
            latitud: coordenada?.latitud,
            longitud: coordenada?.longitud,
            precisionMetros: coordenada?.precisionMetros,
            coordenadasCapturadasEn: coordenada?.capturadaEn,
            observaciones: observaciones,
            valorNumerico: valorNumerico,
            rutaAudio: rutaAudio,
            transcripcionAudio: transcripcionAudio,
            evidencias: evidencias,
            completadoEn: marcarCompletada ? ahora : null,
          ),
        );
      }

      return a.copyWith(registrosFeatures: registros);
    }).toList();

    await _guardarEjecucion(
      ejecucion.copyWith(asignaciones: asignaciones, actualizadoEn: ahora),
    );

    await _sincronizarEstadoSalida(salidaId);
  }

  /// Fuerza el estado de **todas** las features de una asignación a la vez
  /// (atajo del líder/jefe de proyecto desde el resumen de la salida). El
  /// operador sigue completando feature por feature desde sus tareas; esto
  /// es solo para que el líder pueda reabrir o cerrar administrativamente
  /// una asignación completa.
  static Future<void> marcarTodasLasFeaturesDeAsignacion({
    required String salidaId,
    required String asignacionId,
    required EstadoAsignacionEjecucion estado,
  }) async {
    final ejecucion = await obtenerEjecucion(salidaId);
    final asignaciones = ejecucion.asignaciones.map((a) {
      if (a.asignacionId != asignacionId) return a;
      final registros =
          a.registrosFeatures.map((r) => r.copyWith(estado: estado)).toList();
      return a.copyWith(estado: estado, registrosFeatures: registros);
    }).toList();

    await _guardarEjecucion(
      ejecucion.copyWith(
        asignaciones: asignaciones,
        actualizadoEn: DateTime.now(),
      ),
    );

    await _sincronizarEstadoSalida(salidaId);
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
