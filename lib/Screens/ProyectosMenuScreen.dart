import 'package:flutter/material.dart';

class ProyectosMenuScreen extends StatelessWidget {
  const ProyectosMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Por ahora usamos una lista dummy de proyectos
    final proyectos = <String>['Proyecto A', 'Proyecto B'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Proyectos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            onPressed: () {
              Navigator.pushNamed(context, '/sincronizacion');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Botón para "Nuevo proyecto"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Nuevo proyecto'),
              onPressed: () async {
                final nombre = await _mostrarDialogoNuevoProyecto(context);
                if (nombre != null && nombre.trim().isNotEmpty) {
                  // Aquí luego guardaremos en almacenamiento local
                  // y recargaremos la lista
                  // Por ahora solo mostramos en consola
                  // ignore: avoid_print
                  print('Crear nombre/id del proyecto: $nombre');
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Lista: Escoger proyecto',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: proyectos.length,
              itemBuilder: (context, index) {
                final proyecto = proyectos[index];
                return ListTile(
                  title: Text(proyecto),
                  onTap: () {
                    // Navegar al Menú Parcelas con el proyecto seleccionado
                    Navigator.pushNamed(
                      context,
                      '/parcelas',
                      arguments: proyecto,
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

  Future<String?> _mostrarDialogoNuevoProyecto(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo proyecto'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nombre/ID del proyecto',
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