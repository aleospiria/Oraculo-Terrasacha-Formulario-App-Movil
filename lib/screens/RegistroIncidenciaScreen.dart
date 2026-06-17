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
  final Set<String> _seleccionados = {};

  bool get _modoSeleccion => _seleccionados.isNotEmpty;
  bool get _todosSeleccionados =>
      _reportes.isNotEmpty && _seleccionados.length == _reportes.length;

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
      _seleccionados.clear();
    });
  }

  void _toggleUno(String id) {
    setState(() {
      if (_seleccionados.contains(id)) {
        _seleccionados.remove(id);
      } else {
        _seleccionados.add(id);
      }
    });
  }

  void _toggleTodos() {
    setState(() {
      if (_todosSeleccionados) {
        _seleccionados.clear();
      } else {
        _seleccionados.addAll(_reportes.map((r) => r.id));
      }
    });
  }

  void _salirSeleccion() {
    setState(() => _seleccionados.clear());
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
        leading: _modoSeleccion
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _salirSeleccion,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
        title: _modoSeleccion
            ? Text(
                '${_seleccionados.length} seleccionado${_seleccionados.length != 1 ? 's' : ''}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              )
            : const Text(
                'Registro de Accidentes',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
        actions: _modoSeleccion
            ? [
                TextButton.icon(
                  onPressed: _toggleTodos,
                  icon: Icon(
                    _todosSeleccionados ? Icons.deselect : Icons.select_all,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    _todosSeleccionados ? 'Ninguno' : 'Todos',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ]
            : null,
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
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                          itemCount: _reportes.length,
                          itemBuilder: (ctx, i) {
                            final r = _reportes[i];
                            return _buildCard(r);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: _modoSeleccion
          ? null
          : FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () async {
                final resultado = await Navigator.pushNamed(context, '/reportar-incidencia');
                if (resultado == true) _cargar();
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
      bottomNavigationBar: _modoSeleccion
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -2))],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _eliminarSeleccionados,
                        icon: const Icon(Icons.delete_outline, size: 20),
                        label: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () => _exportarSeleccionados(),
                        icon: const Icon(Icons.download, size: 20),
                        label: const Text('Exportar', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  void _eliminarSeleccionados() async {
    if (_seleccionados.isEmpty) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar reportes'),
        content: Text('¿Eliminar ${_seleccionados.length} reporte${_seleccionados.length != 1 ? 's' : ''}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar todo', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      for (final id in _seleccionados.toList()) {
        await _servicio.eliminar(id);
      }
      _cargar();
    }
  }

  void _exportarSeleccionados() {
    // TODO: implementar lógica de exportación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Exportar ${_seleccionados.length} reporte${_seleccionados.length != 1 ? 's' : ''} (próximamente)',
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCard(ReporteAccidente r) {
    final seleccionado = _seleccionados.contains(r.id);

    return GestureDetector(
      onTap: () {
        if (_modoSeleccion) {
          _toggleUno(r.id);
        } else {
          Navigator.pushNamed(context, '/reportar-incidencia', arguments: r.id).then((_) => _cargar());
        }
      },
      onLongPress: () {
        if (!_modoSeleccion) _toggleUno(r.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: seleccionado ? primaryColor.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: seleccionado ? Border.all(color: primaryColor.withOpacity(0.3), width: 1.5) : null,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (_modoSeleccion)
                SizedBox(
                  width: 48,
                  child: Center(
                    child: Checkbox(
                      value: seleccionado,
                      onChanged: (_) => _toggleUno(r.id),
                      activeColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: r.accidenteIncapacidad ? Colors.redAccent : primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: _modoSeleccion ? Radius.zero : const Radius.circular(14),
                    bottomLeft: _modoSeleccion ? Radius.zero : const Radius.circular(14),
                  ),
                ),
              ),
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
                            child: Text(
                              r.trabajadorNombre.isNotEmpty ? r.trabajadorNombre : 'Sin nombre',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
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
    );
  }
}
