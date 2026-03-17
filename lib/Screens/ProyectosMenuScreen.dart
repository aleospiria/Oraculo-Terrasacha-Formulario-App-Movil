// ProyectosMenuScreen.dart
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'dart:convert'; // Para procesar el JSON de la API

class ProyectosMenuScreen extends StatefulWidget {
  const ProyectosMenuScreen({super.key});

  @override
  State<ProyectosMenuScreen> createState() => _ProyectosMenuScreenState();
}

class _ProyectosMenuScreenState extends State<ProyectosMenuScreen> {
  List<dynamic> proyectos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDesdeNube();
  }

  Future<void> _cargarDesdeNube() async {
    if (!mounted) return;
    setState(() => cargando = true);

    try {
      safePrint('🌐 Conectando con el backend...');

      String graphQLDocument = '''
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

      final operation = Amplify.API.query(
        request: GraphQLRequest<String>(document: graphQLDocument),
      );

      final response = await operation.response;
      final data = response.data;

      if (data != null) {
        final Map<String, dynamic> jsonMap = json.decode(data);
        if (mounted) {
          setState(() {
            proyectos = jsonMap['listProjects']['items'];
            cargando = false;
          });
        }
        safePrint('✅ Se cargaron ${proyectos.length} proyectos.');
      }
    } catch (e) {
      safePrint('❌ Error cargando de la nube: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyectos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: _cargarDesdeNube,
            tooltip: 'Forzar recarga de nube',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(8),
            child: const Text(
              "Conectado directamente a la API (Bypass DataStore)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : proyectos.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No se encontraron proyectos en la nube.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _cargarDesdeNube,
                    child: const Text('Reintentar conexión'),
                  )
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _cargarDesdeNube,
              child: ListView.builder(
                itemCount: proyectos.length,
                itemBuilder: (context, index) {
                  final proyecto = proyectos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: const Icon(Icons.account_tree, color: Colors.green),
                      title: Text(
                        proyecto['name'] ?? 'Sin nombre',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('ID: ${proyecto['id'].toString().substring(0, 8)}...'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navegamos a Trees pasando los datos.
                        Navigator.pushNamed(
                          context,
                          '/trees',
                          arguments: {
                            'proyecto_id': proyecto['id'],
                            'proyecto_nombre': proyecto['name'],
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}