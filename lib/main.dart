import 'package:flutter/material.dart';

import 'Screens/CapturaDatosScreen.dart';
import 'Screens/ParcelasMenuScreen.dart';
import 'Screens/ProyectosMenuScreen.dart';
import 'Screens/SincronizacionScreen.dart';
import 'Screens/RevisionScreen.dart';
import 'theme.dart';

void main() {
  runApp(const CapturadorApp());
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
        '/parcelas': (context) => const ParcelasMenuScreen(),
        '/captura': (context) => const CapturaDatosScreen(),
        '/sincronizacion': (context) => const SincronizacionScreen(),
        '/revision': (context) => const RevisionScreen(),
      },
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