import 'package:flutter/material.dart';

class ParcelasMenuScreen extends StatelessWidget {
  const ParcelasMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String proyecto =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Proyecto';

    // Dummy de parcelas
    final parcelas = <String>['Parcela 1', 'Parcela 2'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Parcelas - $proyecto'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // "Nueva parcela"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Nueva parcela'),
              onPressed: () async {
                final nombre = await _mostrarDialogoNuevaParcela(context);
                if (nombre != null && nombre.trim().isNotEmpty) {
                  // Aquí luego guardaremos la parcela ligada al proyecto
                  // ignore: avoid_print
                  print('Crear nombre/id de la parcela: $nombre en $proyecto');
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Lista: Escoger parcela',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: parcelas.length,
              itemBuilder: (context, index) {
                final parcela = parcelas[index];
                return ListTile(
                  title: Text(parcela),
                  onTap: () {
                    // Ir a Captura de datos
                    Navigator.pushNamed(
                      context,
                      '/captura',
                      arguments: {
                        'proyecto': proyecto,
                        'parcela': parcela,
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _mostrarDialogoNuevaParcela(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva parcela'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nombre/ID de la parcela',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
            ),
          ],
        );
      },
    );
  }
}