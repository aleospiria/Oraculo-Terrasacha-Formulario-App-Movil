import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/plan_campo_borrador.dart';

/// Gestiona el tiempo de caducidad (retención) de los datos en el dispositivo.
///
/// El valor es global para todo el dispositivo y se persiste en
/// [SharedPreferences]. Al arrancar la app se debe llamar a [cargar] para
/// hidratar [SalidaCampo.diasRetencionDispositivo] antes de purgar datos.
class ServicioConfiguracionRetencion {
  ServicioConfiguracionRetencion._();

  static const String _key = 'retencion_dias_v1';

  /// Rango permitido para el valor configurable (en días).
  static const int minDias = 1;
  static const int maxDias = 365;

  /// Valor por defecto (coincide con el del modelo).
  static const int diasPorDefecto = SalidaCampo.diasRetencionPorDefecto;

  /// Opciones sugeridas en la interfaz.
  static const List<int> presets = [7, 15, 30, 60, 90];

  /// Días de retención actualmente activos en memoria.
  static int get diasActuales => SalidaCampo.diasRetencionDispositivo;

  /// Restringe [dias] al rango permitido.
  static int _sanear(int dias) => dias.clamp(minDias, maxDias);

  /// Carga el valor persistido y lo aplica al modelo. Devuelve los días activos.
  static Future<int> cargar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final guardado = prefs.getInt(_key);
      final dias = guardado != null ? _sanear(guardado) : diasPorDefecto;
      SalidaCampo.diasRetencionDispositivo = dias;
      return dias;
    } catch (e) {
      safePrint('[Retención] Error cargando configuración: $e');
      SalidaCampo.diasRetencionDispositivo = diasPorDefecto;
      return diasPorDefecto;
    }
  }

  /// Persiste un nuevo valor (saneado) y lo aplica al modelo en memoria.
  static Future<int> guardar(int dias) async {
    final saneado = _sanear(dias);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, saneado);
    SalidaCampo.diasRetencionDispositivo = saneado;
    return saneado;
  }

  /// Restablece el valor por defecto.
  static Future<int> restablecer() => guardar(diasPorDefecto);
}
