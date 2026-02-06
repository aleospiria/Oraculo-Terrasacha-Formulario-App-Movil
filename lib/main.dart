// main.dart
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'models/ModelProvider.dart';

import 'Screens/CapturaDatosScreen.dart';
import 'Screens/ParcelasMenuScreen.dart';
import 'Screens/ProyectosMenuScreen.dart';
import 'Screens/PrediosMenuScreen.dart';
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
    // 1. Agregar plugins en orden
    await Amplify.addPlugin(AmplifyAPI());
    await Amplify.addPlugin(AmplifyDataStore(modelProvider: ModelProvider.instance));

    // 2. Configurar Amplify
    await Amplify.configure(amplifyconfig);

    // 3. Iniciar DataStore (opcional pero recomendado)
    await Amplify.DataStore.start();

    safePrint('✅ Amplify y DataStore configurados y listos');
  } on Exception catch (e) {
    safePrint('❌ Error al configurar Amplify: $e');
  }
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
        '/proyectos': (context) => const ProyectosMenuScreen(),
        '/predios': (context) => const PrediosMenuScreen(),
        '/parcelas': (context) => const ParcelasMenuScreen(),
        '/captura': (context) => const CapturaDatosScreen(),
        '/sincronizacion': (context) => const SincronizacionScreen(),
        '/revision': (context) => const RevisionScreen(),
        '/registros': (context) => const RegistrosGuardadosScreen(),
      },
    );
  }
}