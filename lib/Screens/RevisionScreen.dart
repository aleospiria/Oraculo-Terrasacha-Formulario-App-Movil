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

    // Campos a mostrar (excluimos algunos internos)
    final camposMostrar = {
      'Parcela': registro['parcela_nombre'],
      'Especie': registro['especie'],
      'Número de Árbol': registro['numArbol'],
      'Diámetro (cm)': registro['diametro'],
      'Altura (m)': registro['altura'],
      'Observaciones': registro['observaciones'],
      'Coordenadas': registro['coordenadas'],
      'Estado': registro['estado'],
      'Fecha': registro['created_at'],
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Revisión de datos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalles del Registro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: camposMostrar.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value?.toString() ?? 'N/A'),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            if (editable)
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
                onPressed: () {
                  Navigator.pushNamed(context, '/captura', arguments: registro);
                },
              ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('Ver Todos los Registros'),
              onPressed: () {
                Navigator.pushNamed(context, '/registros');
              },
            ),
          ],
        ),
      ),
    );
  }
}