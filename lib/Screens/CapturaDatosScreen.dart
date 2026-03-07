
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
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      treeId = args['tree_id'];
      treeName = args['tree_name'];
      _isInitialized = true;
      _cargarRawData();
    }
  }

  Future<void> _cargarRawData() async {
    if (!mounted) return;
    setState(() => cargando = true);

    const query = r'''
      query ListRawData {
        listRawData(limit: 1000) {
          items {
            id
            name
            valueFloat
            valueString
          }
        }
      }
    ''';
          //Pruebas realizadas en postman
    try {
      final request = GraphQLRequest<String>(document: query);
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final List<dynamic> allItems = jsonData['listRawData']['items'];

        // Mostrar primer item para depurar
        if (allItems.isNotEmpty) {
          debugPrint('📡 Primer item recibido: ${allItems[0]}');
        }

        final filtrados = allItems.where((item) {
          final tree = item['tree'];
          return tree != null && tree['id'] == treeId;
        }).toList();

        if (mounted) {
          setState(() {
            rawDataList = List<Map<String, dynamic>>.from(filtrados);
            cargando = false;
          });
        }

        debugPrint('✅ Total recibidos: ${allItems.length} | Filtrados para este árbol: ${filtrados.length}');
      } else {
        debugPrint('⚠️ Sin datos en la respuesta');
        if (mounted) setState(() => cargando = false);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al cargar datos: $e\nStack trace: $stackTrace');
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(treeName),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _cargarRawData)
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : rawDataList.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 10),
            Text("No hay mediciones registradas para $treeName"),
            Text("ID: $treeId", style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        itemCount: rawDataList.length,
        itemBuilder: (context, index) {
          final item = rawDataList[index];

          final String nombre = item['name'] ?? 'Medición sin nombre';
          final String valor =
              item['valueFloat']?.toString() ?? item['valueString'] ?? 'Sin valor';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.science)),
              title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Valor: $valor'),
            ),
          );
        },
      ),
    );
  }
}