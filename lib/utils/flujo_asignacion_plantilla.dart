import 'package:flutter/material.dart';

import '../config/crear_usuario_lambda_config.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';
import '../widgets/asignacion_plantilla_sheet.dart';
import 'roles_campo.dart';
import 'servicioAutenticacion.dart';
import 'servicio_plantillas.dart';
import 'servicio_salida.dart';
import 'servicio_usuarios_campo.dart';

/// Flujo reutilizable: elegir plantilla y responsable, persistir en salida.
class FlujoAsignacionPlantilla {
  FlujoAsignacionPlantilla._();

  static UsuarioCampo _normalizarUsuario(UsuarioCampo usuario) {
    return UsuarioCampo(
      id: usuario.id,
      nombre: RolesCampo.normalizarNombre(
        usuario.nombre,
        rolCognito: usuario.rolCognito,
      ),
      rolCognito: usuario.rolCognito,
      rolDisplay: RolesCampo.etiquetaDesdeCognito(usuario.rolCognito),
    );
  }

  static String _claveVisualUsuario(UsuarioCampo usuario) {
    return '${usuario.nombre.toLowerCase()}::${usuario.rolCognito.toLowerCase()}';
  }

  static List<UsuarioCampo> _deduplicarResponsables(
    Iterable<UsuarioCampo> usuarios,
  ) {
    final porClaveVisual = <String, UsuarioCampo>{};

    for (final raw in usuarios) {
      final usuario = _normalizarUsuario(raw);
      if (!RolesCampo.puedeRecibirPlantilla(usuario.rolCognito) &&
          !RolesCampo.puedeRecibirPlantilla(usuario.rolDisplay)) {
        continue;
      }

      final clave = _claveVisualUsuario(usuario);
      final existente = porClaveVisual[clave];
      if (existente == null) {
        porClaveVisual[clave] = usuario;
        continue;
      }

      // Preferir el que tiene id de Cognito (usuario real vs placeholder del equipo).
      if (usuario.id.isNotEmpty && existente.id.isEmpty) {
        porClaveVisual[clave] = usuario;
      }
    }

    return porClaveVisual.values.toList();
  }

  /// Responsables de la salida (equipo + usuario actual).
  ///
  /// Por defecto no consulta el catálogo remoto (Lambda): eso bloqueaba el
  /// sheet varios segundos. El equipo de la salida ya tiene quién puede recibir
  /// la plantilla; el catálogo solo enriquece ids Cognito si se pide.
  static Future<List<UsuarioCampo>> responsablesParaSalida(
    SalidaCampo salida, {
    bool enriquecerConCatalogoRemoto = false,
  }) async {
    final candidatos = <UsuarioCampo>[];

    final yo = await servicioAutenticacion.getUsuarioActual();
    if (yo != null) candidatos.add(yo);

    for (final miembro in salida.equipo) {
      candidatos.add(
        UsuarioCampo.desdeEquipo(
          nombre: miembro.nombre,
          rol: miembro.rol,
          id: miembro.userId ?? '',
        ),
      );
    }

    if (enriquecerConCatalogoRemoto && CrearUsuarioLambdaConfig.isConfigured) {
      try {
        final resultado = await ServicioUsuariosCampo.listarUsuarios().timeout(
          const Duration(seconds: 3),
          onTimeout: () => <String, dynamic>{'exito': false},
        );
        if (resultado['exito'] == true) {
          for (final item in resultado['usuarios'] as List<dynamic>? ?? []) {
            if (item is! Map<String, dynamic>) continue;
            final usuario = UsuarioCampo.fromApi(item);
            if (RolesCampo.puedeRecibirPlantilla(usuario.rolCognito)) {
              candidatos.add(usuario);
            }
          }
        }
      } catch (_) {
        // Sin catálogo remoto seguimos con el equipo local.
      }
    }

    return _deduplicarResponsables(candidatos);
  }

  static AsignacionPlantillaPlan asignacionDesdeSheet(
    AsignacionPlantillaSheetDatos datos, {
    String? id,
  }) {
    return AsignacionPlantillaPlan(
      id: id ?? 'asig-${DateTime.now().microsecondsSinceEpoch}',
      templateId: datos.templateId,
      templateNombre: datos.templateNombre,
      featureIds: datos.featureIds,
      featureNombres: datos.featureNombres,
      operadorNombre: RolesCampo.normalizarNombre(datos.operadorNombre),
      operadorRol: RolesCampo.etiquetaParaDropdown(datos.operadorRol),
      responsableUserId: datos.responsableUserId,
      fechaSubArea: datos.fechaSubArea,
    );
  }

  /// Muestra el sheet y persiste en la salida. Retorna la salida actualizada.
  static Future<SalidaCampo?> asignarEnSalida({
    required BuildContext context,
    required Color primaryColor,
    required SalidaCampo salida,
    DateTime? diaInicial,
    EjecucionSalida? ejecucion,
  }) async {
    if (!ServicioSalida.puedeAsignarPlantillas(salida)) {
      throw StateError(
        'No se pueden asignar plantillas en el estado ${salida.estado.etiqueta}',
      );
    }

    final resultados = await Future.wait<Object?>([
      responsablesParaSalida(salida),
      ServicioPlantillas.cargarPlantillasConFeatures(),
      if (ejecucion != null)
        Future<EjecucionSalida>.value(ejecucion)
      else
        ServicioSalida.obtenerEjecucion(salida.id),
    ]);

    final responsables = resultados[0]! as List<UsuarioCampo>;
    final plantillas = resultados[1]! as List<PlantillaConFeatures>;
    final ejecucionResuelta = resultados[2]! as EjecucionSalida;

    if (responsables.isEmpty) {
      throw StateError(
        'No hay responsables disponibles. Agrega operadores al equipo de la salida.',
      );
    }
    if (plantillas.isEmpty) {
      throw StateError('No hay plantillas disponibles');
    }

    final dias = ServicioSalida.diasSalida(salida);
    final requiereDia = dias.length > 1;

    final datos = await AsignacionPlantillaSheet.mostrar(
      context,
      primaryColor: primaryColor,
      plantillas: plantillas,
      responsables: responsables.map((u) => u.paraSheet).toList(),
      diasSalida: dias,
      asignacionesExistentes: salida.asignacionesPlantillas,
      ejecucion: ejecucionResuelta,
      requiereDia: requiereDia,
      diaInicial: diaInicial,
    );

    if (datos == null) return null;

    return ServicioSalida.agregarAsignacionPlantilla(
      salidaId: salida.id,
      asignacion: asignacionDesdeSheet(datos),
    );
  }
}
