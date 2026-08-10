/// Utilidades compartidas para roles de campo (Cognito y etiquetas UI).
class RolesCampo {
  RolesCampo._();

  static bool esOperador(String rol) => rol.toLowerCase().trim() == 'operador';

  static bool esLiderCuadrilla(String rol) {
    final n = rol.toLowerCase().trim().replaceAll('_', ' ');
    return n == 'lider cuadrilla' ||
        n == 'jefe cuadrilla' ||
        n == 'jefe' ||
        n == 'jefe de cuadrilla' ||
        n == 'supervisor' ||
        n.contains('cuadrilla');
  }

  static bool esLiderProyecto(String rol) =>
      rol.toLowerCase().trim() == 'lider_proyecto';

  /// Quién puede recibir una plantilla asignada.
  static bool puedeRecibirPlantilla(String rol) =>
      esOperador(rol) || esLiderCuadrilla(rol);

  /// Operador y jefe de cuadrilla capturan GPS al registrar mediciones en campo.
  static bool capturaCoordenadasEnRegistro(String? rol) {
    if (rol == null || rol.trim().isEmpty) return false;
    return esOperador(rol) || esLiderCuadrilla(rol);
  }

  /// Roles de campo que pueden crear reportes de incidencias/accidentes.
  static bool puedeReportarIncidencias(String? rol) {
    if (rol == null || rol.trim().isEmpty) return false;
    return esOperador(rol) || esLiderCuadrilla(rol) || esLiderProyecto(rol);
  }

  /// Roles que pueden crear/editar plantillas y sus features.
  static bool puedeGestionarPlantillas(String? rol) {
    if (rol == null || rol.trim().isEmpty) return false;
    return esLiderProyecto(rol) || esLiderCuadrilla(rol);
  }

  static String etiquetaDesdeCognito(String? rolCognito) {
    switch (rolCognito?.toLowerCase().trim()) {
      case 'lider_cuadrilla':
      case 'jefe_cuadrilla':
        return 'Jefe de cuadrilla';
      case 'operador':
        return 'Operador';
      case 'lider_proyecto':
        return 'Líder de proyecto';
      default:
        if (rolCognito != null && esLiderCuadrilla(rolCognito)) {
          return 'Jefe de cuadrilla';
        }
        if (rolCognito != null && esOperador(rolCognito)) {
          return 'Operador';
        }
        return rolCognito ?? 'Usuario';
    }
  }

  /// Slug Cognito desde etiqueta UI del plan.
  static String cognitoDesdeEtiqueta(String rol) {
    if (esLiderCuadrilla(rol)) return 'lider_cuadrilla';
    return 'operador';
  }

  /// Opciones de rol al armar el equipo del plan de campo.
  static const List<String> rolesEquipoPlan = [
    'Operador',
    'Jefe de cuadrilla',
  ];

  /// Etiqueta UI para dropdowns de rol en creación de plan.
  /// Siempre devuelve un valor de [rolesEquipoPlan].
  static String etiquetaParaDropdown(String rol) {
    if (esLiderCuadrilla(rol)) return 'Jefe de cuadrilla';
    if (esOperador(rol)) return 'Operador';
    // Cualquier otro rol de campo se trata como operador en el plan.
    return 'Operador';
  }

  static bool _esSlugRol(String value) {
    final n = value.toLowerCase().trim().replaceAll(' ', '_');
    return n == 'lider_cuadrilla' ||
        n == 'jefe_cuadrilla' ||
        n == 'lider_proyecto' ||
        n == 'operador';
  }

  /// Detecta nombres placeholder guardados como rol (ej. "jefe cuadrilla", "operador").
  static bool esNombrePlaceholder(String nombre, {String? rolCognito}) {
    final n = nombre.toLowerCase().trim();
    if (n.isEmpty) return true;
    if (_esSlugRol(n)) return true;
    if (n == 'jefe cuadrilla' || n == 'lider cuadrilla') return true;
    if (n == 'operador') return true;
    if (esLiderCuadrilla(n) || esOperador(n)) return true;
    if (rolCognito != null &&
        n == rolCognito.toLowerCase().trim().replaceAll('_', ' ')) {
      return true;
    }
    return false;
  }

  /// Evita usar el slug de Cognito o placeholders de rol como nombre visible.
  static String normalizarNombre(String nombre, {String? rolCognito}) {
    final limpio = nombre.trim();
    if (limpio.isEmpty || esNombrePlaceholder(limpio, rolCognito: rolCognito)) {
      if (rolCognito != null && rolCognito.isNotEmpty) {
        return etiquetaDesdeCognito(rolCognito);
      }
      if (esLiderCuadrilla(limpio)) return 'Jefe de cuadrilla';
      if (esOperador(limpio)) return 'Operador';
      return 'Usuario de campo';
    }
    return limpio;
  }
}
