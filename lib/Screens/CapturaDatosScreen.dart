import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class CapturaDatosScreen extends StatefulWidget {
  const CapturaDatosScreen({super.key});

  @override
  State<CapturaDatosScreen> createState() => _CapturaDatosScreenState();
}

class _CapturaDatosScreenState extends State<CapturaDatosScreen> {
  List<Map<String, dynamic>> rawDataList = [];
  bool cargando = true;
  late String treeId;
  late String treeName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    treeId = args['tree_id'];
    treeName = args['tree_name'];
    _cargarRawData();
  }

  Future<void> _cargarRawData() async {
    setState(() => cargando = true);

    const query = r'''
      query ListRawData($filter: ModelRawDataFilterInput) {
        listRawData(filter: $filter) {
          items {
            id
            name
            valueFloat
            valueString
            timestamp
          }
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'filter': {
            'treeID': {'eq': treeId}
          }
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final items = jsonData['listRawData']['items'] as List<dynamic>;
        setState(() {
          rawDataList = List<Map<String, dynamic>>.from(items);
          cargando = false;
        });
      }
    } catch (e) {
      safePrint('Error cargando RawData: $e');
      setState(() => cargando = false);
    }
  }

  Future<void> _crearRawData(String nombre, double? valorFloat, String? valorString) async {
    const mutation = r'''
      mutation CreateRawData($input: CreateRawDataInput!) {
        createRawData(input: $input) {
          id
          name
          valueFloat
          valueString
          timestamp
        }
      }
    ''';

    final input = {
      'name': nombre,
      'valueFloat': valorFloat,
      'valueString': valorString,
      'timestamp': DateTime.now().toIso8601String(),
      'treeID': treeId, // Ajusta según el nombre real del campo
    };

    try {
      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'input': input},
      );
      await Amplify.API.mutate(request: request).response;
      _cargarRawData();
    } catch (e) {
      safePrint('Error creando RawData: $e');
    }
  }

  // Aquí puedes agregar UI para mostrar la lista y un formulario para crear nuevos datos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Datos de $treeName')),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: rawDataList.length,
        itemBuilder: (context, index) {
          final item = rawDataList[index];
          return ListTile(
            title: Text(item['name'] ?? 'Sin nombre'),
            subtitle: Text(
              item['valueFloat'] != null
                  ? 'Valor: ${item['valueFloat']}'
                  : 'Valor: ${item['valueString'] ?? 'N/A'}',
            ),
            trailing: Text(item['timestamp'] != null
                ? DateTime.parse(item['timestamp']).toLocal().toString()
                : ''),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí muestra un diálogo para crear nuevo RawData
          // Puedes reutilizar el patrón de diálogo que usamos antes
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}