// main.dart
import 'dart:async';
import 'package:capturador_datos_offline/screens/PrediosMenuScreen.dart';
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

    // Esperar a que DataStore termine de bajar todos los datos de la nube
    // antes de mostrar la UI. Sin esto, los queries llegan cuando la DB
    // local todavía está vacía o a medias.
    await _esperarSyncCompleto();

    safePrint('✅ Amplify y DataStore listos y sincronizados');
  } on AmplifyAlreadyConfiguredException {
    safePrint('⚠️ Amplify ya estaba configurado');
  } on Exception catch (e) {
    safePrint('❌ Error al configurar Amplify: $e');
  }
}

/// Espera el evento 'ready' de DataStore, que indica que la sincronización
/// inicial con la nube terminó y la DB local tiene todos los datos.
/// Si pasan 30s sin recibir el evento (sin internet, etc.), continúa igual.
Future<void> _esperarSyncCompleto() async {
  final completer = Completer<void>();
  StreamSubscription? sub;

  sub = Amplify.Hub.listen(HubChannel.DataStore, (event) {
    safePrint('📡 DataStore Hub event: ${event.eventName}');

    // Esperamos que Project termine de sincronizar
    if (event.eventName == 'modelSynced') {
      final payload = event.payload;
      if (payload != null) {
        final modelName = payload.toString();
        safePrint('📦 Model synced: $modelName');
        if (modelName.contains('Project')) {
          safePrint('✅ Project sincronizado — cargando UI');
          sub?.cancel();
          if (!completer.isCompleted) completer.complete();
        }
      }
    }

    // Fallback: si llega ready de todas formas
    if (event.eventName == 'ready') {
      sub?.cancel();
      if (!completer.isCompleted) completer.complete();
    }
  });

  // Timeout de 30s por seguridad
  Future.delayed(const Duration(seconds: 30), () {
    if (!completer.isCompleted) {
      safePrint('⚠️ Timeout, continuando...');
      sub?.cancel();
      completer.complete();
    }
  });

  await completer.future;
}

class CapturadorApp extends StatelessWidget {
  const CapturadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terrasacha - Captura de Datos',
      debugShowCheckedModeBanner: false,
      theme: terrasachaTheme,
      initialRoute: '/proyectos',
      routes: {
        '/proyectos':      (context) => const ProyectosMenuScreen(),
        '/predios':        (context) => const PrediosMenuScreen(),
        '/parcelas':       (context) => const ParcelasMenuScreen(),
        '/trees':          (context) => const TreesMenuScreen(),
        '/captura':        (context) => const CapturaDatosScreen(),
        '/sincronizacion': (context) => const SincronizacionScreen(),
        '/revision':       (context) => const RevisionScreen(),
        '/registros':      (context) => const RegistrosGuardadosScreen(),
      },
    );
  }
}