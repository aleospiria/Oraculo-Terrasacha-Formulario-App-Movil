// ProyectosMenuScreen.dart
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import '../models/Project.dart'; // Asegúrate de que la ruta sea correcta

class ProyectosMenuScreen extends StatefulWidget {
  const ProyectosMenuScreen({super.key});

  @override
  State<ProyectosMenuScreen> createState() => _ProyectosMenuScreenState();
}

class _ProyectosMenuScreenState extends State<ProyectosMenuScreen> {
  List<Project> proyectos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarProyectosDesdeDataStore();
  }

  // ✅ Cargar proyectos usando DataStore.observeQuery (sincroniza en tiempo real)
  Future<void> _cargarProyectosDesdeDataStore() async {
    try {
      // 1. Una consulta inicial rápida para mostrar lo que ya haya localmente
      final proyectosIniciales = await Amplify.DataStore.query(Project.classType);
      setState(() {
        proyectos = proyectosIniciales;
        if (proyectos.isNotEmpty) cargando = false;
      });

      // 2. Escuchar cambios (esto atrapará los datos cuando terminen de bajar de la nube)
      Amplify.DataStore.observeQuery(Project.classType).listen(
            (snapshot) {
          if (mounted) {
            setState(() {
              proyectos = snapshot.items;
              cargando = false;
            });
          }
        },
        onError: (error) => safePrint('❌ Error en observeQuery: $error'),
      );
    } catch (e) {
      safePrint('❌ Error al cargar proyectos: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  // ✅ Crear proyecto usando DataStore.save
  Future<void> _crearProyecto(String nombre) async {
    try {
      final nuevoProyecto = Project(
        name: nombre,
        status: 'activo',
      );

      await Amplify.DataStore.save(nuevoProyecto);
      safePrint('✅ Proyecto guardado localmente y sincronizando...');
    } catch (e) {
      safePrint('❌ Error al guardar proyecto: $e');
    }
  }

  Future<void> _nuevoProyecto(BuildContext context) async {
    final controller = TextEditingController();
    final nombre = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuevo proyecto'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (nombre != null && nombre.isNotEmpty) await _crearProyecto(nombre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Proyectos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarProyectosDesdeDataStore,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Nuevo proyecto'),
            onPressed: () => _nuevoProyecto(context),
          ),
          const Divider(),
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : proyectos.isEmpty
                ? const Center(child: Text('No hay proyectos'))
                : ListView.builder(
              itemCount: proyectos.length,
              itemBuilder: (context, index) {
                final proyecto = proyectos[index];
                return ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(proyecto.name),
                  subtitle: Text('ID: ${proyecto.id.substring(0, 8)}...'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/predios',
                      arguments: {
                        'proyecto_id': proyecto.id,
                        'proyecto_nombre': proyecto.name,
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