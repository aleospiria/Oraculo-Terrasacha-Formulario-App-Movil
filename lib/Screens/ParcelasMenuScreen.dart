import 'package:flutter/material.dart';
import '../data/LocalDatabase.dart';

class ParcelasMenuScreen extends StatefulWidget {
  const ParcelasMenuScreen({super.key});

  @override
  State<ParcelasMenuScreen> createState() => _ParcelasMenuScreenState();
}

class _ParcelasMenuScreenState extends State<ParcelasMenuScreen> {
  List<Map<String, dynamic>> _parcelas = [];
  int? _predioLocalId;
  String? _predioNombre;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _predioLocalId = args['predio_local_id'];
      _predioNombre = args['predio_nombre'];
      _cargarParcelas();
    }
  }

  Future<void> _cargarParcelas() async {
    if (_predioLocalId == null) return;
    final parcelas = await LocalDatabase.instance.getParcelasByPredio(_predioLocalId!);
    setState(() {
      _parcelas = parcelas;
    });
  }

  Future<void> _nuevaParcela() async {
    final resultado = await _mostrarDialogoNuevaParcelaConEspecie(context);
    if (resultado != null && resultado['nombre']!.trim().isNotEmpty && resultado['especie'] != null && _predioLocalId != null) {
      await LocalDatabase.instance.insertParcela({
        'parcela_id': 'local-${DateTime.now().millisecondsSinceEpoch}',
        'nombre': resultado['nombre']!.trim(),
        'especie': resultado['especie']!,
        'poligono_geojson': '',
        'predio_id': '',
        'predio_local_id': _predioLocalId!,
      });
      await _cargarParcelas();
    }
  }

  Future<Map<String, String>?> _mostrarDialogoNuevaParcelaConEspecie(BuildContext context) async {
    final nombreController = TextEditingController();
    String? especieSeleccionada;

    return showDialog<Map<String, String>>(
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
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la parcela',
                    ),
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
                    validator: (val) => val == null ? 'Seleccione una especie' : null,
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
                  // Aquí puedes mostrar un mensaje de error si quieres
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
              onPressed: _nuevaParcela,
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
                  title: Text(parcela['nombre'] ?? 'Sin nombre'),
                  subtitle: Text('Especie: ${parcela['especie'] ?? 'No especificada'}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/captura',
                      arguments: {
                        'parcela_local_id': parcela['id'],
                        'parcela_nombre': parcela['nombre'],
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
}