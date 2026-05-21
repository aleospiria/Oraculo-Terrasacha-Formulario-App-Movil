// main.dart
import 'dart:async';
import 'package:capturador_datos_offline/screens/PanelControlScreen.dart';
import 'package:capturador_datos_offline/screens/PrediosMenuScreen.dart';
import 'package:capturador_datos_offline/screens/ReportarIncidenciaScreen.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'models/ModelProvider.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'Screens/CapturaDatosScreen.dart';
import 'Screens/ParcelasMenuScreen.dart';
import 'Screens/ProyectosMenuScreen.dart';
import 'Screens/TreesMenuScreen.dart';
import 'Screens/SincronizacionScreen.dart';
import 'Screens/RevisionScreen.dart';
import 'Screens/RegistrosGuardadosScreen.dart';
import 'theme.dart';
import 'amplifyconfiguration.dart';
import 'Screens/RegistroIncidenciaScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/RegisterScreen.dart';
import 'Screens/VerificacionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// StreamController para notificar cuando la sincronización esté lista
final _syncReadyController = StreamController<bool>.broadcast();
Stream<bool> get syncReadyStream => _syncReadyController.stream;
bool _isSyncReady = false;
bool get isSyncReady => _isSyncReady;

// Verificar si ya se sincronizó al menos una vez (datos en local)
bool _hasLocalData = false;
bool get hasLocalData => _hasLocalData;

// ── Verificación de email pendiente (timeout 5 min) ──
String? _pendingVerificationEmail;
const Duration _pendingVerificationTimeout = Duration(minutes: 1); // TODO: cambiar a 5 min tras pruebas

/// Guarda un email pendiente de verificación con su timestamp
void setPendingVerification(String email) {
  _pendingVerificationEmail = email;
  _prefs?.setString('pending_email', email);
  _prefs?.setString('pending_timestamp', DateTime.now().toIso8601String());
}

/// Limpia el estado de verificación pendiente
void clearPendingVerification() {
  _pendingVerificationEmail = null;
  _prefs?.remove('pending_email');
  _prefs?.remove('pending_timestamp');
}

/// Lee el email pendiente: primero de memoria, luego de SharedPreferences
String? _readPendingEmail() {
  if (_pendingVerificationEmail != null) return _pendingVerificationEmail;
  final savedEmail = _prefs?.getString('pending_email');
  if (savedEmail == null) return null;
  final savedTs = _prefs?.getString('pending_timestamp');
  if (savedTs == null) return null;
  final timestamp = DateTime.tryParse(savedTs);
  if (timestamp == null) return null;
  if (DateTime.now().difference(timestamp) > _pendingVerificationTimeout) {
    clearPendingVerification();
    return null;
  }
  _pendingVerificationEmail = savedEmail;
  return savedEmail;
}

/// Retorna el email pendiente si aún no ha expirado el timeout
String? get pendingVerificationEmail => _readPendingEmail();

SharedPreferences? _prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _prefs = await SharedPreferences.getInstance();
  await _configureAmplify();
  runApp(const CapturadorApp());
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAPI());
    await Amplify.addPlugin(
      AmplifyDataStore(modelProvider: ModelProvider.instance),
    );

    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
    await Amplify.DataStore.start();

    // Verificar si ya hay datos en local (offline-first)
    await _verificarDatosLocales();

    // Escuchar eventos de sincronización SIN bloquear el startup
    _escucharSincronizacion();

    safePrint('✅ Amplify inicializado');
  } on AmplifyAlreadyConfiguredException {
    safePrint('⚠️ Amplify ya estaba configurado');
  } on Exception catch (e) {
    safePrint('❌ Error al configurar Amplify: $e');
  }
}

/// Verifica si ya hay datos en SQLite (sincronización previa completada)
Future<void> _verificarDatosLocales() async {
  try {
    final proyectos = await Amplify.DataStore.query(Project.classType);
    _hasLocalData = proyectos.isNotEmpty;
    safePrint(_hasLocalData 
      ? '✅ Datos locales encontrados: ${proyectos.length} proyectos' 
      : '⚠️ No hay datos locales - primera sincronización pendiente');
  } catch (e) {
    safePrint('⚠️ Error verificando datos locales: $e');
    _hasLocalData = false;
  }
}

/// Escucha los eventos de DataStore y notifica cuando syncQueriesReady llega
void _escucharSincronizacion() {
  Amplify.Hub.listen(HubChannel.DataStore, (event) {
    safePrint('📡 DataStore Hub event: ${event.eventName}');

    if (event.eventName == 'syncQueriesReady') {
      safePrint('✅ syncQueriesReady — todos los modelos disponibles en local');
      _isSyncReady = true;
      if (!_syncReadyController.isClosed) {
        _syncReadyController.add(true);
      }
    }

    if (event.eventName == 'ready') {
      safePrint('✅ ready — DataStore completamente sincronizado');
      _isSyncReady = true;
      if (!_syncReadyController.isClosed) {
        _syncReadyController.add(true);
      }
    }
  });
}

class _HomeRouter extends StatefulWidget {
  final String initialRoute;
  const _HomeRouter({required this.initialRoute});

  @override
  State<_HomeRouter> createState() => _HomeRouterState();
}

class _HomeRouterState extends State<_HomeRouter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, widget.initialRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F8F6),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF4A5C24)),
      ),
    );
  }
}

class CapturadorApp extends StatefulWidget {
  const CapturadorApp({super.key});

  @override
  State<CapturadorApp> createState() => _CapturadorAppState();
}

class _CapturadorAppState extends State<CapturadorApp> {
  String _initialRoute = '/login';
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    String route;
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      final signedIn = session.isSignedIn;

      if (pendingVerificationEmail != null) {
        route = '/verificacion';
      } else if (signedIn) {
        clearPendingVerification();
        route = '/home';
      } else {
        route = '/login';
      }
    } catch (e) {
      route = pendingVerificationEmail != null ? '/verificacion' : '/login';
    }

    if (mounted) {
      setState(() {
        _initialRoute = route;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terrasacha - Captura de Datos',
      debugShowCheckedModeBanner: false,
      theme: terrasachaTheme,
      home: _isChecking
          ? const Scaffold(
              backgroundColor: Color(0xFFF7F8F6),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF4A5C24)),
              ),
            )
          : _HomeRouter(initialRoute: _initialRoute),
      routes: {
        '/login':               (context) => const LoginScreen(),
        '/register':            (context) => const RegisterScreen(),
        '/verificacion':        (context) => const VerificacionScreen(),
        '/home':                (context) => const PanelControlScreen(),
        '/proyectos':           (context) => const ProyectosMenuScreen(),
        '/predios':             (context) => const PrediosMenuScreen(),
        '/parcelas':            (context) => const ParcelasMenuScreen(),
        '/trees':               (context) => const TreesMenuScreen(),
        '/captura':             (context) => const CapturaDatosScreen(),
        '/sincronizacion':      (context) => const SincronizacionScreen(),
        '/revision':            (context) => const RevisionScreen(),
        '/registros':           (context) => const RegistrosGuardadosScreen(),
        '/incidencias':         (context) => const RegistroIncidenciaScreen(),
        '/reportar-incidencia': (context) => const ReportarIncidenciaScreen(),
      },
    );
  }
}