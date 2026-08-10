import 'checklist_salida_ejecucion.dart';
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

/// Feature ya asignada en la salida (puede estar completada o reasignable).
class FeatureAsignadaPrevio {
  final String featureId;
  final String featureNombre;
  final String asignacionId;
  final String operadorNombre;
  final DateTime? fecha;
  final bool sinDiaEspecifico;
  final bool completada;

  const FeatureAsignadaPrevio({
    required this.featureId,
    required this.featureNombre,
    required this.asignacionId,
    this.operadorNombre = '',
    this.fecha,
    this.sinDiaEspecifico = false,
    this.completada = false,
  });

  String etiquetaFecha(String Function(DateTime) formatear) {
    if (sinDiaEspecifico) return 'sin día específico';
    if (fecha == null) return 'día desconocido';
    return formatear(fecha!);
  }
}

class MiembroEquipoPlan {
  /// Id de Cognito del miembro (si se seleccionó desde el listado de usuarios).
  /// Es la clave preferida para anclar el checklist individual de esta persona.
  final String? userId;
  final String nombre;
  final String rol;

  const MiembroEquipoPlan({
    this.userId,
    required this.nombre,
    required this.rol,
  });

  Map<String, dynamic> toJson() => {
        if (userId != null && userId!.isNotEmpty) 'userId': userId,
        'nombre': nombre,
        'rol': rol,
      };

  factory MiembroEquipoPlan.fromJson(Map<String, dynamic> json) {
    return MiembroEquipoPlan(
      userId: json['userId'] as String?,
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
  /// Si es false, la salida no exige ni muestra chequeo de transporte.
  final bool requiereChequeoVehiculo;

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
    this.requiereChequeoVehiculo = true,
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
        'requiereChequeoVehiculo': requiereChequeoVehiculo,
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
      requiereChequeoVehiculo:
          json['requiereChequeoVehiculo'] as bool? ?? true,
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

/// Día de campo suspendido (p. ej. lluvia) y, si aplica, a qué día se movió el trabajo.
class DiaSuspendidoSalida {
  final DateTime fecha;
  /// `lluvia` | `acceso` | `otro`
  final String motivo;
  final DateTime? reprogramadoA;
  final DateTime suspendidoEn;
  final String? suspendidoPorNombre;

  const DiaSuspendidoSalida({
    required this.fecha,
    required this.motivo,
    this.reprogramadoA,
    required this.suspendidoEn,
    this.suspendidoPorNombre,
  });

  String get motivoEtiqueta {
    switch (motivo) {
      case 'lluvia':
        return 'Lluvia / clima';
      case 'acceso':
        return 'Sin acceso al predio';
      default:
        return 'Otro motivo';
    }
  }

  Map<String, dynamic> toJson() => {
        'fecha': fecha.toIso8601String(),
        'motivo': motivo,
        if (reprogramadoA != null)
          'reprogramadoA': reprogramadoA!.toIso8601String(),
        'suspendidoEn': suspendidoEn.toIso8601String(),
        if (suspendidoPorNombre != null)
          'suspendidoPorNombre': suspendidoPorNombre,
      };

  factory DiaSuspendidoSalida.fromJson(Map<String, dynamic> json) {
    return DiaSuspendidoSalida(
      fecha: DateTime.parse(json['fecha'] as String),
      motivo: json['motivo'] as String? ?? 'lluvia',
      reprogramadoA: json['reprogramadoA'] != null
          ? DateTime.parse(json['reprogramadoA'] as String)
          : null,
      suspendidoEn: json['suspendidoEn'] != null
          ? DateTime.parse(json['suspendidoEn'] as String)
          : DateTime.now(),
      suspendidoPorNombre: json['suspendidoPorNombre'] as String?,
    );
  }
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
  /// Días marcados como no operables (clima, acceso, etc.).
  final List<DiaSuspendidoSalida> diasSuspendidos;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final DateTime? publicadoEn;
  /// Fecha en que los datos fueron subidos a la nube. Null = pendiente de sync.
  final DateTime? sincronizadoEn;
  /// Si es false, no se exige ni se muestra el chequeo de transporte.
  final bool requiereChequeoVehiculo;

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
    this.diasSuspendidos = const [],
    required this.creadoEn,
    required this.actualizadoEn,
    this.publicadoEn,
    this.sincronizadoEn,
    this.requiereChequeoVehiculo = true,
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
      requiereChequeoVehiculo: plan.requiereChequeoVehiculo,
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
      requiereChequeoVehiculo: requiereChequeoVehiculo,
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
    List<DiaSuspendidoSalida>? diasSuspendidos,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
    DateTime? publicadoEn,
    DateTime? sincronizadoEn,
    bool? requiereChequeoVehiculo,
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
      diasSuspendidos: diasSuspendidos ?? this.diasSuspendidos,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      publicadoEn: publicadoEn ?? this.publicadoEn,
      sincronizadoEn: sincronizadoEn ?? this.sincronizadoEn,
      requiereChequeoVehiculo:
          requiereChequeoVehiculo ?? this.requiereChequeoVehiculo,
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
        'diasSuspendidos': diasSuspendidos.map((d) => d.toJson()).toList(),
        'creadoEn': creadoEn.toIso8601String(),
        'actualizadoEn': actualizadoEn.toIso8601String(),
        'publicadoEn': publicadoEn?.toIso8601String(),
        'sincronizadoEn': sincronizadoEn?.toIso8601String(),
        'requiereChequeoVehiculo': requiereChequeoVehiculo,
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
      diasSuspendidos: (json['diasSuspendidos'] as List<dynamic>? ?? [])
          .map((e) => DiaSuspendidoSalida.fromJson(e as Map<String, dynamic>))
          .toList(),
      creadoEn: DateTime.parse(json['creadoEn'] as String),
      actualizadoEn: DateTime.parse(json['actualizadoEn'] as String),
      publicadoEn: json['publicadoEn'] != null
          ? DateTime.parse(json['publicadoEn'] as String)
          : null,
      sincronizadoEn: json['sincronizadoEn'] != null
          ? DateTime.parse(json['sincronizadoEn'] as String)
          : null,
      requiereChequeoVehiculo:
          json['requiereChequeoVehiculo'] as bool? ?? true,
    );
  }
}

// ── Ejecución / progreso de la salida ───────────────────────────────────────

enum EstadoAsignacionEjecucion { pendiente, enCurso, completada, cancelada }

/// Evidencia fotográfica de un [RegistroFeatureEjecucion]. Misma forma que
/// [EvidenciaChecklistSalida], pero con su propio tipo para no mezclar
/// semánticas (una es evidencia de checklist personal, la otra de un
/// registro de feature/sub-área de una plantilla).
class EvidenciaRegistroFeature {
  final String id;
  final String rutaLocal;
  final String? descripcion;
  final DateTime capturadaEn;

