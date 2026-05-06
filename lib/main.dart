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

// StreamController para notificar cuando la sincronización esté lista
final _syncReadyController = StreamController<bool>.broadcast();
Stream<bool> get syncReadyStream => _syncReadyController.stream;
bool _isSyncReady = false;
bool get isSyncReady => _isSyncReady;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const CapturadorApp());
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAPI());
    await Amplify.addPlugin(
      AmplifyDataStore(modelProvider: ModelProvider.instance),
    );

    await Amplify.configure(amplifyconfig);
    await Amplify.DataStore.start();

    // Escuchar eventos de sincronización SIN bloquear el startup
    _escucharSincronizacion();

    safePrint('✅ Amplify inicializado, esperando sincronización...');
  } on AmplifyAlreadyConfiguredException {
    safePrint('⚠️ Amplify ya estaba configurado');
  } on Exception catch (e) {
    safePrint('❌ Error al configurar Amplify: $e');
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

class CapturadorApp extends StatelessWidget {
  const CapturadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terrasacha - Captura de Datos',
      debugShowCheckedModeBanner: false,
      theme: terrasachaTheme,
      initialRoute: '/home',
      routes: {
        '/home':      (context) => const PanelControlScreen(),
        '/proyectos':      (context) => const ProyectosMenuScreen(),
        '/predios':        (context) => const PrediosMenuScreen(),
        '/parcelas':       (context) => const ParcelasMenuScreen(),
        '/trees':          (context) => const TreesMenuScreen(),
        '/captura':        (context) => const CapturaDatosScreen(),
        '/sincronizacion': (context) => const SincronizacionScreen(),
        '/revision':       (context) => const RevisionScreen(),
        '/registros':      (context) => const RegistrosGuardadosScreen(),
        '/incidencias': (context) => const RegistroIncidenciaScreen(),
        '/reportar-incidencia': (context) => const ReportarIncidenciaScreen(),
      },
    );
  }
}