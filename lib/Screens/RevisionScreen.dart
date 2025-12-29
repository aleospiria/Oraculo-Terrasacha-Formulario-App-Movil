import 'package:flutter/material.dart';

class RevisionScreen extends StatelessWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(title: const Text('Revisión de datos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: args == null
            ? const Text('No se recibieron datos para revisar.')
            : ListView(
          children: args.entries.map((entry) {
            return ListTile(
              title: Text('${entry.key}'),
              subtitle: Text('${entry.value}'),
            );
          }).toList(),
        ),
      ),
    );
  }
}