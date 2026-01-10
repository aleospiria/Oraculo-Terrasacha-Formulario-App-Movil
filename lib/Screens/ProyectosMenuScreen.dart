import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/LocalDatabase.dart';

class ProyectosMenuScreen extends StatefulWidget {
  const ProyectosMenuScreen({super.key});

  @override
  State<ProyectosMenuScreen> createState() => _ProyectosMenuScreenState();
}

class _ProyectosMenuScreenState extends State<ProyectosMenuScreen> {
  List<Map<String, dynamic>> proyectos = [];

  @override
  void initState() {
    super.initState();
    _cargarProyectos();
  }


  Future<void> _cargarProyectos() async {
    try {
      final lista = await LocalDatabase.instance.getProyectos();
      setState(() {
        proyectos = lista;
      });
    } catch (e) {
      debugPrint('Error al cargar proyectos: $e');
    }
  }

  Future<void> _crearProyecto(String nombre) async {
    try {
      await LocalDatabase.instance.insertProyecto({
        'proyecto_id': 'local-${DateTime.now().millisecondsSinceEpoch}',
        'nombre': nombre,
      });
      // Recargamos la lista después de insertar
      await _cargarProyectos();
    } catch (e) {
      debugPrint('Error creando proyecto: $e');
    }
  }

  // Recibe el BuildContext explícitamente para evitar el error de tipos
  Future<void> _nuevoProyecto(BuildContext context) async {
    final controller = TextEditingController();

    final nombre = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Nuevo proyecto'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Nombre del proyecto'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            ),
          ],
        );
      },
    );

    if (nombre != null && nombre.isNotEmpty) {
      await _crearProyecto(nombre);
    }
  }

  Future<void> _borrarBaseDeDatos() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'capturador.db');
      await deleteDatabase(path);
      debugPrint('Base de datos borrada');
      setState(() {
        proyectos = [];
      });
    } catch (e) {
      debugPrint('Error borrando base de datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Borrar base de datos',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirmar borrado'),
                    content: const Text('¿Seguro que quieres borrar toda la base de datos?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.pop(dialogContext, false),
                      ),
                      ElevatedButton(
                        child: const Text('Borrar'),
                        onPressed: () => Navigator.pop(dialogContext, true),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) {
                await _borrarBaseDeDatos();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Nuevo proyecto'),
              // Aquí pasamos el context del build explícitamente
              onPressed: () => _nuevoProyecto(context),
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
            child: proyectos.isEmpty
                ? const Center(child: Text('No hay proyectos'))
                : ListView.builder(
              itemCount: proyectos.length,
              itemBuilder: (BuildContext itemContext, int index) {
                final proyecto = proyectos[index];
                return ListTile(
                  title: Text(proyecto['nombre'] ?? 'Sin nombre'),
                  onTap: () {
                    Navigator.pushNamed(
                      itemContext,
                      '/predios',
                      arguments: {
                        'proyecto_local_id': proyecto['id'],
                        'proyecto_nombre': proyecto['nombre'],
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