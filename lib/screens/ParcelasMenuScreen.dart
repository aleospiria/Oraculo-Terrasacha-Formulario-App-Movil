// ParcelasMenuScreen.dart
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/ModelProvider.dart';

class ParcelasMenuScreen extends StatefulWidget {
  const ParcelasMenuScreen({super.key});

  @override
  State<ParcelasMenuScreen> createState() => _ParcelasMenuScreenState();
}

class _ParcelasMenuScreenState extends State<ParcelasMenuScreen> {
  List<Tree> _parcelas = [];
  String? _predioId; // ID del Project que actúa como predio
  String? _predioNombre;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _predioId = args['predio_id'];
      _predioNombre = args['predio_nombre'];
      _cargarParcelas();
    }
  }

  Future<void> _cargarParcelas() async {
    if (_predioId == null) return;

    try {
      final todas = await Amplify.DataStore.query(Tree.classType);
      final parcelas = todas.where((t) {
        return t.name.startsWith("Parcela:") &&
            t.project != null &&
            t.project!.id == _predioId;
      }).toList();

      setState(() {
        _parcelas = parcelas;
      });
    } catch (e) {
      safePrint('Error cargando parcelas: $e');
    }
  }

  Future<void> _nuevaParcela(BuildContext context) async {
    final resultado = await _mostrarDialogoNuevaParcelaConEspecie(context);
    if (resultado != null &&
        resultado['nombre']!.trim().isNotEmpty &&
        resultado['especie'] != null &&
        _predioId != null) {
      try {
// Crear parcela (Tree)
        final parcelaTemp = Tree(
          name: "Parcela: ${resultado['nombre']}",
          status: "parcela",
        );

// Asociar con Project usando copyWith
        final parcela = parcelaTemp.copyWith(project: Project(id: _predioId!, name: '', status: ''));

        await Amplify.DataStore.save(parcela);

// Guardar especie como RawData
        final especieTemp = RawData(
          name: "Especie",
          valueString: resultado['especie'],
          timestamp: TemporalDateTime.now(),
        );

// Asociar con Tree
        final especieData = especieTemp.copyWith(tree: Tree(id: parcela.id, name: ''));

        await Amplify.DataStore.save(especieData);
        await _cargarParcelas();
      } catch (e) {
        safePrint('Error creando parcela: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<Map<String, String>?> _mostrarDialogoNuevaParcelaConEspecie(BuildContext context) async {
    final nombreController = TextEditingController();
    String? especieSeleccionada;

    return showDialog<Map<String, String>?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva parcela'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre de la parcela'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Especie',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Eucalipto', child: Text('Eucalipto')),
                      DropdownMenuItem(value: 'Pino Caribe', child: Text('Pino Caribe')),
                      DropdownMenuItem(value: 'Forestal Ornamental', child: Text('Forestal Ornamental')),
                    ],
                    value: especieSeleccionada,
                    onChanged: (val) => setState(() => especieSeleccionada = val),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (nombreController.text.trim().isEmpty || especieSeleccionada == null) {
                  return;
                }
                Navigator.pop(context, {
                  'nombre': nombreController.text.trim(),
                  'especie': especieSeleccionada!,
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcelas - ${_predioNombre ?? ''}'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Nueva parcela'),
              onPressed: () => _nuevaParcela(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text('Ver Registros Guardados'),
              onPressed: () {
                Navigator.pushNamed(context, '/registros');
              },
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Lista: Escoger parcela',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _parcelas.isEmpty
                ? const Center(child: Text('No hay parcelas'))
                : ListView.builder(
              itemCount: _parcelas.length,
              itemBuilder: (context, index) {
                final parcela = _parcelas[index];
                return ListTile(
                  title: Text(parcela.name.replaceAll("Parcela: ", "")),
                  subtitle: FutureBuilder<RawData?>(
                    future: _getEspecieFromParcela(parcela.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData && snapshot.data!.valueString != null) {
                          return Text('Especie: ${snapshot.data!.valueString}');
                        } else {
                          return const Text('Sin especie');
                        }
                      } else {
                        return const Text('Cargando especie...');
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/captura',
                      arguments: {
                        'parcela_id': parcela.id,
                        'parcela_nombre': parcela.name.replaceAll("Parcela: ", ""),
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<RawData?> _getEspecieFromParcela(String parcelaId) async {
    try {
      final resultados = await Amplify.DataStore.query(
        RawData.classType,
        where: RawData.TREE.eq(parcelaId) & RawData.NAME.eq("Especie"),
      );
      return resultados.isNotEmpty ? resultados.first : null;
    } catch (e) {
      safePrint('Error obteniendo especie: $e');
      return null;
    }
  }
}