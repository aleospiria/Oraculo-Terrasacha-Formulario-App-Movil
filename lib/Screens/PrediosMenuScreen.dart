// PrediosMenuScreen.dart
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/ModelProvider.dart';

class PrediosMenuScreen extends StatefulWidget {
  const PrediosMenuScreen({super.key});

  @override
  State<PrediosMenuScreen> createState() => _PrediosMenuScreenState();
}

class _PrediosMenuScreenState extends State<PrediosMenuScreen> {
  List<Project> _predios = [];
  String? _proyectoId; // ID del proyecto padre
  String? _proyectoNombre;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _proyectoId = args['proyecto_id']; // Ahora usamos ID de DataStore
      _proyectoNombre = args['proyecto_nombre'];
      _cargarPredios();
    }
  }

  Future<void> _cargarPredios() async {
    if (_proyectoId == null) return;

    try {
      final todos = await Amplify.DataStore.query(Project.classType);
      final predios = todos.where((p) =>
      p.name.startsWith("Predio:") &&
          p.id.contains(_proyectoId!) // Convención para asociar
      ).toList();

      setState(() {
        _predios = predios;
      });
    } catch (e) {
      safePrint('Error cargando predios: $e');
    }
  }

  Future<void> _nuevoPredio(BuildContext context) async {
    final nombre = await _mostrarDialogoNuevoPredio(context);
    if (nombre != null && nombre.trim().isNotEmpty && _proyectoId != null) {
      try {
        final predio = Project(
          id: "${_proyectoId}_predio_${DateTime.now().millisecondsSinceEpoch}",
          name: "Predio: $nombre",
          status: "predio",
        );
        await Amplify.DataStore.save(predio);
        await _cargarPredios();
      } catch (e) {
        safePrint('Error creando predio: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<String?> _mostrarDialogoNuevoPredio(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo predio'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Nombre del predio'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () => Navigator.pop(context, controller.text.trim()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predios - ${_proyectoNombre ?? ''}'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Nuevo predio'),
              onPressed: () => _nuevoPredio(context),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Lista: Escoger predio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _predios.isEmpty
                ? const Center(child: Text('No hay predios'))
                : ListView.builder(
              itemCount: _predios.length,
              itemBuilder: (context, index) {
                final predio = _predios[index];
                return ListTile(
                  title: Text(predio.name.replaceAll("Predio: ", "")),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/parcelas',
                      arguments: {
                        'predio_id': predio.id, // Usamos ID de DataStore
                        'predio_nombre': predio.name.replaceAll("Predio: ", ""),
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
}