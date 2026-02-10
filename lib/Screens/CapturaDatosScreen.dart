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

    // QUERY LIMPIA: Solo campos que el esquema del Senior confirma
    const query = r'''
      query ListRawData {
        listRawData {
          items {
            id
            name
            valueFloat
            valueString
            tree {
              id
            }
          }
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(document: query);
      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        safePrint('❌ Errores de API: ${response.errors}');
      }

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final List<dynamic> allItems = jsonData['listRawData']['items'];

        // 🔍 DIAGNÓSTICO CRÍTICO: Vamos a ver qué campos trae el primer item
        if (allItems.isNotEmpty) {
          safePrint('📡 PRIMER ITEM RECIBIDO: ${allItems[0]}');
        }

        // Filtro por el objeto tree
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
        safePrint('✅ Total nube: ${allItems.length} | Filtrados: ${filtrados.length}');
      } else {
        if (mounted) setState(() => cargando = false);
      }
    } catch (e) {
      safePrint('❌ Error en la petición: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(treeName)),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : rawDataList.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No se encontraron datos para este árbol"),
            const SizedBox(height: 10),
            Text("ID del Árbol: $treeId", style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ElevatedButton(onPressed: _cargarRawData, child: const Text("Actualizar"))
          ],
        ),
      )
          : ListView.builder(
        itemCount: rawDataList.length,
        itemBuilder: (context, index) {
          final item = rawDataList[index];
          return ListTile(
            title: Text(item['name'] ?? 'Sin nombre'),
            subtitle: Text('Valor: ${item['valueFloat'] ?? item['valueString'] ?? 'N/A'}'),
          );
        },
      ),
    );
  }
}//a