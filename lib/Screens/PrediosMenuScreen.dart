import 'package:flutter/material.dart';
import '../data/LocalDatabase.dart';

class PrediosMenuScreen extends StatefulWidget {
  const PrediosMenuScreen({super.key});

  @override
  State<PrediosMenuScreen> createState() => _PrediosMenuScreenState();
}

class _PrediosMenuScreenState extends State<PrediosMenuScreen> {
  List<Map<String, dynamic>> _predios = [];
  int? _proyectoLocalId;
  String? _proyectoNombre;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _proyectoLocalId = args['proyecto_local_id'];
      _proyectoNombre = args['proyecto_nombre'];
      _cargarPredios();
    }
  }

  Future<void> _cargarPredios() async {
    if (_proyectoLocalId == null) return;
    final predios = await LocalDatabase.instance.getPrediosByProyecto(_proyectoLocalId!);
    setState(() {
      _predios = predios;
    });
  }

  Future<void> _nuevoPredio(BuildContext context) async {
    final nombre = await _mostrarDialogoNuevoPredio(context);
    if (nombre != null && nombre.trim().isNotEmpty && _proyectoLocalId != null) {
      await LocalDatabase.instance.insertPredio({
        'predio_id': 'local-${DateTime.now().millisecondsSinceEpoch}',
        'nombre': nombre.trim(),
        'poligono_geojson': '',
        'proyecto_id': '',
        'proyecto_local_id': _proyectoLocalId!,
      });
      await _cargarPredios();
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
            decoration: const InputDecoration(
              labelText: 'Nombre del predio',
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
                  title: Text(predio['nombre'] ?? 'Sin nombre'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/parcelas',
                      arguments: {
                        'predio_local_id': predio['id'],
                        'predio_nombre': predio['nombre'],
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