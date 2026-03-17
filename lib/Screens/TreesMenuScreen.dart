import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class TreesMenuScreen extends StatefulWidget {
  const TreesMenuScreen({super.key});

  @override
  State<TreesMenuScreen> createState() => _TreesMenuScreenState();
}

class _TreesMenuScreenState extends State<TreesMenuScreen> {
  List<Map<String, dynamic>> items = [];
  bool cargando = true;
  late String proyectoId;
  late String proyectoNombre;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recuperamos los argumentos del proyecto seleccionado
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    proyectoId = args['proyecto_id'];
    proyectoNombre = args['proyecto_nombre'];
    _cargarDatosDeLaNube();
  }

  Future<void> _cargarDatosDeLaNube() async {
    setState(() => cargando = true);

    // Query que busca los Trees filtrando por el ID del proyecto
    const query = r'''
      query ListTrees($filter: ModelTreeFilterInput) {
        listTrees(filter: $filter) {
          items {
            id
            name
            status
          }
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'filter': {
            'projectTreesId': {'eq': proyectoId}
          }
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final list = jsonData['listTrees']['items'] as List<dynamic>;
        setState(() {
          items = List<Map<String, dynamic>>.from(list);
          cargando = false;
        });
      }
    } catch (e) {
      safePrint('Error cargando Trees: $e');
      setState(() => cargando = false);
    }
  }

  // ✅ Creación de un nuevo Predio/Tree vinculado al proyecto
  Future<void> _crearItem(String nombre) async {
    const mutation = r'''
      mutation CreateTree($input: CreateTreeInput!) {
        createTree(input: $input) {
          id
          name
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'name': nombre,
            'status': 'Pendiente',
            'projectTreesId': proyectoId
          }
        },
      );
      await Amplify.API.mutate(request: request).response;
      _cargarDatosDeLaNube();
    } catch (e) {
      safePrint('Error creando predio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trees: $proyectoNombre')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Tree'),
              onPressed: () => _mostrarDialogoNuevo(context),
            ),
          ),
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                ? const Center(child: Text('No hay Trees en este proyecto'))
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(item['name']),
                  onTap: () {
                    Navigator.pushNamed(context, '/captura', arguments: {
                      'tree_id': item['id'],
                      'tree_name': item['name'],
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoNuevo(BuildContext context) async {
    final controller = TextEditingController();
    final nombre = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nombre del Predio'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Guardar')),
        ],
      ),
    );
    if (nombre != null && nombre.isNotEmpty) _crearItem(nombre);
  }
}