// ProyectosMenuScreen.dart
import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class ProyectosMenuScreen extends StatefulWidget {
  const ProyectosMenuScreen({super.key});

  @override
  State<ProyectosMenuScreen> createState() => _ProyectosMenuScreenState();
}

class _ProyectosMenuScreenState extends State<ProyectosMenuScreen> {
  List<Map<String, dynamic>> proyectos = []; // Usamos Map para evitar modelos rotos
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarProyectosDeLaNube();
  }

  // ✅ Consulta directa a la nube sin DataStore
  Future<void> _cargarProyectosDeLaNube() async {
    setState(() => cargando = true);

    const query = r'''
      query ListProjects {
        listProjects {
          items {
            id
            name
            status
          }
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(document: query);
      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty) {
        safePrint('Errores en consulta: ${response.errors}');
        setState(() {
          proyectos = [];
          cargando = false;
        });
        return;
      }

      final data = response.data;
      if (data == null) {
        setState(() {
          proyectos = [];
          cargando = false;
        });
        return;
      }

      // Parsear JSON manualmente
      final jsonData = jsonDecode(data);
      final items = jsonData['listProjects']['items'] as List<dynamic>;

      setState(() {
        proyectos = List<Map<String, dynamic>>.from(items);
        cargando = false;
      });
    } catch (e) {
      safePrint('Error en consulta GraphQL: $e');
      setState(() {
        proyectos = [];
        cargando = false;
      });
    }
  }

  // ✅ Mutación para crear proyecto sin DataStore
  Future<void> _crearProyecto(String nombre) async {
    const mutation = r'''
      mutation CreateProject($name: String!, $status: String!) {
        createProject(input: {name: $name, status: $status}) {
          id
          name
          status
        }
      }
    ''';

    final variables = {
      'name': nombre,
      'status': 'activo',
    };

    try {
      final request = GraphQLRequest<String>(
        document: mutation,
        variables: variables,
      );
      final response = await Amplify.API.mutate(request: request).response;

      if (response.errors.isNotEmpty) {
        safePrint('Error en mutación: ${response.errors}');
        return;
      }

      safePrint('Proyecto creado: ${response.data}');
      // Refrescar lista tras crear
      _cargarProyectosDeLaNube();
    } catch (e) {
      safePrint('Error en mutación GraphQL: $e');
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
            onPressed: _cargarProyectosDeLaNube,
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
                  title: Text(proyecto['name']),
                  subtitle: Text('ID: ${proyecto['id'].substring(0, 8)}...'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/predios',
                      arguments: {
                        'proyecto_id': proyecto['id'],
                        'proyecto_nombre': proyecto['name'],
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