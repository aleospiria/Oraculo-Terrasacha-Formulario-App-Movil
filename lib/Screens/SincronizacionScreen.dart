import 'package:flutter/material.dart';

class SincronizacionScreen extends StatelessWidget {
  const SincronizacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí luego vamos a implementar:
    // - ¿Hay conexión a internet?
    // - ¿Hay datos?
    // - Enviar datos a la nube
    // - Manejar errores y éxito
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronización con la nube'),
      ),
      body: const Center(
        child: Text(
          'Aquí irá la lógica de sincronización:\n'
              '- Verificar conexión\n'
              '- Verificar si hay datos\n'
              '- Enviar datos a la nube\n'
              '- Manejar errores y estado',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}