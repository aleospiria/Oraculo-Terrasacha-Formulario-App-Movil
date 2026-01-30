// CapturaDatosScreen.dart
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/ModelProvider.dart';

class CapturaDatosScreen extends StatefulWidget {
  const CapturaDatosScreen({super.key});

  @override
  State<CapturaDatosScreen> createState() => _CapturaDatosScreenState();
}

class _CapturaDatosScreenState extends State<CapturaDatosScreen> {
  final _formKey = GlobalKey<FormState>();

  final _numArbolController = TextEditingController();
  final _diametroController = TextEditingController();
  final _alturaController = TextEditingController();
  final _observacionesController = TextEditingController();

  String? _coordenadas;
  String? _parcelaId; // Cambiado de int a String para usar ID de DataStore
  String? _parcelaNombre;
  String? _especie;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _parcelaId = args['parcela_id'] as String?; // Usar ID de DataStore
        _parcelaNombre = args['parcela_nombre'] as String?;

        // Cargar especie desde la parcela usando DataStore
        if (_parcelaId != null) {
          await _cargarEspecieDesdeParcela(_parcelaId!);
        }

        // Precargar datos si es edición (opcional)
        _numArbolController.text = (args['numArbol'] ?? '').toString();
        _diametroController.text = (args['diametro'] ?? '').toString();
        _alturaController.text = (args['altura'] ?? '').toString();
        _observacionesController.text = args['observaciones'] ?? '';
        _coordenadas = args['coordenadas'] ?? '';
      }
    });
  }

  Future<void> _cargarEspecieDesdeParcela(String parcelaId) async {
    try {
      // Buscar datos de especie relacionados con esta parcela
      final resultados = await Amplify.DataStore.query(
        RawData.classType,
        where: RawData.TREE.eq(parcelaId) & RawData.NAME.eq("Especie"),
      );

      if (resultados.isNotEmpty) {
        setState(() {
          _especie = resultados.first.valueString;
        });
      }
    } catch (e) {
      safePrint('Error cargando especie: $e');
    }
  }

  @override
  void dispose() {
    _numArbolController.dispose();
    _diametroController.dispose();
    _alturaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  void _obtenerCoordenadas() {
    setState(() {
      _coordenadas = "Lat: 4.12345, Lon: -74.12345";
    });
  }

  Future<void> _guardarBorrador() async {
    if (_formKey.currentState!.validate() && _parcelaId != null) {
      try {
        // Crear el árbol (Tree) con valores dummy para campos obligatorios
        final treeBase = Tree(
          name: 'Árbol ${_numArbolController.text}',
          status: 'pendiente',
        );

        // Asociar con la parcela usando copyWith
        final tree = treeBase.copyWith(
          project: Project(id: _parcelaId!, name: 'dummy', status: 'dummy')
        );

        await Amplify.DataStore.save(tree);

        // Crear RawData para cada medición
        final datos = <RawData>[
          RawData(
            name: 'Número de árbol',
            valueFloat: double.tryParse(_numArbolController.text) ?? 0,
            timestamp: TemporalDateTime.now(),
          ).copyWith(tree: Tree(id: tree.id, name: 'dummy')),

          RawData(
            name: 'Diámetro',
            valueFloat: double.tryParse(_diametroController.text) ?? 0,
            timestamp: TemporalDateTime.now(),
          ).copyWith(tree: Tree(id: tree.id, name: 'dummy')),

          RawData(
            name: 'Altura',
            valueFloat: double.tryParse(_alturaController.text) ?? 0,
            timestamp: TemporalDateTime.now(),
          ).copyWith(tree: Tree(id: tree.id, name: 'dummy')),
        ];

        // Guardar todos los RawData en paralelo
        await Future.wait(datos.map((dato) => Amplify.DataStore.save(dato)));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Borrador guardado con DataStore')),
        );
      } catch (e) {
        safePrint('Error guardando borrador: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _irARevision() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/revision', arguments: {
        'parcela_id': _parcelaId,
        'parcela_nombre': _parcelaNombre,
        'especie': _especie,
        'numArbol': _numArbolController.text,
        'diametro': _diametroController.text,
        'altura': _alturaController.text,
        'observaciones': _observacionesController.text,
        'coordenadas': _coordenadas,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Text('Parcela: $_parcelaNombre', style: Theme.of(context).textTheme.titleLarge),
              if (_especie != null)
                Text('Especie: $_especie', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

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