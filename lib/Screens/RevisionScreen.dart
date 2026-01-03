import 'package:flutter/material.dart';

class RevisionScreen extends StatelessWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registro = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (registro == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Revisión de datos')),
        body: const Center(child: Text('No se recibieron datos para revisar.')),
      );
    }

    final bool editable = registro['estado'] == 'pendiente';

    return Scaffold(
      appBar: AppBar(title: const Text('Revisión de datos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: registro.entries.map((entry) {
                  if (entry.key == 'id') return const SizedBox.shrink();
                  return ListTile(
                    title: Text('${entry.key}'),
                    subtitle: Text('${entry.value}'),
                  );
                }).toList(),
              ),
            ),
            if (editable)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/captura', arguments: registro);
                },
                child: const Text('Editar'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registros');
              },
              child: const Text('Ver Registros Guardados'),
            ),
          ],
        ),
      ),
    );
  }
}