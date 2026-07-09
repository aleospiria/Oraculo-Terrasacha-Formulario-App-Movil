import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lista_chequeo.dart';

class ServicioListaChequeo {
  static const _prefsKey = 'listas_chequeo_catalogo_v1';

  /// IDs de plantillas de demostración que ya no deben mostrarse.
  static const _idsPlantillasSimuladas = {
    'admin-mantenimiento-v4',
    'admin-protocolo-v2',
    'admin-fitosanitaria-v1',
  };

  static Future<String?> _emailUsuarioActual() async {
    try {
      final atributos = await Amplify.Auth.fetchUserAttributes();
      for (final a in atributos) {
        if (a.userAttributeKey.key == 'email' && a.value.isNotEmpty) {
          return a.value;
        }
      }
      final user = await Amplify.Auth.getCurrentUser();
      return user.username;
    } catch (e) {
      safePrint('ServicioListaChequeo: sin usuario $e');
      return null;
    }
  }

  static Future<List<ListaChequeo>> _leerTodas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final listas = raw
        .map((s) => ListaChequeo.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();

    final sinSimuladas =
        listas.where((l) => !_idsPlantillasSimuladas.contains(l.id)).toList();

    if (sinSimuladas.length != listas.length) {
      await _guardarTodas(sinSimuladas);
    }

    return sinSimuladas;
  }

  static Future<void> _guardarTodas(List<ListaChequeo> listas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      listas.map((l) => jsonEncode(l.toJson())).toList(),
    );
  }

  /// Listas del administrador + las personalizadas del líder actual.
  static Future<List<ListaChequeo>> cargarDisponibles() async {
    final email = await _emailUsuarioActual();
    final todas = await _leerTodas();

    return todas
        .where(
          (l) =>
              l.esDelAdministrador ||
              (email != null && l.creadoPorEmail == email),
        )
        .toList()
      ..sort((a, b) {
        if (a.esDelAdministrador != b.esDelAdministrador) {
          return a.esDelAdministrador ? -1 : 1;
        }
        return a.nombre.compareTo(b.nombre);
      });
  }

  static Future<ListaChequeo> crear({
    required String nombre,
    String? descripcion,
    required List<ItemListaChequeo> items,
  }) async {
    final email = await _emailUsuarioActual();
    final ahora = DateTime.now();
    final lista = ListaChequeo(
      id: 'lider-${ahora.microsecondsSinceEpoch}',
      nombre: nombre.trim(),
      descripcion: descripcion?.trim(),
      items: items,
      origen: OrigenListaChequeo.liderProyecto,
      creadoPorEmail: email,
      creadoEn: ahora,
      actualizadoEn: ahora,
    );

    final todas = await _leerTodas();
    todas.add(lista);
    await _guardarTodas(todas);
    return lista;
  }

  static Future<ListaChequeo> actualizar(ListaChequeo lista) async {
    final email = await _emailUsuarioActual();
    if (!lista.puedeEditarPor(email)) {
      throw StateError('No puedes editar esta lista de chequeo');
    }

    final todas = await _leerTodas();
    final index = todas.indexWhere((l) => l.id == lista.id);
    if (index < 0) {
      throw StateError('Lista no encontrada');
    }

    final actualizada = lista.copyWith(actualizadoEn: DateTime.now());
    todas[index] = actualizada;
    await _guardarTodas(todas);
    return actualizada;
  }

  static Future<void> eliminar(String listaId) async {
    final email = await _emailUsuarioActual();
    final todas = await _leerTodas();
    ListaChequeo? lista;
    for (final l in todas) {
      if (l.id == listaId) {
        lista = l;
        break;
      }
    }

    if (lista == null) return;
    if (!lista.puedeEditarPor(email)) {
      throw StateError('No puedes eliminar esta lista de chequeo');
    }

    todas.removeWhere((l) => l.id == listaId);
    await _guardarTodas(todas);
  }
}
