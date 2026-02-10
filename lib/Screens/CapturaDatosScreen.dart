// CapturaDatosScreen.dart
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
            start_date
            tree {
              id
            }
            feature {
              id
              name
              unitOfMeasure {
                id
                engineering_unit
              }
            }
          }
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(document: query);
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final List<dynamic> allItems = jsonData['listRawData']['items'];

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
        debugPrint('✅ Recibidos: ${allItems.length} | Filtrados: ${filtrados.length}');
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
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

          final feature = item['feature'];
          final unit = feature?['unitOfMeasure']?['engineering_unit'] ?? '';
          final featureName = feature?['name'] ?? 'Sin nombre';
          final valor = item['valueFloat']?.toString() ?? item['valueString'] ?? 'N/A';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.science)),
              title: Text(featureName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('$valor $unit'),
              trailing: item['start_date'] != null
                  ? Text(
                DateTime.parse(item['start_date']).toLocal().toString().split(' ')[0],
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              )
                  : null,
            ),
          );
        },
      ),
    );
  }
}