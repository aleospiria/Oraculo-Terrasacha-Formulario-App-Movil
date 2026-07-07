import 'chequeo_vehiculo.dart';
import 'lista_chequeo.dart';

/// Borrador local del plan de campo (sin entidad en GraphQL).
class SubAreaPlanDia {
  final DateTime fecha;
  final String subAreaGeoJson;

  const SubAreaPlanDia({
    required this.fecha,
    required this.subAreaGeoJson,
  });

  Map<String, dynamic> toJson() => {
        'fecha': fecha.toIso8601String(),
        'subAreaGeoJson': subAreaGeoJson,
      };

  factory SubAreaPlanDia.fromJson(Map<String, dynamic> json) {
    return SubAreaPlanDia(
      fecha: DateTime.parse(json['fecha'] as String),
      subAreaGeoJson: json['subAreaGeoJson'] as String,
    );
  }
}

/// Asignación plantilla → responsable (operador o jefe de cuadrilla).
class AsignacionPlantillaPlan {
  final String id;
  final String templateId;
  final String templateNombre;
  final List<String> featureIds;
  final List<String> featureNombres;
  final String operadorNombre;
  final String operadorRol;
  final String? responsableUserId;
  final DateTime? fechaSubArea;

  const AsignacionPlantillaPlan({
    required this.id,
    required this.templateId,
    required this.templateNombre,
    required this.featureIds,
    required this.featureNombres,
    required this.operadorNombre,
    required this.operadorRol,
    this.responsableUserId,
    this.fechaSubArea,
  });

  String get responsableNombre => operadorNombre;
  String get responsableRol => operadorRol;

  Map<String, dynamic> toJson() => {
        'id': id,
        'templateId': templateId,
        'templateNombre': templateNombre,
        'featureIds': featureIds,
        'featureNombres': featureNombres,
        'operadorNombre': operadorNombre,
        'operadorRol': operadorRol,
        'responsableUserId': responsableUserId,
        'fechaSubArea': fechaSubArea?.toIso8601String(),
      };

  factory AsignacionPlantillaPlan.fromJson(Map<String, dynamic> json) {
    return AsignacionPlantillaPlan(
      id: json['id'] as String,
      templateId: json['templateId'] as String,
      templateNombre: json['templateNombre'] as String,
      featureIds: List<String>.from(json['featureIds'] as List),
      featureNombres: List<String>.from(json['featureNombres'] as List),
      operadorNombre: json['operadorNombre'] as String,
      operadorRol: json['operadorRol'] as String,
      responsableUserId: json['responsableUserId'] as String?,
      fechaSubArea: json['fechaSubArea'] != null
          ? DateTime.parse(json['fechaSubArea'] as String)
          : null,
    );
  }

  AsignacionPlantillaPlan copyWith({
    String? id,
    String? templateId,
    String? templateNombre,
    List<String>? featureIds,
    List<String>? featureNombres,
    String? operadorNombre,
    String? operadorRol,
    String? responsableUserId,
    DateTime? fechaSubArea,
  }) {
    return AsignacionPlantillaPlan(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      templateNombre: templateNombre ?? this.templateNombre,
      featureIds: featureIds ?? this.featureIds,
      featureNombres: featureNombres ?? this.featureNombres,
      operadorNombre: operadorNombre ?? this.operadorNombre,
      operadorRol: operadorRol ?? this.operadorRol,
      responsableUserId: responsableUserId ?? this.responsableUserId,
      fechaSubArea: fechaSubArea ?? this.fechaSubArea,
    );
  }
}

class MiembroEquipoPlan {
  final String nombre;
  final String rol;

  const MiembroEquipoPlan({
    required this.nombre,
    required this.rol,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'rol': rol,
      };

  factory MiembroEquipoPlan.fromJson(Map<String, dynamic> json) {
    return MiembroEquipoPlan(
      nombre: json['nombre'] as String,
      rol: json['rol'] as String,
    );
  }
}

class ChecklistPlanAsignado {
  final String listaId;
  final String nombre;
  final String origen;
  final List<ItemListaChequeo> items;

  const ChecklistPlanAsignado({
    required this.listaId,
    required this.nombre,
    required this.origen,
    this.items = const [],
  });

