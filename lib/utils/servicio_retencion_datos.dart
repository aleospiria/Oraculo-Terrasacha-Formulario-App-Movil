import 'package:amplify_flutter/amplify_flutter.dart';

import 'servicio_configuracion_retencion.dart';
import 'servicio_salida.dart';

/// Orquestador de ciclo de vida para los datos de campo almacenados localmente.
///
/// Se debe invocar una sola vez durante el arranque de la app, después de que
/// Amplify y SharedPreferences estén inicializados.
///
/// Reglas de retención:
///   - Dato sincronizado con la nube → se elimina del dispositivo al cumplir 30 días.
///   - Dato NO sincronizado           → se marca [caducada] al cumplir 30 días;
///                                      se elimina definitivamente a los 37 días (7 de gracia).
///   - Dato NO sincronizado próximo   → se emite aviso si quedan ≤ 5 días para expirar.
class ServicioRetencionDatos {
  ServicioRetencionDatos._();

  static bool _ejecutado = false;

  /// Ejecuta la purga una sola vez por sesión de app.
  /// Llama esto desde [main.dart] justo después de `await Amplify.configure(...)`.
  static Future<ResultadoPurga?> ejecutarAlArrancar() async {
    if (_ejecutado) return null;
    _ejecutado = true;

    try {
      // Cargar el tiempo de caducidad configurado antes de purgar, para que la
      // expiración y la purga usen el valor elegido por el usuario.
      await ServicioConfiguracionRetencion.cargar();

      final resultado = await ServicioSalida.purgarExpiradas();
      if (resultado.hayActividad) {
        safePrint('[Retención] $resultado');
      }
      return resultado;
    } catch (e) {
      safePrint('[Retención] Error durante purga: $e');
      return null;
    }
  }

  /// Reinicia el flag para que la purga pueda ejecutarse en pruebas.
  static void resetearParaTest() => _ejecutado = false;
}
