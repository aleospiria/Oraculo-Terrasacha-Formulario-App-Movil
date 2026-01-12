import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'Screens/CapturaDatosScreen.dart';
import 'Screens/ParcelasMenuScreen.dart';
import 'Screens/ProyectosMenuScreen.dart';
import 'Screens/PrediosMenuScreen.dart';
import 'Screens/SincronizacionScreen.dart';
import 'Screens/RevisionScreen.dart';
import 'Screens/RegistrosGuardadosScreen.dart';
import 'theme.dart';

//Configurar con el endpoint y api key real
const String graphQLEndpoint = 'https://TU-ENDPOINT.appsync-api.TU-REGION.amazonaws.com/graphql';
const String apiKey = 'TU_API_KEY';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(
    graphQLEndpoint,
    defaultHeaders: {
      'x-api-key': apiKey,
    },
  );

  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(CapturadorApp(graphQLClient: client));
}

class CapturadorApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> graphQLClient;

  const CapturadorApp({super.key, required this.graphQLClient});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: graphQLClient,
      child: MaterialApp(
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
      ),
    );
  }
}

Widget _buildErrorScreen(Object e, StackTrace st) {
  return Scaffold(
    appBar: AppBar(title: const Text('Error al construir ruta')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SelectableText('Error: $e\n\nStack:\n$st'),
    ),
  );
}