  const EvidenciaRegistroFeature({
    required this.id,
    required this.rutaLocal,
    this.descripcion,
    required this.capturadaEn,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'rutaLocal': rutaLocal,
        if (descripcion != null) 'descripcion': descripcion,
        'capturadaEn': capturadaEn.toIso8601String(),
      };

  factory EvidenciaRegistroFeature.fromJson(Map<String, dynamic> json) {
    return EvidenciaRegistroFeature(
      id: json['id'] as String? ?? '',
      rutaLocal: json['rutaLocal'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      capturadaEn: DateTime.tryParse(json['capturadaEn'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// Registro individual de una feature/sub-área dentro de una asignación de
/// plantilla. Cada feature tiene su propio estado, coordenadas, audio,
/// transcripción y evidencia fotográfica: una tarea con varias features se
/// completa feature por feature, no todas de una sola vez.
class RegistroFeatureEjecucion {
  final String featureId;
  final String featureNombre;
  final EstadoAsignacionEjecucion estado;
  final double? latitud;
  final double? longitud;
  final double? precisionMetros;
  final DateTime? coordenadasCapturadasEn;
  final String? observaciones;
  /// Valor numérico cuando la feature es de tipo float / medición exacta.
  final double? valorNumerico;
  final String? rutaAudio;
  /// Texto transcrito localmente (offline) del audio de este registro, si
  /// se grabó con transcripción. Se vuelca en [observaciones] al guardar,
  /// pero se conserva aparte para saber que el texto viene de una
  /// transcripción y no de tipeo manual.
  final String? transcripcionAudio;
  final List<EvidenciaRegistroFeature> evidencias;
  final DateTime? completadoEn;

  const RegistroFeatureEjecucion({
    required this.featureId,
    required this.featureNombre,
    this.estado = EstadoAsignacionEjecucion.pendiente,
    this.latitud,
    this.longitud,
    this.precisionMetros,
    this.coordenadasCapturadasEn,
    this.observaciones,
    this.valorNumerico,
    this.rutaAudio,
    this.transcripcionAudio,
    this.evidencias = const [],
    this.completadoEn,
  });

  bool get tieneCoordenadas => latitud != null && longitud != null;

  String? get coordenadasTexto {
    if (!tieneCoordenadas) return null;
    return '${latitud!.toStringAsFixed(6)}, ${longitud!.toStringAsFixed(6)}';
  }

  RegistroFeatureEjecucion copyWith({
    EstadoAsignacionEjecucion? estado,
    double? latitud,
    double? longitud,
    double? precisionMetros,
    DateTime? coordenadasCapturadasEn,
    String? observaciones,
    double? valorNumerico,
    String? rutaAudio,
    String? transcripcionAudio,
    List<EvidenciaRegistroFeature>? evidencias,
    DateTime? completadoEn,
  }) {
    return RegistroFeatureEjecucion(
      featureId: featureId,
      featureNombre: featureNombre,
      estado: estado ?? this.estado,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      precisionMetros: precisionMetros ?? this.precisionMetros,
      coordenadasCapturadasEn:
          coordenadasCapturadasEn ?? this.coordenadasCapturadasEn,
      observaciones: observaciones ?? this.observaciones,
      valorNumerico: valorNumerico ?? this.valorNumerico,
      rutaAudio: rutaAudio ?? this.rutaAudio,
      transcripcionAudio: transcripcionAudio ?? this.transcripcionAudio,
      evidencias: evidencias ?? this.evidencias,
      completadoEn: completadoEn ?? this.completadoEn,
    );
  }

  Map<String, dynamic> toJson() => {
        'featureId': featureId,
        'featureNombre': featureNombre,
        'estado': estado.name,
        if (latitud != null) 'latitud': latitud,
        if (longitud != null) 'longitud': longitud,
        if (precisionMetros != null) 'precisionMetros': precisionMetros,
        if (coordenadasCapturadasEn != null)
          'coordenadasCapturadasEn': coordenadasCapturadasEn!.toIso8601String(),
        if (observaciones != null) 'observaciones': observaciones,
        if (valorNumerico != null) 'valorNumerico': valorNumerico,
        if (rutaAudio != null) 'rutaAudio': rutaAudio,
        if (transcripcionAudio != null)
          'transcripcionAudio': transcripcionAudio,
        'evidencias': evidencias.map((e) => e.toJson()).toList(),
        if (completadoEn != null)
          'completadoEn': completadoEn!.toIso8601String(),
      };

  factory RegistroFeatureEjecucion.fromJson(Map<String, dynamic> json) {
    return RegistroFeatureEjecucion(
      featureId: json['featureId'] as String? ?? '',
      featureNombre: json['featureNombre'] as String? ?? '',
      estado: EstadoAsignacionEjecucion.values.firstWhere(
        (e) => e.name == json['estado'],
        orElse: () => EstadoAsignacionEjecucion.pendiente,
      ),
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      precisionMetros: (json['precisionMetros'] as num?)?.toDouble(),
      coordenadasCapturadasEn: json['coordenadasCapturadasEn'] != null
          ? DateTime.tryParse(json['coordenadasCapturadasEn'] as String)
          : null,
      observaciones: json['observaciones'] as String?,
      valorNumerico: (json['valorNumerico'] as num?)?.toDouble(),
      rutaAudio: json['rutaAudio'] as String?,
      transcripcionAudio: json['transcripcionAudio'] as String?,
      evidencias: (json['evidencias'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                EvidenciaRegistroFeature.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      completadoEn: json['completadoEn'] != null
          ? DateTime.tryParse(json['completadoEn'] as String)
          : null,
    );
  }
}

class AsignacionEjecucionSalida {
  final String asignacionId;
  /// Estado guardado directamente en la asignación completa. Es la fuente
  /// de verdad únicamente cuando la asignación no tiene [registrosFeatures]
  /// (dato de una versión anterior al registro granular por feature); en
  /// cualquier otro caso el estado real se calcula a partir de esos
  /// registros, ver [estado].
  final EstadoAsignacionEjecucion estadoLegacy;
  final double? latitud;
  final double? longitud;
  final double? precisionMetros;
  final DateTime? coordenadasCapturadasEn;
  final String? observaciones;
  final String? rutaAudio;
  /// Registro individual de cada feature/sub-área de la plantilla asignada.
  /// Fuente de verdad del progreso de la tarea desde el registro granular
  /// por feature.
  final List<RegistroFeatureEjecucion> registrosFeatures;

  const AsignacionEjecucionSalida({
    required this.asignacionId,
    this.estadoLegacy = EstadoAsignacionEjecucion.pendiente,
    this.latitud,
    this.longitud,
    this.precisionMetros,
    this.coordenadasCapturadasEn,
    this.observaciones,
    this.rutaAudio,
    this.registrosFeatures = const [],
  });

  /// Estado agregado de la tarea completa: completada solo si **todos** sus
  /// features están completados; en curso si al menos uno tiene avance;
  /// pendiente en otro caso. Si la asignación no tiene features registrados
  /// (dato legacy anterior a este modelo) se usa [estadoLegacy].
  EstadoAsignacionEjecucion get estado {
    if (registrosFeatures.isEmpty) return estadoLegacy;
    final estados = registrosFeatures.map((r) => r.estado);
    if (estados.every((e) => e == EstadoAsignacionEjecucion.completada)) {
      return EstadoAsignacionEjecucion.completada;
    }
    if (estados.any(
      (e) =>
          e == EstadoAsignacionEjecucion.completada ||
          e == EstadoAsignacionEjecucion.enCurso,
    )) {
      return EstadoAsignacionEjecucion.enCurso;
    }
    return EstadoAsignacionEjecucion.pendiente;
  }

  bool get tieneCoordenadas => latitud != null && longitud != null;

  String? get coordenadasTexto {
    if (!tieneCoordenadas) return null;
    return '${latitud!.toStringAsFixed(6)}, ${longitud!.toStringAsFixed(6)}';
  }

  RegistroFeatureEjecucion? registroDeFeature(String featureId) {
    final match = registrosFeatures.where((r) => r.featureId == featureId);
    return match.isEmpty ? null : match.first;
  }

  Map<String, dynamic> toJson() => {
        'asignacionId': asignacionId,
        'estado': estadoLegacy.name,
        if (latitud != null) 'latitud': latitud,
        if (longitud != null) 'longitud': longitud,
        if (precisionMetros != null) 'precisionMetros': precisionMetros,
        if (coordenadasCapturadasEn != null)
          'coordenadasCapturadasEn': coordenadasCapturadasEn!.toIso8601String(),
        if (observaciones != null) 'observaciones': observaciones,
        if (rutaAudio != null) 'rutaAudio': rutaAudio,
        'registrosFeatures':
            registrosFeatures.map((r) => r.toJson()).toList(),
      };

  factory AsignacionEjecucionSalida.fromJson(Map<String, dynamic> json) {
    return AsignacionEjecucionSalida(
      asignacionId: json['asignacionId'] as String,
      estadoLegacy: EstadoAsignacionEjecucion.values.firstWhere(
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
      registrosFeatures: (json['registrosFeatures'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                RegistroFeatureEjecucion.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
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
    List<RegistroFeatureEjecucion>? registrosFeatures,
  }) {
    return AsignacionEjecucionSalida(
      asignacionId: asignacionId,
      estadoLegacy: estado ?? estadoLegacy,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      precisionMetros: precisionMetros ?? this.precisionMetros,
      coordenadasCapturadasEn:
          coordenadasCapturadasEn ?? this.coordenadasCapturadasEn,
      observaciones: observaciones ?? this.observaciones,
      rutaAudio: rutaAudio ?? this.rutaAudio,
      registrosFeatures: registrosFeatures ?? this.registrosFeatures,
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

/// Observación en un checklist individual, con autor identificado.
class ObservacionChecklistPersona {
  final String texto;
  final String autorNombre;
  final String autorUserId;
  final String autorRol;

  /// `dueno` = titular del checklist (operador); `supervisor` = jefe de
  /// cuadrilla revisando el checklist de otro.
  final String tipo;
  final DateTime actualizadoEn;

  const ObservacionChecklistPersona({
    required this.texto,
    required this.autorNombre,
    this.autorUserId = '',
    this.autorRol = '',
    required this.tipo,
    required this.actualizadoEn,
  });

  String get etiquetaTipo {
    switch (tipo) {
      case 'dueno':
        return 'Operador';
      case 'supervisor':
        return 'Jefe de cuadrilla';
      default:
        return autorRol.isNotEmpty ? autorRol : 'Observación';
    }
  }

  String get etiquetaAutor => '$etiquetaTipo · $autorNombre';

  Map<String, dynamic> toJson() => {
        'texto': texto,
        'autorNombre': autorNombre,
        'autorUserId': autorUserId,
        'autorRol': autorRol,
        'tipo': tipo,
        'actualizadoEn': actualizadoEn.toIso8601String(),
      };

  factory ObservacionChecklistPersona.fromJson(Map<String, dynamic> json) {
    return ObservacionChecklistPersona(
      texto: json['texto'] as String? ?? '',
      autorNombre: json['autorNombre'] as String? ?? '',
      autorUserId: json['autorUserId'] as String? ?? '',
      autorRol: json['autorRol'] as String? ?? '',
      tipo: json['tipo'] as String? ?? 'dueno',
      actualizadoEn: json['actualizadoEn'] != null
          ? DateTime.tryParse(json['actualizadoEn'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  bool coincideAutor({
    required String userId,
    required String nombre,
    required String tipoObs,
  }) {
    if (tipo != tipoObs) return false;
    if (userId.isNotEmpty) return autorUserId == userId;
    return autorNombre.toLowerCase().trim() == nombre.toLowerCase().trim();
  }
}

/// Checklist de salida ejecutado de forma individual por una persona del
/// equipo (operador o líder de cuadrilla) para un día concreto de la salida.
/// Una salida de varios días tiene un [ChecklistPersonaEjecucion] distinto
/// por cada combinación (persona, día). Solo el líder de cuadrilla puede
/// marcar ítems, adjuntar evidencia y cerrar el checklist de cualquier
/// persona (incluido el suyo) en cada día. El dueño del checklist y el jefe
/// de cuadrilla pueden dejar observaciones diferenciadas en [observaciones].
class ChecklistPersonaEjecucion {
  /// Clave estable de la persona dentro de la salida: el `userId` de Cognito
  /// si está disponible, o un identificador derivado del nombre si no.
  final String personaId;
  final String nombre;
  final String rol;
  /// Día calendario (sin componente de hora) al que corresponde este
  /// checklist dentro del rango de la salida.
  final DateTime fecha;
  final List<ChecklistItemEjecucionSalida> items;
  final List<EvidenciaChecklistSalida> evidencias;
  final bool completado;
  final String? completadoPorNombre;
  final String? completadoPorUserId;
  final DateTime? completadoEn;
  final List<ObservacionChecklistPersona> observaciones;

  const ChecklistPersonaEjecucion({
    required this.personaId,
    required this.nombre,
    required this.rol,
    required this.fecha,
    this.items = const [],
    this.evidencias = const [],
    this.completado = false,
    this.completadoPorNombre,
    this.completadoPorUserId,
    this.completadoEn,
    this.observaciones = const [],
  });

  /// Texto de la observación del titular del checklist (compatibilidad).
  String get observacion {
    for (final o in observaciones) {
      if (o.tipo == 'dueno') return o.texto;
    }
    return '';
  }

  DateTime? get observacionActualizadaEn {
    for (final o in observaciones) {
      if (o.tipo == 'dueno') return o.actualizadoEn;
    }
    return null;
  }

  ObservacionChecklistPersona? observacionDeAutor({
    required String autorUserId,
    required String autorNombre,
    required String tipo,
  }) {
    for (final o in observaciones) {
      if (o.coincideAutor(
        userId: autorUserId,
        nombre: autorNombre,
        tipoObs: tipo,
      )) {
        return o;
      }
    }
    return null;
  }

  ChecklistPersonaEjecucion conObservacionUpsert(
    ObservacionChecklistPersona nueva,
  ) {
    final lista = List<ObservacionChecklistPersona>.from(observaciones);
    final idx = lista.indexWhere(
      (o) => o.coincideAutor(
        userId: nueva.autorUserId,
        nombre: nueva.autorNombre,
        tipoObs: nueva.tipo,
      ),
    );
    if (nueva.texto.trim().isEmpty) {
      if (idx >= 0) lista.removeAt(idx);
    } else if (idx >= 0) {
      lista[idx] = nueva;
    } else {
      lista.add(nueva);
    }
    return copyWith(observaciones: lista);
  }

  static List<ObservacionChecklistPersona> _parseObservaciones(
    Map<String, dynamic> json,
  ) {
    if (json['observaciones'] != null) {
      return (json['observaciones'] as List<dynamic>)
          .map(
            (e) => ObservacionChecklistPersona.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }
    final legado = json['observacion'] as String? ?? '';
    if (legado.trim().isEmpty) return const [];
    return [
      ObservacionChecklistPersona(
        texto: legado,
        autorNombre: json['nombre'] as String? ?? '',
        autorUserId: '',
        autorRol: json['rol'] as String? ?? '',
        tipo: 'dueno',
        actualizadoEn: json['observacionActualizadaEn'] != null
            ? DateTime.tryParse(json['observacionActualizadaEn'] as String) ??
                DateTime.now()
            : DateTime.now(),
      ),
    ];
  }

  ChecklistPersonaEjecucion copyWith({
    List<ChecklistItemEjecucionSalida>? items,
    List<EvidenciaChecklistSalida>? evidencias,
    bool? completado,
    String? completadoPorNombre,
    String? completadoPorUserId,
    DateTime? completadoEn,
    List<ObservacionChecklistPersona>? observaciones,
  }) {
    return ChecklistPersonaEjecucion(
      personaId: personaId,
      nombre: nombre,
      rol: rol,
      fecha: fecha,
      items: items ?? this.items,
      evidencias: evidencias ?? this.evidencias,
      completado: completado ?? this.completado,
      completadoPorNombre: completadoPorNombre ?? this.completadoPorNombre,
      completadoPorUserId: completadoPorUserId ?? this.completadoPorUserId,
      completadoEn: completadoEn ?? this.completadoEn,
      observaciones: observaciones ?? this.observaciones,
    );
  }

  Map<String, dynamic> toJson() => {
        'personaId': personaId,
        'nombre': nombre,
        'rol': rol,
        'fecha': fecha.toIso8601String(),
        'items': items.map((i) => i.toJson()).toList(),
        'evidencias': evidencias.map((e) => e.toJson()).toList(),
        'completado': completado,
        if (completadoPorNombre != null)
          'completadoPorNombre': completadoPorNombre,
        if (completadoPorUserId != null)
          'completadoPorUserId': completadoPorUserId,
        if (completadoEn != null)
          'completadoEn': completadoEn!.toIso8601String(),
        'observaciones': observaciones.map((o) => o.toJson()).toList(),
        'observacion': observacion,
        if (observacionActualizadaEn != null)
          'observacionActualizadaEn':
              observacionActualizadaEn!.toIso8601String(),
      };

  factory ChecklistPersonaEjecucion.fromJson(Map<String, dynamic> json) {
    final fechaJson = json['fecha'] != null
        ? DateTime.tryParse(json['fecha'] as String)
        : null;
    // Registros creados antes de que el checklist fuera diario no tienen
    // fecha propia: se anclan al día en que se cerraron (o a hoy, si nunca
    // se cerraron), para no perder el dato ya guardado en el dispositivo.
    final completadoEn = json['completadoEn'] != null
        ? DateTime.tryParse(json['completadoEn'] as String)
        : null;
    final fecha = fechaJson ?? completadoEn ?? DateTime.now();

    return ChecklistPersonaEjecucion(
      personaId: json['personaId'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      rol: json['rol'] as String? ?? '',
      fecha: DateTime(fecha.year, fecha.month, fecha.day),
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (e) => ChecklistItemEjecucionSalida.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      evidencias: (json['evidencias'] as List<dynamic>? ?? [])
          .map(
            (e) => EvidenciaChecklistSalida.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      completado: json['completado'] as bool? ?? false,
      completadoPorNombre: json['completadoPorNombre'] as String?,
      completadoPorUserId: json['completadoPorUserId'] as String?,
      completadoEn: completadoEn,
      observaciones: _parseObservaciones(json),
    );
  }
}

class EjecucionSalida {
  final String salidaId;
  final List<AsignacionEjecucionSalida> asignaciones;
  final List<ChecklistPersonaEjecucion> checklistsPersonales;
  final ChequeoVehiculoSalida? chequeoVehiculo;
  final DateTime actualizadoEn;

  const EjecucionSalida({
    required this.salidaId,
    this.asignaciones = const [],
    this.checklistsPersonales = const [],
    this.chequeoVehiculo,
    required this.actualizadoEn,
  });

  EjecucionSalida copyWith({
    List<AsignacionEjecucionSalida>? asignaciones,
    List<ChecklistPersonaEjecucion>? checklistsPersonales,
    ChequeoVehiculoSalida? chequeoVehiculo,
    DateTime? actualizadoEn,
    bool quitarChequeoVehiculo = false,
  }) {
    return EjecucionSalida(
      salidaId: salidaId,
      asignaciones: asignaciones ?? this.asignaciones,
      checklistsPersonales: checklistsPersonales ?? this.checklistsPersonales,
      chequeoVehiculo: quitarChequeoVehiculo
          ? null
          : (chequeoVehiculo ?? this.chequeoVehiculo),
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  Map<String, dynamic> toJson() => {
        'salidaId': salidaId,
        'asignaciones': asignaciones.map((a) => a.toJson()).toList(),
        'checklistsPersonales':
            checklistsPersonales.map((c) => c.toJson()).toList(),
        if (chequeoVehiculo != null) 'chequeoVehiculo': chequeoVehiculo!.toJson(),
        'actualizadoEn': actualizadoEn.toIso8601String(),
      };

  /// Reconstruye el checklist único legacy (previo al checklist por persona)
  /// como una única entrada, para no perder datos ya guardados en el
  /// dispositivo. Se asume que ese checklist único pertenecía al líder de
  /// cuadrilla que lo cerró.
  static List<ChecklistPersonaEjecucion> _migrarChecklistLegacy(
    Map<String, dynamic> json,
  ) {
    final items = (json['checklistItems'] as List<dynamic>? ?? [])
        .map(
          (e) => ChecklistItemEjecucionSalida.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    final evidencias = (json['checklistEvidencias'] as List<dynamic>? ?? [])
        .map(
          (e) => EvidenciaChecklistSalida.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    final completado = json['checklistCompletado'] as bool? ?? false;
    final observaciones = json['checklistObservaciones'] as String? ?? '';

    if (items.isEmpty && evidencias.isEmpty && !completado && observaciones.isEmpty) {
      return const [];
    }

    final completadoPorUserId = json['checklistCompletadoPorUserId'] as String?;
    final completadoPorNombre =
        json['checklistCompletadoPorNombre'] as String? ?? 'Líder de cuadrilla';
    final completadoEn = json['checklistCompletadoEn'] != null
        ? DateTime.tryParse(json['checklistCompletadoEn'] as String)
        : null;
    final fecha = completadoEn ?? DateTime.now();

    return [
      ChecklistPersonaEjecucion(
        personaId: (completadoPorUserId != null && completadoPorUserId.isNotEmpty)
            ? completadoPorUserId
            : 'legacy',
        nombre: completadoPorNombre,
        rol: 'lider_cuadrilla',
        fecha: DateTime(fecha.year, fecha.month, fecha.day),
        items: items,
        evidencias: evidencias,
        completado: completado,
        completadoPorNombre: completado ? completadoPorNombre : null,
        completadoPorUserId: completado ? completadoPorUserId : null,
        completadoEn: completadoEn,
        observaciones: observaciones.trim().isEmpty
            ? const []
            : [
                ObservacionChecklistPersona(
                  texto: observaciones,
                  autorNombre: completadoPorNombre,
                  autorUserId: completadoPorUserId ?? '',
                  autorRol: 'lider_cuadrilla',
                  tipo: 'dueno',
                  actualizadoEn: fecha,
                ),
              ],
      ),
    ];
  }

  factory EjecucionSalida.fromJson(Map<String, dynamic> json) {
    final checklistsPersonales = json['checklistsPersonales'] != null
        ? (json['checklistsPersonales'] as List<dynamic>)
            .map(
              (e) => ChecklistPersonaEjecucion.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList()
        : _migrarChecklistLegacy(json);

    return EjecucionSalida(
      salidaId: json['salidaId'] as String,
      asignaciones: (json['asignaciones'] as List<dynamic>? ?? [])
          .map(
            (e) => AsignacionEjecucionSalida.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      checklistsPersonales: checklistsPersonales,
      chequeoVehiculo: json['chequeoVehiculo'] != null
          ? ChequeoVehiculoSalida.fromJson(
              json['chequeoVehiculo'] as Map<String, dynamic>,
            )
          : null,
      actualizadoEn: DateTime.parse(json['actualizadoEn'] as String),
    );
  }
}
