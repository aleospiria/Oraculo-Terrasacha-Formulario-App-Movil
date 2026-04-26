// lib/screens/PrediosMenuScreen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:capturador_datos_offline/models/ModelProvider.dart';
import 'package:capturador_datos_offline/models/Topology.dart';
import 'package:capturador_datos_offline/models/Project.dart';

class PrediosMenuScreen extends StatefulWidget {
  const PrediosMenuScreen({super.key});

  @override
  State<PrediosMenuScreen> createState() => _PrediosMenuScreenState();
}

class _PrediosMenuScreenState extends State<PrediosMenuScreen> {
  List<Topology> predios = [];
  Map<String, int> _parcelasCount = {};
  bool cargando = true;
  bool _isInitialized = false;

  late String proyectoId;
  late String proyectoNombre;

  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);

  final TextEditingController _searchController = TextEditingController();
  String _filtro = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      proyectoId = args['proyecto_id'];
      proyectoNombre = args['proyecto_nombre'] ?? 'Proyecto';
      _isInitialized = true;
      _cargarPredios();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarPredios({int intentos = 0}) async {
    if (!mounted) return;
    setState(() => cargando = true);

    try {
      // DEBUG: trae TODO sin filtro para ver qué hay en la DB local
      final todas = await Amplify.DataStore.query(Topology.classType);
      debugPrint('🔍 Total topologías en DB local: ${todas.length}');
      for (final t in todas) {
        debugPrint('  → ${t.name} | project.id: ${t.project?.id} | parent: ${t.topologyParent?.id}');
      }

      final roots = todas
          .where((t) => t.project?.id == proyectoId && t.topologyParent == null)
          .toList();
      debugPrint('🌳 Predios raíz para proyecto $proyectoId: ${roots.length}');

      if (roots.isEmpty && intentos < 5) {
        final espera = Duration(seconds: intentos + 1);
        debugPrint('⏳ Reintentando en ${espera.inSeconds}s (intento ${intentos + 1}/5)');
        await Future.delayed(espera);
        return _cargarPredios(intentos: intentos + 1);
      }

      final Map<String, int> counts = {};
      for (final predio in roots) {
        final hijos = await Amplify.DataStore.query(
          Topology.classType,
          where: Topology.TOPOLOGYPARENT.eq(predio.id),
        );
        counts[predio.id] = hijos.length;
      }

      if (!mounted) return;
      setState(() {
        predios = roots;
        _parcelasCount = counts;
        cargando = false;
      });
    } catch (e) {
      debugPrint('❌ Error cargando predios: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  Future<void> _crearPredio() async {
    final nombreCtrl = TextEditingController();
    final stringCodeCtrl = TextEditingController();
    final numberCodeCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Predio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nombre *',
                hintText: 'Ej: NAVAJAS',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: stringCodeCtrl,
              decoration: const InputDecoration(
                labelText: 'Código texto',
                hintText: 'Ej: NVJ',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: numberCodeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Código número',
                hintText: 'Ej: 1001',
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
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result != true) return;
    final nombre = nombreCtrl.text.trim();
    if (nombre.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre es obligatorio')),
        );
      }
      return;
    }

    try {
      final proyectos = await Amplify.DataStore.query(
        Project.classType,
        where: Project.ID.eq(proyectoId),
      );
      if (proyectos.isEmpty) throw Exception('Proyecto no encontrado');

      final nuevo = Topology(
        name: nombre,
        string_code: stringCodeCtrl.text.trim().isEmpty
            ? null
            : stringCodeCtrl.text.trim(),
        number_code: numberCodeCtrl.text.trim().isEmpty
            ? null
            : numberCodeCtrl.text.trim(),
        status: 'active',
        project: proyectos.first,
      );

      await Amplify.DataStore.save(nuevo);
      debugPrint('Predio creado: ${nuevo.id}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Predio creado')),
        );
      }
      _cargarPredios();
    } catch (e) {
      debugPrint('Error creando predio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error creando predio')),
        );
      }
    }
  }

  Future<void> _borrarPredio(Topology predio) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Eliminar predio'),
        content: Text('¿Eliminar "${predio.name}"? También se perderán sus parcelas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Sí, eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await Amplify.DataStore.delete(predio);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Predio eliminado')),
        );
      }
    } catch (e) {
      debugPrint('Error borrando predio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error eliminando predio')),
        );
      }
    }
  }

  List<Topology> get _prediosFiltrados {
    if (_filtro.isEmpty) return predios;
    final q = _filtro.toLowerCase();
    return predios
        .where((p) =>
    (p.name ?? '').toLowerCase().contains(q) ||
        (p.string_code ?? '').toLowerCase().contains(q) ||
        (p.number_code ?? '').toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = _prediosFiltrados;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP BAR ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proyectoNombre,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${predios.length} predio${predios.length != 1 ? 's' : ''}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),

            // ── BUSCADOR ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _filtro = v.trim()),
                decoration: InputDecoration(
                  hintText: 'Buscar predios...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _filtro.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _filtro = '');
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // ── HEADER ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _filtro.isNotEmpty
                        ? 'Resultados (${filtrados.length})'
                        : 'Predios',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                    ),
                    onPressed: _crearPredio,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Nuevo Predio'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── LISTA ─────────────────────────────────────────────
            Expanded(
              child: cargando
                  ? Center(
                  child: CircularProgressIndicator(color: primaryColor))
                  : filtrados.isEmpty
                  ? Center(
                child: Text(
                  _filtro.isNotEmpty
                      ? 'No se encontraron predios con ese criterio'
                      : 'No hay predios en este proyecto',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              )
                  : RefreshIndicator(
                onRefresh: _cargarPredios,
                child: ListView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ...filtrados.map((p) => _buildPredioCard(p)),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredioCard(Topology predio) {
    final status = (predio.status ?? 'active').toLowerCase();
    final parcelas = _parcelasCount[predio.id] ?? 0;
    final Color statusColor =
    status == 'active' ? primaryColor : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/parcelas',
            arguments: {
              'predio_id': predio.id,
              'predio_nombre': predio.name,
              'proyecto_id': proyectoId,
              'proyecto_nombre': proyectoNombre,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      predio.name ?? 'Sin nombre',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (predio.string_code != null) ...[
                    _buildChip(Icons.code, predio.string_code!, Colors.blueGrey),
                    const SizedBox(width: 8),
                  ],
                  if (predio.number_code != null)
                    _buildChip(
                        Icons.tag, predio.number_code!, Colors.blueGrey.shade300),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.grid_view_rounded,
                          size: 15, color: primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        '$parcelas parcela${parcelas != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _borrarPredio(predio),
                        child: const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.grey.shade400),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}