import 'plan_campo_borrador.dart';
import '../utils/roles_campo.dart';

/// Usuario de campo para asignación de plantillas (Cognito / tabla User).
class UsuarioCampo {
  final String id;
  final String nombre;
  final String rolCognito;
  final String rolDisplay;

  const UsuarioCampo({
    required this.id,
    required this.nombre,
    required this.rolCognito,
    required this.rolDisplay,
  });

  factory UsuarioCampo.fromApi(Map<String, dynamic> json) {
    final rol = json['rol'] as String? ?? '';
    final nombreRaw = json['nombre'] as String? ?? 'Sin nombre';
    return UsuarioCampo(
      id: json['id'] as String? ?? '',
      nombre: RolesCampo.normalizarNombre(nombreRaw, rolCognito: rol),
      rolCognito: rol,
      rolDisplay: RolesCampo.etiquetaDesdeCognito(rol),
    );
  }

  factory UsuarioCampo.desdeEquipo({
    required String nombre,
    required String rol,
    String id = '',
  }) {
    final cognito = esLiderCuadrillaRol(rol) ? 'lider_cuadrilla' : 'operador';
    return UsuarioCampo(
      id: id,
      nombre: RolesCampo.normalizarNombre(nombre, rolCognito: cognito),
      rolCognito: cognito,
      rolDisplay: RolesCampo.etiquetaDesdeCognito(cognito),
    );
  }

  static bool esLiderCuadrillaRol(String rol) => RolesCampo.esLiderCuadrilla(rol);

  /// Tupla para [AsignacionPlantillaSheet].
  ({String nombre, String rol, String? userId}) get paraSheet => (
        nombre: nombre,
        rol: rolDisplay,
        userId: id.isNotEmpty ? id : null,
      );
}

/// Vista de tarea derivada de una asignación de plantilla en una salida.
class TareaSalidaVista {
  final String asignacionId;
  final String salidaId;
  final String salidaNombre;
  final String templateNombre;
  final List<String> featureNombres;
  /// Estado individual de cada feature/sub-área de la plantilla asignada,
  /// para que el operador pueda completarlas una por una.
  final List<FeatureTareaVista> features;
  final String? ubicacionRuta;
  final EstadoTareaSalida estado;
  /// Día de campo al que pertenece la asignación (`fechaSubArea`).
  final DateTime? fechaAsignacion;

  const TareaSalidaVista({
    required this.asignacionId,
    required this.salidaId,
    required this.salidaNombre,
    required this.templateNombre,
    required this.featureNombres,
    this.features = const [],
    this.ubicacionRuta,
    required this.estado,
    this.fechaAsignacion,
  });
}

enum EstadoTareaSalida { pendiente, enCurso, completada }

/// Tarea de un operador vista por el jefe de cuadrilla en sus salidas.
class TareaEquipoVista {
  final String asignacionId;
  final String salidaId;
  final String salidaNombre;
  final String templateNombre;
  final String operadorNombre;
  final String? ubicacionRuta;
  final EstadoTareaSalida estado;
  final List<FeatureTareaVista> features;

  const TareaEquipoVista({
    required this.asignacionId,
    required this.salidaId,
    required this.salidaNombre,
    required this.templateNombre,
    required this.operadorNombre,
    this.ubicacionRuta,
    required this.estado,
    this.features = const [],
  });

  /// Todas las features completadas pero la asignación sigue en curso.
  bool get pendienteValidacion =>
      estado == EstadoTareaSalida.enCurso &&
      features.isNotEmpty &&
      features.every((f) => f.estado == EstadoTareaSalida.completada);

  String get ubicacionDisplay {
    final ruta = ubicacionRuta?.trim();
    if (ruta != null && ruta.isNotEmpty) return ruta;
    return salidaNombre;
  }

  int get progresoPorcentaje {
    if (features.isEmpty) {
      return switch (estado) {
        EstadoTareaSalida.completada => 100,
        EstadoTareaSalida.enCurso => 50,
        EstadoTareaSalida.pendiente => 0,
      };
    }
    final hechas =
        features.where((f) => f.estado == EstadoTareaSalida.completada).length;
    return ((hechas / features.length) * 100).round();
  }
}

/// Estado individual de una feature/sub-área dentro de una [TareaSalidaVista].
class FeatureTareaVista {
  final String featureId;
  final String featureNombre;
  final EstadoTareaSalida estado;

  const FeatureTareaVista({
    required this.featureId,
    required this.featureNombre,
    required this.estado,
  });
}

/// Vista del checklist individual de una persona (operador o líder de
/// cuadrilla) dentro de una salida, para listarlo en su propia pantalla.
class ChecklistSalidaVista {
  final String salidaId;
  final String salidaNombre;
  final ChecklistPlanAsignado checklist;
  final String personaId;
  final String personaNombre;
  final String personaRol;
  /// Día calendario al que corresponde este checklist (siempre hoy, ya que
  /// [listarChecklistsParaUsuario] solo expone el checklist del día actual).
  final DateTime fecha;
  final int itemsCompletados;
  final bool completado;
  final String observacion;
  final List<ObservacionChecklistPersona> observaciones;

  const ChecklistSalidaVista({
    required this.salidaId,
    required this.salidaNombre,
    required this.checklist,
    required this.personaId,
    required this.personaNombre,
    required this.personaRol,
    required this.fecha,
    required this.itemsCompletados,
    required this.completado,
    this.observacion = '',
    this.observaciones = const [],
  });

  int get itemsTotal => checklist.items.length;
}
