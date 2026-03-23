import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/ModelProvider.dart';

class RegistrosGuardadosScreen extends StatefulWidget {
  const RegistrosGuardadosScreen({super.key});

  @override
  State<RegistrosGuardadosScreen> createState() => _RegistrosGuardadosScreenState();
}

class _RegistrosGuardadosScreenState extends State<RegistrosGuardadosScreen> {
  late Future<List<Map<String, dynamic>>> _registrosFuture;

  @override
  void initState() {
    super.initState();
    _loadRegistros();
  }

  void _loadRegistros() {
    _registrosFuture = _fetchRegistros();
  }

  Future<List<Map<String, dynamic>>> _fetchRegistros() async {
    try {
      // Consulta todos los árboles (Tree)
      final trees = await Amplify.DataStore.query(Tree.classType);

      // Para cada árbol, consulta sus RawData y Project relacionados
      List<Map<String, dynamic>> registros = [];

      for (var tree in trees) {
        // Obtener RawData relevantes (ejemplo: especie, estado, numArbol)
        final rawDatas = await Amplify.DataStore.query(
          RawData.classType,
          where: RawData.TREE.eq(tree.id),
        );

        // Extraer datos específicos
        String especie = rawDatas.firstWhere(
              (rd) => rd.name == 'Especie',
          orElse: () => RawData(name: 'Especie', valueString: 'Sin especie'),
        ).valueString ?? 'Sin especie';

        String numArbol = rawDatas.firstWhere(
              (rd) => rd.name == 'Número de árbol',
          orElse: () => RawData(name: 'Número de árbol', valueString: 'N/A'),
        ).valueString ?? 'N/A';

        // Obtener proyecto y predio (Project) relacionados
        Project? project = tree.project;

        registros.add({
          'id': tree.id,
          'parcela_nombre': tree.name,
          'especie': especie,
          'numArbol': numArbol,
          'estado': tree.status ?? 'Desconocido',
          'proyecto_nombre': project?.name ?? 'Sin proyecto',
          'predio_nombre': project?.name ?? 'Sin predio', // Ajusta según tu modelo
          // Agrega más campos si necesitas
        });
      }

      return registros;
    } catch (e) {
      safePrint('Error cargando registros: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registros Guardados')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _registrosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay registros guardados'));
          }

          final registros = snapshot.data!;

          return ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final reg = registros[index];
              return ListTile(
                title: Text('${reg['parcela_nombre']} - Árbol ${reg['numArbol']}'),
                subtitle: Text(
                  '${reg['especie'] ?? 'Sin especie'}\n'
                      'Estado: ${reg['estado']}\n'
                      '${reg['proyecto_nombre']} > ${reg['predio_nombre']}',
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/revision', arguments: reg)
                      .then((_) => setState(() => _loadRegistros()));
                },
              );
            },
          );
        },
      ),
    );
  }
}