import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class SincronizacionScreen extends StatefulWidget {
  const SincronizacionScreen({super.key});

  @override
  State<SincronizacionScreen> createState() => _SincronizacionScreenState();
}

class _SincronizacionScreenState extends State<SincronizacionScreen> {
  String _resultado = 'Respuesta API';
  bool _cargando = false;

  final Map<String, String> _queries = {
    'Proyectos': r'''
      query ListProjects {
        listProjects {
          items {
            id
            name
            status
          }
        }
      }
    ''',
    'Trees': r'''
      query ListTrees {
        listTrees {
          items {
            id
            name
            status
            project { name }
          }
        }
      }
    ''',
  };

  Future<void> _consultarApi(String entidad, String query) async {
    setState(() {
      _cargando = true;
      _resultado = 'Consultando $entidad...';
    });

    try {
      final request = GraphQLRequest<String>(document: query);
      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty) {
        setState(() {
          _resultado = '❌ Errores:\n${response.errors.join('\n')}';
        });
      } else {
        setState(() {
          _resultado = ' $entidad:\n${response.data}';
        });
      }
    } catch (e) {
      setState(() {
        _resultado = '❌ Error:\n$e';
      });
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botones de consulta
            ..._queries.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                onPressed: _cargando ? null : () => _consultarApi(entry.key, entry.value),
                child: Text('Listar ${entry.key}'),
              ),
            )),

            const SizedBox(height: 20),
            const Text(
              'Response',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),

            // Cuadro de texto estilo consola
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5), // Gris muy claro
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _resultado,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            if (_cargando)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}