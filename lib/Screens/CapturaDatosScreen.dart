import 'package:flutter/material.dart';
import '../data/LocalDataBase.dart';

class CapturaDatosScreen extends StatefulWidget {
  const CapturaDatosScreen({super.key});

  @override
  State<CapturaDatosScreen> createState() => _CapturaDatosScreenState();
}

class _CapturaDatosScreenState extends State<CapturaDatosScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _especie;
  final _numArbolController = TextEditingController();
  final _diametroController = TextEditingController();
  final _alturaController = TextEditingController();
  final _observacionesController = TextEditingController();

  String? _coordenadas;

  int? _registroId;

  @override
  void dispose() {
    _numArbolController.dispose();
    _diametroController.dispose();
    _alturaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  void _obtenerCoordenadas() {
    // Aquí iría la lógica para obtener coordenadas GPS
    setState(() {
      _coordenadas = "Lat: 4.12345, Lon: -74.12345"; // Ejemplo fijo
    });
  }
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _registroId = args['id'] as int?;
        setState(() {
          _especie = args['especie'] as String?;
          _numArbolController.text = (args['numArbol'] ?? '').toString();
          _diametroController.text = (args['diametro'] ?? '').toString();
          _alturaController.text = (args['altura'] ?? '').toString();
          _observacionesController.text = args['observaciones'] ?? '';
          _coordenadas = args['coordenadas'] ?? '';
        });
      }
    });
  }

  Future<void> _guardarBorrador() async {
    if (_formKey.currentState!.validate()) {
      final registro = {
        'especie': _especie,
        'numArbol': int.tryParse(_numArbolController.text) ?? 0,
        'diametro': double.tryParse(_diametroController.text) ?? 0.0,
        'altura': double.tryParse(_alturaController.text) ?? 0.0,
        'observaciones': _observacionesController.text,
        'coordenadas': _coordenadas ?? '',
        'estado': 'pendiente',
      };

      if (_registroId != null) {
        await LocalDatabase.instance.updateRegistro(_registroId!, registro);
      } else {
        await LocalDatabase.instance.insertRegistro(registro);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Borrador guardado localmente')),
      );
    }
  }

  void _irARevision() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/revision', arguments: {
        'id': _registroId,
        'especie': _especie,
        'numArbol': _numArbolController.text,
        'diametro': _diametroController.text,
        'altura': _alturaController.text,
        'observaciones': _observacionesController.text,
        'coordenadas': _coordenadas,
        'estado': 'pendiente',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final proyecto = args?['proyecto'] ?? 'Proyecto';
    final parcela = args?['parcela'] ?? 'Parcela';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura de datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Proyecto: $proyecto', style: Theme.of(context).textTheme.titleLarge),
              Text('Parcela: $parcela', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              // Selección de especie
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
                value: _especie,
                onChanged: (val) => setState(() => _especie = val),
                validator: (val) => val == null ? 'Seleccione una especie' : null,
              ),
              const SizedBox(height: 16),

              // Número de árbol
              TextFormField(
                controller: _numArbolController,
                decoration: const InputDecoration(
                  labelText: 'Número de árbol',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Ingrese número de árbol';
                  if (int.tryParse(val) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Diámetro Altura Pecho (cm)
              TextFormField(
                controller: _diametroController,
                decoration: const InputDecoration(
                  labelText: 'Diámetro Altura Pecho (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Ingrese diámetro';
                  if (double.tryParse(val) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Altura Comercial (m)
              TextFormField(
                controller: _alturaController,
                decoration: const InputDecoration(
                  labelText: 'Altura Comercial (m)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Ingrese altura';
                  if (double.tryParse(val) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Observaciones
              TextFormField(
                controller: _observacionesController,
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Coordenadas
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _coordenadas ?? 'Coordenadas no obtenidas',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.gps_fixed),
                    label: const Text('Obtener coordenadas'),
                    onPressed: _obtenerCoordenadas,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _guardarBorrador,
                    child: const Text('Guardar borrador'),
                  ),
                  ElevatedButton(
                    onPressed: _irARevision,
                    child: const Text('Revisar y enviar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}