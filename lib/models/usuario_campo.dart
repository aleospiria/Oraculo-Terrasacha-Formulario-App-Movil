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
  final String? ubicacionRuta;
  final EstadoTareaSalida estado;

  const TareaSalidaVista({
    required this.asignacionId,
    required this.salidaId,
    required this.salidaNombre,
    required this.templateNombre,
    required this.featureNombres,
    this.ubicacionRuta,
    required this.estado,
  });
}

enum EstadoTareaSalida { pendiente, enCurso, completada }
