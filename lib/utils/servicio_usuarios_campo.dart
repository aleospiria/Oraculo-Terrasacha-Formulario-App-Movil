import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;

import '../config/crear_usuario_lambda_config.dart';

class ServicioUsuariosCampo {
  ServicioUsuariosCampo._();

  static Future<String?> _obtenerIdToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (!session.isSignedIn) return null;

      final cognitoSession = session as CognitoAuthSession;
      final tokens = cognitoSession.userPoolTokensResult.value;
      return tokens.idToken.raw;
    } catch (e) {
      safePrint('Error obteniendo token: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> _post({
    required Map<String, dynamic> body,
  }) async {
    if (!CrearUsuarioLambdaConfig.isConfigured) {
      return {
        'exito': false,
        'error':
            'Configura CrearUsuarioLambdaConfig.functionUrl tras amplify push',
      };
    }

    final token = await _obtenerIdToken();
    if (token == null) {
      return {
        'exito': false,
        'error': 'Debes iniciar sesión para continuar',
      };
    }

    try {
      final response = await http.post(
        Uri.parse(CrearUsuarioLambdaConfig.functionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        return {
          'exito': false,
          'error': decoded['error'] ?? 'Error del servidor (${response.statusCode})',
        };
      }

      return decoded;
    } catch (e) {
      return {'exito': false, 'error': 'No se pudo conectar con el servidor: $e'};
    }
  }

  static Future<Map<String, dynamic>> listarUsuarios() async {
    return _post(body: {'action': 'list'});
  }

  static Future<Map<String, dynamic>> crearUsuario({
    required String nombre,
    required String email,
    required String rolCognito,
    List<String> mediciones = const [],
  }) async {
    return _post(body: {
      'action': 'create',
      'nombre': nombre,
      'email': email,
      'rol': rolCognito,
      'mediciones': mediciones,
    });
  }

  /// Actualiza `custom:role` en Cognito y el metadata en AppSync.
  static Future<Map<String, dynamic>> actualizarRol({
    required String userId,
    required String rolCognito,
  }) async {
    return _post(body: {
      'action': 'updateRole',
      'userId': userId,
      'rol': rolCognito,
    });
  }
}
