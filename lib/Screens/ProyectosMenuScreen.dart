// ProyectosMenuScreen.dart
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/ModelProvider.dart';
import 'dart:async';

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
    _cargarProyectosDeLaNube(); // Usamos API directo para saltar el error de DataStore
  }

  // ESTA ES LA FUNCIÓN CLAVE: Va directo a la nube sin pasar por DataStore
  Future<void> _cargarProyectosDeLaNube() async {
    setState(() => cargando = true);
    try {
      final request = ModelQueries.list(Project.classType);
      final response = await Amplify.API.query(request: request).response;

      final lista = response.data?.items.whereType<Project>().toList() ?? [];

      setState(() {
        proyectos = lista;
        cargando = false;
      });

      // Una vez traídos de la nube, los guardamos en DataStore para que estén offline
      for (var p in lista) {
        await Amplify.DataStore.save(p);
      }

    } catch (e) {
      safePrint('Error directo de API: $e');
      // Si falla la nube, intentamos carga local
      _cargarProyectosLocales();
    }
  }

  Future<void> _cargarProyectosLocales() async {
    try {
      final lista = await Amplify.DataStore.query(Project.classType);
      setState(() {
        proyectos = lista;
        cargando = false;
      });
    } catch (e) {
      safePrint('Error local: $e');
    }
  }

  Future<void> _crearProyecto(String nombre) async {
    try {
      final nuevoProyecto = Project(
        name: nombre,
        status: 'activo',
      );
      // Guardamos en DataStore (esto se sincronizará cuando pueda)
      await Amplify.DataStore.save(nuevoProyecto);

      // Refrescamos la lista localmente para que el usuario vea el cambio
      await _cargarProyectosLocales();
    } catch (e) {
      safePrint('Error creando proyecto: $e');
    }
  }

  // ... (El resto del código _nuevoProyecto y build se mantiene igual)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Proyectos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarProyectosDeLaNube, // Botón para forzar refresco de nube
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
                  subtitle: Text('ID: ${proyecto.id.substring(0,8)}...'),
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

  // ... (Mantén el método _nuevoProyecto que ya teníamos)
  Future<void> _nuevoProyecto(BuildContext context) async {
    final controller = TextEditingController();
    final nombre = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuevo proyecto'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(dialogContext, controller.text.trim()), child: const Text('Guardar')),
        ],
      ),
    );
    if (nombre != null && nombre.isNotEmpty) await _crearProyecto(nombre);
  }
}