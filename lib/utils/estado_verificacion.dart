import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _prefs;

String? _pendingVerificationEmail;
const Duration _pendingVerificationTimeout = Duration(minutes: 1);

void initEstadoVerificacion(SharedPreferences prefs) {
  _prefs = prefs;
}

void setPendingVerification(String email) {
  _pendingVerificationEmail = email;
  _prefs?.setString('pending_email', email);
  _prefs?.setString('pending_timestamp', DateTime.now().toIso8601String());
}

void clearPendingVerification() {
  _pendingVerificationEmail = null;
  _prefs?.remove('pending_timestamp');
}

void clearAllVerificationData() {
  _pendingVerificationEmail = null;
  _prefs?.remove('pending_email');
  _prefs?.remove('pending_timestamp');
}

Future<String?> pendingVerificationEmail() async {
  if (_pendingVerificationEmail != null) return _pendingVerificationEmail;
  final savedEmail = _prefs?.getString('pending_email');
  if (savedEmail == null) return null;
  final savedTs = _prefs?.getString('pending_timestamp');
  if (savedTs == null) return null;
  final timestamp = DateTime.tryParse(savedTs);
  if (timestamp == null) return null;
  if (DateTime.now().difference(timestamp) > _pendingVerificationTimeout) {
    clearPendingVerification();
    try {
      await Amplify.Auth.signOut();
    } catch (_) {}
    return null;
  }
  _pendingVerificationEmail = savedEmail;
  return savedEmail;
}
