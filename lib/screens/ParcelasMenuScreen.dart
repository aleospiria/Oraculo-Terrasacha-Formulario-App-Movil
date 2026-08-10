import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../models/ModelProvider.dart';
import '../theme.dart';
import '../utils/servicio_topologia.dart';

/// Parcelas = topologías hijas de un predio (Topology con topologyParent = predio).
class ParcelasMenuScreen extends StatefulWidget {
  const ParcelasMenuScreen({super.key});

  @override
  State<ParcelasMenuScreen> createState() => _ParcelasMenuScreenState();
}

class _ParcelasMenuScreenState extends State<ParcelasMenuScreen> {
  List<Topology> _parcelas = [];
  bool _cargando = true;
  bool _isInitialized = false;
  String? _errorCarga;

  String _predioId = '';
  String _predioNombre = '';
  String _proyectoId = '';
  String _proyectoNombre = '';

  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;

    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    if (rawArgs is! Map) {
      _isInitialized = true;
      setState(() {
        _cargando = false;
        _errorCarga = 'No se recibieron datos del predio';
      });
      return;
    }

    final args = Map<String, dynamic>.from(rawArgs);
    _predioId = args['predio_id'] as String? ?? '';
    _predioNombre = args['predio_nombre'] as String? ?? 'Predio';
    _proyectoId = args['proyecto_id'] as String? ?? '';
    _proyectoNombre = args['proyecto_nombre'] as String? ?? 'Proyecto';
    _isInitialized = true;

    if (_predioId.isEmpty) {
      setState(() {
        _cargando = false;
        _errorCarga = 'ID de predio inválido';
      });
      return;
    }

    _cargarParcelas();
  }

  Future<void> _cargarParcelas() async {
    if (!mounted) return;
    setState(() {
      _cargando = true;
      _errorCarga = null;
    });

    try {
      // Cargar topologías del proyecto y tomar hijas del predio.
      final todas = _proyectoId.isNotEmpty
          ? await ServicioTopologia.cargarTopologiasPorProyecto(_proyectoId)
              .timeout(const Duration(seconds: 15), onTimeout: () => <Topology>[])
          : await ServicioTopologia.cargarTopologias()
              .timeout(const Duration(seconds: 15), onTimeout: () => <Topology>[]);

      final hijas = ServicioTopologia.hijosDe(todas, _predioId);

      if (!mounted) return;
      setState(() {
        _parcelas = hijas;
        _cargando = false;
      });
    } catch (e) {
      safePrint('Error cargando parcelas: $e');
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _errorCarga = 'No se pudieron cargar las parcelas';
      });
    }
  }

  Future<void> _nuevaParcela() async {
    final nombreCtrl = TextEditingController();
    final codigoCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva parcela'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              textCapitalization: terrasachaCapitalizacionTexto,
              inputFormatters: terrasachaFormattersTexto(),
              controller: nombreCtrl,
              autofocus: true,
              style: terrasachaInputTextStyle,
              decoration: const InputDecoration(
                labelText: 'Nombre de la parcela',
                hintText: 'Ej. Parcela Norte',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              textCapitalization: terrasachaCapitalizacionTexto,
              inputFormatters: terrasachaFormattersTexto(),
              controller: codigoCtrl,
              style: terrasachaInputTextStyle,
              decoration: const InputDecoration(
                labelText: 'Código (opcional)',
                hintText: 'Ej. P-01',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx, true);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;
    final nombre = nombreCtrl.text.trim();
    if (nombre.isEmpty) return;

    try {
      Project? project;
      if (_proyectoId.isNotEmpty) {
        final proyectos = await Amplify.DataStore.query(
          Project.classType,
          where: Project.ID.eq(_proyectoId),
        ).timeout(const Duration(seconds: 6), onTimeout: () => <Project>[]);
        if (proyectos.isNotEmpty) project = proyectos.first;
      }

      final predios = await Amplify.DataStore.query(
        Topology.classType,
        where: Topology.ID.eq(_predioId),
      ).timeout(const Duration(seconds: 6), onTimeout: () => <Topology>[]);

      if (predios.isEmpty) {
        throw Exception('Predio no encontrado en el dispositivo');
      }

      final parcela = Topology(
        name: nombre,
        string_code:
            codigoCtrl.text.trim().isEmpty ? null : codigoCtrl.text.trim(),
        status: 'active',
        project: project,
        topologyParent: predios.first,
      );

      await Amplify.DataStore.save(parcela);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parcela creada')),
      );
      await _cargarParcelas();
    } catch (e) {
      safePrint('Error creando parcela: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creando parcela: $e')),
      );
    }
  }

  Future<void> _eliminarParcela(Topology parcela) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar parcela'),
        content: Text('¿Eliminar "${parcela.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    try {
      await Amplify.DataStore.delete(parcela);
      await _cargarParcelas();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parcela eliminada')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error eliminando: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parcelas',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              _predioNombre,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: primaryColor),
            onPressed: _cargando ? null : _cargarParcelas,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nuevaParcela,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Nueva parcela'),
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _errorCarga != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _errorCarga!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _cargarParcelas,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: primaryColor,
                  onRefresh: _cargarParcelas,
                  child: _parcelas.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: Text(
                                  'No hay parcelas en este predio.\nCrea una con el botón +.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                          itemCount: _parcelas.length,
                          itemBuilder: (context, index) {
                            final parcela = _parcelas[index];
                            return _buildParcelaCard(parcela);
                          },
                        ),
                ),
    );
  }

  Widget _buildParcelaCard(Topology parcela) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: terrasachaCardColor,
          child: Icon(Icons.grid_view_rounded, color: primaryColor),
        ),
        title: Text(
          parcela.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          [
            if (parcela.string_code != null && parcela.string_code!.isNotEmpty)
              parcela.string_code!,
            if (parcela.status != null) parcela.status!,
          ].join(' · '),
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: () => _eliminarParcela(parcela),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/trees',
            arguments: {
              'proyecto_id': _proyectoId,
              'proyecto_nombre': _proyectoNombre,
              'parcela_id': parcela.id,
              'parcela_nombre': parcela.name,
              'predio_id': _predioId,
              'predio_nombre': _predioNombre,
            },
          );
        },
      ),
    );
  }
}