  Map<String, dynamic> toJson() => {
        'listaId': listaId,
        'nombre': nombre,
        'origen': origen,
        'items': items.map((i) => i.toJson()).toList(),
      };

  factory ChecklistPlanAsignado.fromJson(Map<String, dynamic> json) {
    return ChecklistPlanAsignado(
      listaId: json['listaId'] as String,
      nombre: json['nombre'] as String,
      origen: json['origen'] as String? ?? 'administrador',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => ItemListaChequeo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PlanCampoBorrador {
  final String nombre;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? proyectoId;
  final String? proyectoNombre;
  final String? topologiaId;
  final String? ubicacionRuta;
  final String? poligonoPadreGeoJson;
  final List<SubAreaPlanDia> subAreasPorDia;
  final List<MiembroEquipoPlan> equipo;
  final String? checklistNombre;
  final ChecklistPlanAsignado? checklist;
  final List<AsignacionPlantillaPlan> asignacionesPlantillas;
  final DateTime creadoEn;

  const PlanCampoBorrador({
    required this.nombre,
    this.fechaInicio,
    this.fechaFin,
    this.proyectoId,
    this.proyectoNombre,
    this.topologiaId,
    this.ubicacionRuta,
    this.poligonoPadreGeoJson,
    this.subAreasPorDia = const [],
    this.equipo = const [],
    this.checklistNombre,
    this.checklist,
    this.asignacionesPlantillas = const [],
    required this.creadoEn,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'fechaInicio': fechaInicio?.toIso8601String(),
        'fechaFin': fechaFin?.toIso8601String(),
        'proyectoId': proyectoId,
        'proyectoNombre': proyectoNombre,
        'topologiaId': topologiaId,
        'ubicacionRuta': ubicacionRuta,
        'poligonoPadreGeoJson': poligonoPadreGeoJson,
        'subAreasPorDia': subAreasPorDia.map((s) => s.toJson()).toList(),
        'equipo': equipo.map((m) => m.toJson()).toList(),
        'checklistNombre': checklistNombre ?? checklist?.nombre,
        'checklist': checklist?.toJson(),
        'asignacionesPlantillas':
            asignacionesPlantillas.map((a) => a.toJson()).toList(),
        'creadoEn': creadoEn.toIso8601String(),
      };

  factory PlanCampoBorrador.fromJson(Map<String, dynamic> json) {
    return PlanCampoBorrador(
      nombre: json['nombre'] as String,
      fechaInicio: json['fechaInicio'] != null
          ? DateTime.parse(json['fechaInicio'] as String)
          : null,
      fechaFin: json['fechaFin'] != null
          ? DateTime.parse(json['fechaFin'] as String)
          : null,
      proyectoId: json['proyectoId'] as String?,
      proyectoNombre: json['proyectoNombre'] as String?,
      topologiaId: json['topologiaId'] as String?,
      ubicacionRuta: json['ubicacionRuta'] as String?,
      poligonoPadreGeoJson: json['poligonoPadreGeoJson'] as String?,
      subAreasPorDia: (json['subAreasPorDia'] as List<dynamic>? ?? [])
          .map((e) => SubAreaPlanDia.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipo: (json['equipo'] as List<dynamic>? ?? [])
          .map((e) => MiembroEquipoPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      checklistNombre: json['checklistNombre'] as String?,
      checklist: json['checklist'] != null
          ? ChecklistPlanAsignado.fromJson(
              json['checklist'] as Map<String, dynamic>,
            )
          : null,
      asignacionesPlantillas:
          (json['asignacionesPlantillas'] as List<dynamic>? ?? [])
              .map(
                (e) => AsignacionPlantillaPlan.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      creadoEn: DateTime.parse(json['creadoEn'] as String),
    );
  }
}

// ── Salida de campo (plan publicado / ejecutable) ─────────────────────────────

enum EstadoSalida {
  borrador,
  programada,
  enCurso,
  incompleta,
  completada,
  cancelada,
  /// Dato local expirado sin sincronizar — en período de gracia antes del borrado.
  caducada,
}

enum MotivoClonacionSalida {
  incompleta,
  reasignacionOperador,
}

enum ModoClonacionSalida {
  soloPendientes,
  replanificarCompleta,
}

extension EstadoSalidaX on EstadoSalida {
  String get etiqueta {
    switch (this) {
      case EstadoSalida.borrador:
        return 'Borrador';
      case EstadoSalida.programada:
        return 'Programada';
      case EstadoSalida.enCurso:
        return 'En curso';
      case EstadoSalida.incompleta:
        return 'Incompleta';
      case EstadoSalida.completada:
        return 'Completada';
      case EstadoSalida.cancelada:
        return 'Cancelada';
      case EstadoSalida.caducada:
        return 'Caducada';
    }
  }

  String toJson() => name;

  static EstadoSalida fromJson(String? value) {
    return EstadoSalida.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EstadoSalida.borrador,
    );
  }
}

/// Instancia ejecutable de un plan de campo (salida operacional).
class SalidaCampo {
  /// Valor por defecto de retención en el dispositivo (días).
  static const int diasRetencionPorDefecto = 30;

  /// Días de retención configurables por el usuario. Se carga al arrancar la app
  /// desde ServicioConfiguracionRetencion; si no hay valor guardado usa
  /// [diasRetencionPorDefecto].
  static int diasRetencionDispositivo = diasRetencionPorDefecto;

  static const int diasGraciaSinSync = 7;

  final String id;
  final String nombre;
  final EstadoSalida estado;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? proyectoId;
  final String? proyectoNombre;
  final String? topologiaId;
  final String? ubicacionRuta;
  final String? poligonoPadreGeoJson;
  final List<SubAreaPlanDia> subAreasPorDia;
  final List<MiembroEquipoPlan> equipo;
  final String? checklistNombre;
  final ChecklistPlanAsignado? checklist;
  final List<AsignacionPlantillaPlan> asignacionesPlantillas;
  final String? salidaOrigenId;
  final MotivoClonacionSalida? motivoClonacion;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final DateTime? publicadoEn;
  /// Fecha en que los datos fueron subidos a la nube. Null = pendiente de sync.
  final DateTime? sincronizadoEn;

  const SalidaCampo({
    required this.id,
    required this.nombre,
    this.estado = EstadoSalida.borrador,
    this.fechaInicio,
    this.fechaFin,
    this.proyectoId,
    this.proyectoNombre,
    this.topologiaId,
    this.ubicacionRuta,
    this.poligonoPadreGeoJson,
    this.subAreasPorDia = const [],
    this.equipo = const [],
    this.checklistNombre,
    this.checklist,
    this.asignacionesPlantillas = const [],
    this.salidaOrigenId,
    this.motivoClonacion,
    required this.creadoEn,
    required this.actualizadoEn,
    this.publicadoEn,
    this.sincronizadoEn,
  });

  // ── Ciclo de vida en dispositivo ──────────────────────────────────────────

  /// La salida expira 30 días después de su sincronización (si existe)
  /// o 30 días después de su creación más 7 días de gracia (si nunca se sincronizó).
  DateTime get expiraEn {
    if (sincronizadoEn != null) {
      return sincronizadoEn!.add(Duration(days: diasRetencionDispositivo));
    }
    return creadoEn.add(
      Duration(days: diasRetencionDispositivo + diasGraciaSinSync),
    );
  }

  /// Días restantes antes de que se purgue del dispositivo (puede ser negativo).
  int get diasParaExpirar => expiraEn.difference(DateTime.now()).inDays;

  /// La salida ya superó su fecha de expiración en el dispositivo.
  bool get estaExpirada => DateTime.now().isAfter(expiraEn);

  /// Los datos están en la nube → no se pueden volver a modificar localmente.
  bool get estaSincronizada => sincronizadoEn != null;

  /// El dato no sincronizado lleva más de 30 días sin subirse (período de gracia activo).
  bool get enGraciaSinSync {
    if (sincronizadoEn != null) return false;
    final limiteSinGracia = creadoEn.add(
      Duration(days: diasRetencionDispositivo),
    );
    return DateTime.now().isAfter(limiteSinGracia) && !estaExpirada;
  }

  factory SalidaCampo.desdePlan(PlanCampoBorrador plan, {required String id}) {
    final ahora = DateTime.now();
    return SalidaCampo(
      id: id,
      nombre: plan.nombre,
      estado: EstadoSalida.borrador,
      fechaInicio: plan.fechaInicio,
      fechaFin: plan.fechaFin,
      proyectoId: plan.proyectoId,
      proyectoNombre: plan.proyectoNombre,
      topologiaId: plan.topologiaId,
      ubicacionRuta: plan.ubicacionRuta,
      poligonoPadreGeoJson: plan.poligonoPadreGeoJson,
      subAreasPorDia: plan.subAreasPorDia,
      equipo: plan.equipo,
      checklistNombre: plan.checklistNombre,
      checklist: plan.checklist,
      asignacionesPlantillas: plan.asignacionesPlantillas,
      creadoEn: plan.creadoEn,
      actualizadoEn: ahora,
      sincronizadoEn: null,
    );
  }

  PlanCampoBorrador toPlanCampoBorrador() {
    return PlanCampoBorrador(
      nombre: nombre,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      proyectoId: proyectoId,
      proyectoNombre: proyectoNombre,
      topologiaId: topologiaId,
      ubicacionRuta: ubicacionRuta,
      poligonoPadreGeoJson: poligonoPadreGeoJson,
      subAreasPorDia: subAreasPorDia,
      equipo: equipo,
      checklistNombre: checklistNombre,
      checklist: checklist,
      asignacionesPlantillas: asignacionesPlantillas,
      creadoEn: creadoEn,
    );
  }

  SalidaCampo copyWith({
    String? id,
    String? nombre,
    EstadoSalida? estado,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? proyectoId,
    String? proyectoNombre,
    String? topologiaId,
    String? ubicacionRuta,
    String? poligonoPadreGeoJson,
    List<SubAreaPlanDia>? subAreasPorDia,
    List<MiembroEquipoPlan>? equipo,
    String? checklistNombre,
    ChecklistPlanAsignado? checklist,
    List<AsignacionPlantillaPlan>? asignacionesPlantillas,
    String? salidaOrigenId,
    MotivoClonacionSalida? motivoClonacion,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    DateTime? publicadoEn,
    DateTime? sincronizadoEn,
  }) {
    return SalidaCampo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      estado: estado ?? this.estado,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      proyectoId: proyectoId ?? this.proyectoId,
      proyectoNombre: proyectoNombre ?? this.proyectoNombre,
      topologiaId: topologiaId ?? this.topologiaId,
      ubicacionRuta: ubicacionRuta ?? this.ubicacionRuta,
      poligonoPadreGeoJson: poligonoPadreGeoJson ?? this.poligonoPadreGeoJson,
      subAreasPorDia: subAreasPorDia ?? this.subAreasPorDia,
      equipo: equipo ?? this.equipo,
      checklistNombre: checklistNombre ?? this.checklistNombre,
      checklist: checklist ?? this.checklist,
      asignacionesPlantillas:
          asignacionesPlantillas ?? this.asignacionesPlantillas,
      salidaOrigenId: salidaOrigenId ?? this.salidaOrigenId,
      motivoClonacion: motivoClonacion ?? this.motivoClonacion,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      publicadoEn: publicadoEn ?? this.publicadoEn,
      sincronizadoEn: sincronizadoEn ?? this.sincronizadoEn,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'estado': estado.toJson(),
        'fechaInicio': fechaInicio?.toIso8601String(),
        'fechaFin': fechaFin?.toIso8601String(),
        'proyectoId': proyectoId,
        'proyectoNombre': proyectoNombre,
        'topologiaId': topologiaId,
        'ubicacionRuta': ubicacionRuta,
        'poligonoPadreGeoJson': poligonoPadreGeoJson,
        'subAreasPorDia': subAreasPorDia.map((s) => s.toJson()).toList(),
        'equipo': equipo.map((m) => m.toJson()).toList(),
        'checklistNombre': checklistNombre ?? checklist?.nombre,
        'checklist': checklist?.toJson(),
        'asignacionesPlantillas':
            asignacionesPlantillas.map((a) => a.toJson()).toList(),
        'salidaOrigenId': salidaOrigenId,
        'motivoClonacion': motivoClonacion?.name,
        'creadoEn': creadoEn.toIso8601String(),
        'actualizadoEn': actualizadoEn.toIso8601String(),
        'publicadoEn': publicadoEn?.toIso8601String(),
        'sincronizadoEn': sincronizadoEn?.toIso8601String(),
      };

  factory SalidaCampo.fromJson(Map<String, dynamic> json) {
    return SalidaCampo(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      estado: EstadoSalidaX.fromJson(json['estado'] as String?),
      fechaInicio: json['fechaInicio'] != null
          ? DateTime.parse(json['fechaInicio'] as String)
          : null,
      fechaFin: json['fechaFin'] != null
          ? DateTime.parse(json['fechaFin'] as String)
          : null,
      proyectoId: json['proyectoId'] as String?,
      proyectoNombre: json['proyectoNombre'] as String?,
      topologiaId: json['topologiaId'] as String?,
      ubicacionRuta: json['ubicacionRuta'] as String?,
      poligonoPadreGeoJson: json['poligonoPadreGeoJson'] as String?,
      subAreasPorDia: (json['subAreasPorDia'] as List<dynamic>? ?? [])
          .map((e) => SubAreaPlanDia.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipo: (json['equipo'] as List<dynamic>? ?? [])
          .map((e) => MiembroEquipoPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      checklistNombre: json['checklistNombre'] as String?,
      checklist: json['checklist'] != null
          ? ChecklistPlanAsignado.fromJson(
              json['checklist'] as Map<String, dynamic>,
            )
          : null,
      asignacionesPlantillas:
          (json['asignacionesPlantillas'] as List<dynamic>? ?? [])
              .map(
                (e) => AsignacionPlantillaPlan.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      salidaOrigenId: json['salidaOrigenId'] as String?,
      motivoClonacion: json['motivoClonacion'] != null
          ? MotivoClonacionSalida.values.firstWhere(
              (m) => m.name == json['motivoClonacion'],
              orElse: () => MotivoClonacionSalida.incompleta,
            )
          : null,
      creadoEn: DateTime.parse(json['creadoEn'] as String),
      actualizadoEn: DateTime.parse(json['actualizadoEn'] as String),
      publicadoEn: json['publicadoEn'] != null
          ? DateTime.parse(json['publicadoEn'] as String)
          : null,
      sincronizadoEn: json['sincronizadoEn'] != null
          ? DateTime.parse(json['sincronizadoEn'] as String)
          : null,
    );
  }
}

// ── Ejecución / progreso de la salida ───────────────────────────────────────

enum EstadoAsignacionEjecucion { pendiente, enCurso, completada, cancelada }

class AsignacionEjecucionSalida {
  final String asignacionId;
  final EstadoAsignacionEjecucion estado;
  final double? latitud;
  final double? longitud;
  final double? precisionMetros;
  final DateTime? coordenadasCapturadasEn;
  final String? observaciones;
  final String? rutaAudio;

  const AsignacionEjecucionSalida({
    required this.asignacionId,
    this.estado = EstadoAsignacionEjecucion.pendiente,
    this.latitud,
    this.longitud,
    this.precisionMetros,
    this.coordenadasCapturadasEn,
    this.observaciones,
    this.rutaAudio,
  });

  bool get tieneCoordenadas => latitud != null && longitud != null;

  String? get coordenadasTexto {
    if (!tieneCoordenadas) return null;
    return '${latitud!.toStringAsFixed(6)}, ${longitud!.toStringAsFixed(6)}';
  }

  Map<String, dynamic> toJson() => {
        'asignacionId': asignacionId,
        'estado': estado.name,
        if (latitud != null) 'latitud': latitud,
        if (longitud != null) 'longitud': longitud,
        if (precisionMetros != null) 'precisionMetros': precisionMetros,
        if (coordenadasCapturadasEn != null)
          'coordenadasCapturadasEn': coordenadasCapturadasEn!.toIso8601String(),
        if (observaciones != null) 'observaciones': observaciones,
        if (rutaAudio != null) 'rutaAudio': rutaAudio,
      };

  factory AsignacionEjecucionSalida.fromJson(Map<String, dynamic> json) {
    return AsignacionEjecucionSalida(
      asignacionId: json['asignacionId'] as String,
      estado: EstadoAsignacionEjecucion.values.firstWhere(
        (e) => e.name == json['estado'],
        orElse: () => EstadoAsignacionEjecucion.pendiente,
      ),
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      precisionMetros: (json['precisionMetros'] as num?)?.toDouble(),
      coordenadasCapturadasEn: json['coordenadasCapturadasEn'] != null
          ? DateTime.parse(json['coordenadasCapturadasEn'] as String)
          : null,
      observaciones: json['observaciones'] as String?,
      rutaAudio: json['rutaAudio'] as String?,
    );
  }

  AsignacionEjecucionSalida copyWith({
    EstadoAsignacionEjecucion? estado,
    double? latitud,
    double? longitud,
    double? precisionMetros,
    DateTime? coordenadasCapturadasEn,
    String? observaciones,
    String? rutaAudio,
  }) {
    return AsignacionEjecucionSalida(
      asignacionId: asignacionId,
      estado: estado ?? this.estado,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      precisionMetros: precisionMetros ?? this.precisionMetros,
      coordenadasCapturadasEn:
          coordenadasCapturadasEn ?? this.coordenadasCapturadasEn,
      observaciones: observaciones ?? this.observaciones,
      rutaAudio: rutaAudio ?? this.rutaAudio,
    );
  }
}

class ChecklistItemEjecucionSalida {
  final String itemId;
  final bool completado;

  const ChecklistItemEjecucionSalida({
    required this.itemId,
    this.completado = false,
  });

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'completado': completado,
      };

  factory ChecklistItemEjecucionSalida.fromJson(Map<String, dynamic> json) {
    return ChecklistItemEjecucionSalida(
      itemId: json['itemId'] as String,
      completado: json['completado'] as bool? ?? false,
    );
  }

  ChecklistItemEjecucionSalida copyWith({bool? completado}) {
    return ChecklistItemEjecucionSalida(
      itemId: itemId,
      completado: completado ?? this.completado,
    );
  }
}

class EjecucionSalida {
  final String salidaId;
  final List<AsignacionEjecucionSalida> asignaciones;
  final List<ChecklistItemEjecucionSalida> checklistItems;
  final ChequeoVehiculoSalida? chequeoVehiculo;
  final DateTime actualizadoEn;

  const EjecucionSalida({
    required this.salidaId,
    this.asignaciones = const [],
    this.checklistItems = const [],
    this.chequeoVehiculo,
    required this.actualizadoEn,
  });

  EjecucionSalida copyWith({
    List<AsignacionEjecucionSalida>? asignaciones,
    List<ChecklistItemEjecucionSalida>? checklistItems,
    ChequeoVehiculoSalida? chequeoVehiculo,
    DateTime? actualizadoEn,
  }) {
    return EjecucionSalida(
      salidaId: salidaId,
      asignaciones: asignaciones ?? this.asignaciones,
      checklistItems: checklistItems ?? this.checklistItems,
      chequeoVehiculo: chequeoVehiculo ?? this.chequeoVehiculo,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  Map<String, dynamic> toJson() => {
        'salidaId': salidaId,
        'asignaciones': asignaciones.map((a) => a.toJson()).toList(),
        'checklistItems': checklistItems.map((c) => c.toJson()).toList(),
        if (chequeoVehiculo != null) 'chequeoVehiculo': chequeoVehiculo!.toJson(),
        'actualizadoEn': actualizadoEn.toIso8601String(),
      };

  factory EjecucionSalida.fromJson(Map<String, dynamic> json) {
    return EjecucionSalida(
      salidaId: json['salidaId'] as String,
      asignaciones: (json['asignaciones'] as List<dynamic>? ?? [])
          .map(
            (e) => AsignacionEjecucionSalida.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      checklistItems: (json['checklistItems'] as List<dynamic>? ?? [])
          .map(
            (e) => ChecklistItemEjecucionSalida.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      chequeoVehiculo: json['chequeoVehiculo'] != null
          ? ChequeoVehiculoSalida.fromJson(
              json['chequeoVehiculo'] as Map<String, dynamic>,
            )
          : null,
      actualizadoEn: DateTime.parse(json['actualizadoEn'] as String),
    );
  }
}
