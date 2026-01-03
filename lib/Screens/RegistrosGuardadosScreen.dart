import 'package:flutter/material.dart';
import '../data/LocalDataBase.dart';

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
    _registrosFuture = LocalDatabase.instance.getRegistros();
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
                title: Text('Especie: ${reg['especie']}'),
                subtitle: Text('Árbol: ${reg['numArbol']}, Estado: ${reg['estado']}'),
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