import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import '../models/usuario_campo.dart';
import 'roles_campo.dart';

class servicioAutenticacion {

  // LOGIN
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        final rol = await getRol();
        return {'success': true, 'rol': rol};
      }

      if (result.nextStep.signInStep ==
          AuthSignInStep.confirmSignInWithNewPassword) {
        return {
          'success': false,
          'requiresNewPassword': true,
        };
      }

      return {
        'success': false,
        'error': 'Se requiere un paso adicional para iniciar sesión',
      };
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    }
  }

  /// Completa el inicio de sesión cuando Cognito exige cambiar la contraseña temporal.
  static Future<Map<String, dynamic>> confirmarNuevaContrasena(
    String nuevaContrasena,
  ) async {
    try {
      final result = await Amplify.Auth.confirmSignIn(
        confirmationValue: nuevaContrasena,
      );

      if (result.isSignedIn) {
        final rol = await getRol();
        return {'success': true, 'rol': rol};
      }

      if (result.nextStep.signInStep ==
          AuthSignInStep.confirmSignInWithNewPassword) {
        return {
          'success': false,
          'error': 'Aún debes establecer una nueva contraseña',
        };
      }

      return {
        'success': false,
        'error': 'No se pudo completar el cambio de contraseña',
      };
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    }
  }

  // REGISTRO (solo lider_cuadrilla y operador)
  static Future<Map<String, dynamic>> register(String email, String password, String rol) async {
    try {
      await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: email,
          const CognitoUserAttributeKey.custom('role'): rol,
        }),
      );
      return {'success': true};
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    }
  }

  /// Nombre para mostrar en asignaciones (atributo Cognito `name` o parte local del email).
  static Future<String> getNombreDisplay() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (final key in [
        CognitoUserAttributeKey.name,
        CognitoUserAttributeKey.givenName,
      ]) {
        final match = attributes.where((a) => a.userAttributeKey == key);
        if (match.isNotEmpty) {
          final value = match.first.value.trim();
          if (value.isNotEmpty) {
        return RolesCampo.normalizarNombre(value);
      }
        }
      }
      final emailAttr = attributes.firstWhere(
        (a) => a.userAttributeKey == CognitoUserAttributeKey.email,
        orElse: () => const AuthUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.email,
          value: '',
        ),
      );
      if (emailAttr.value.isNotEmpty) {
        final local = emailAttr.value.split('@').first;
        return RolesCampo.normalizarNombre(local);
      }
    } catch (_) {}
    return 'Jefe de cuadrilla';
  }

  /// Usuario autenticado para asignaciones y filtrado de tareas.
  static Future<UsuarioCampo?> getUsuarioActual() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final nombre = await getNombreDisplay();
      final rol = await getRol() ?? '';
      return UsuarioCampo(
        id: user.userId,
        nombre: nombre,
        rolCognito: rol,
        rolDisplay: RolesCampo.etiquetaDesdeCognito(rol),
      );
    } catch (_) {
      return null;
    }
  }

  // OBTENER ROL del usuario logueado
  static Future<String?> getRol() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final rolAttr = attributes.firstWhere(
            (a) => a.userAttributeKey.key == 'custom:role',
        orElse: () => const AuthUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.email,
          value: '',
        ),
      );
      return rolAttr.value.isEmpty ? null : rolAttr.value;
    } catch (e) {
      return null;
    }
  }

  // CAMBIAR ROL (solo lider_proyecto puede llamar esto)
  static Future<bool> cambiarRol(String username, String nuevoRol) async {
    // TODO: Implementar llamada Lambda con permisos admin para cambiar los atributos de rol.
    return false;
  }

  // Verificar código de confirmación
  static Future<Map<String, dynamic>> verificarCodigo(String email, String codigo) async {
    try {
      await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: codigo,
      );
      return {'success': true};
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    }
  }

// Reenviar código
  static Future<Map<String, dynamic>> reenviarCodigo(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return {'success': true};
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    await Amplify.Auth.signOut();
  }
}