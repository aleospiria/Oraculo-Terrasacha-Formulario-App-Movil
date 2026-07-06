import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

// Asegúrate de la ruta correcta. Si está en el mismo folder:
import 'package:capturador_datos_offline/utils/servicio_audios.dart';

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
      query GetTreeRawData($id: ID!) {
        getTree(id: $id) {
          id
          name
          rawData {
            items {
              id
              name
              valueFloat
              valueString
              start_date
              end_date
              createdAt
            }
          }
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: query,
        variables: {"id": treeId},
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);

        if (jsonData['getTree'] != null) {
          final List<dynamic> allItems = jsonData['getTree']['rawData']['items'];

          if (mounted) {
            setState(() {
              rawDataList = List<Map<String, dynamic>>.from(allItems);
              cargando = false;
            });
          }
          debugPrint('✅ Total visualizados: ${allItems.length}');
        } else {
          debugPrint('⚠️ El árbol con ID $treeId no existe en la base de datos');
          if (mounted) setState(() => cargando = false);
        }
      } else {
        debugPrint('⚠️ Sin datos en la respuesta');
        if (mounted) setState(() => cargando = false);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error al cargar datos: $e\nStack trace: $stackTrace');
      if (mounted) setState(() => cargando = false);
    }
  }

  // Heurística simple para reconocer URLs de audio
  bool _looksLikeAudioUrl(String? s) {
    if (s == null) return false;
    final lower = s.toLowerCase();
    // extensiones comunes y detección S3
    final audioExt = ['.mp3', '.m4a', '.wav', '.ogg', '.aac', '.webm'];
    if (audioExt.any((e) => lower.endsWith(e))) return true;
    if (lower.contains('s3.amazonaws') || lower.contains('/audio/')) return true;
    // si es un URI válido con scheme http/https lo consideramos candidato
    final uri = Uri.tryParse(s);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) return true;
    return false;
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
          final String? valueString = item['valueString'] as String?;
          final String valor =
              item['valueFloat']?.toString() ?? valueString ?? 'Sin valor';

          final bool isAudio = _looksLikeAudioUrl(valueString) ||
              (item['name'] != null && item['name'].toString().toLowerCase().contains('audio'));

          if (isAudio && valueString != null) {
            // Mostrar reproductor de audio
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: AudioPlayerTile(
                key: ValueKey('audio_${item['id'] ?? index}'),
                url: valueString,
                title: nombre,
                dense: true,
              ),
            );
          }

          // Item normal (no-audio)
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