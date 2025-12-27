import 'package:flutter/material.dart';

class CapturaDatosScreen extends StatelessWidget {
  const CapturaDatosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final proyecto = args?['proyecto'] ?? 'Proyecto';
    final parcela = args?['parcela'] ?? 'Parcela';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura de datos'),
      ),
      body: Center(
        child: Text(
          'Aquí irá el formulario de captura\n\n'
              'Proyecto: $proyecto\n'
              'Parcela: $parcela',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}