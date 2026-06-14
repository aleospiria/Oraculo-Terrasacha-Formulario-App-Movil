import 'package:flutter/material.dart';
import '../models/reporte_accidente.dart';
import '../utils/servicio_accidentes.dart';

class RegistroIncidenciaScreen extends StatefulWidget {
  const RegistroIncidenciaScreen({super.key});

  @override
  State<RegistroIncidenciaScreen> createState() => _RegistroIncidenciaScreenState();
}

class _RegistroIncidenciaScreenState extends State<RegistroIncidenciaScreen> {
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);
  final ServicioAccidentes _servicio = ServicioAccidentes();

  List<ReporteAccidente> _reportes = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final reportes = await _servicio.listar();
    if (!mounted) return;
    setState(() {
      _reportes = reportes;
      _cargando = false;
    });
  }

  Future<void> _eliminar(ReporteAccidente r) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar reporte'),
        content: Text('¿Eliminar reporte de ${r.trabajadorNombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _servicio.eliminar(r.id);
      _cargar();
    }
  }

  String _fechaFormateada(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registro de Accidentes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _reportes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield_outlined, size: 72, color: primaryColor.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text('Sin reportes de accidentes', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Toca el botón + para crear uno', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _reportes.length,
                    itemBuilder: (ctx, i) {
                      final r = _reportes[i];
                      return _buildCard(r);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () async {
          final resultado = await Navigator.pushNamed(context, '/reportar-incidencia');
          if (resultado == true) _cargar();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCard(ReporteAccidente r) {
    return Dismissible(
      key: Key(r.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _eliminar(r),
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, '/reportar-incidencia', arguments: r.id);
          _cargar();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 5, decoration: BoxDecoration(
                  color: r.accidenteIncapacidad ? Colors.redAccent : primaryColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(r.trabajadorNombre.isNotEmpty ? r.trabajadorNombre : 'Sin nombre',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Text(_fechaFormateada(r.accidenteFecha),
                                style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.work_outline, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(r.trabajadorCargo.isNotEmpty ? r.trabajadorCargo : 'Sin cargo',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.category_outlined, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(r.accidenteTipo.isNotEmpty ? r.accidenteTipo : 'Sin tipo',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                            ),
                          ],
                        ),
                        if (r.accidenteDescripcion.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(r.accidenteDescripcion, maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[500], fontSize: 12, height: 1.3)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
