import 'package:flutter/material.dart';

import 'Screens/CapturaDatosScreen.dart';
import 'Screens/ParcelasMenuScreen.dart';
import 'Screens/ProyectosMenuScreen.dart';
import 'Screens/SincronizacionScreen.dart';



void main() {
  runApp(const CapturadorApp());
}

class CapturadorApp extends StatelessWidget {
  const CapturadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capturador de Datos Offline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/proyectos',
      routes: {
        '/proyectos': (context) => const ProyectosMenuScreen(),
        '/parcelas': (context) => const ParcelasMenuScreen(),
        '/captura': (context) => const CapturaDatosScreen(),
        '/sincronizacion': (context) => const SincronizacionScreen(),
      },
    );
  }
}