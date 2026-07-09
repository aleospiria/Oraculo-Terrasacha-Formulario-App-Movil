import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/checklist_salida_ejecucion.dart';
import '../models/lista_chequeo.dart';
import '../models/plan_campo_borrador.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_checklist_salida.dart';
import '../utils/servicio_salida.dart';

/// Pantalla de checklist de salida con evidencia global, gestionada por el
/// líder de cuadrilla.
class ChecklistSalidaScreen extends StatefulWidget {
  final String salidaId;
  final ChecklistPlanAsignado checklist;
  final bool editable;

  const ChecklistSalidaScreen({
    super.key,
    required this.salidaId,
    required this.checklist,
    this.editable = true,
  });

  @override
  State<ChecklistSalidaScreen> createState() => _ChecklistSalidaScreenState();
}

class _ChecklistSalidaScreenState extends State<ChecklistSalidaScreen> {
  static const Color primaryColor = Color(0xFF4A5C24);
  static const Color backgroundColor = Color(0xFFF7F8F6);

  final _picker = ImagePicker();
  late final TextEditingController _obsCtrl;

  final Map<String, bool> _itemsCompletados = {};
  List<EvidenciaChecklistSalida> _evidencias = [];
  bool _completado = false;
  String? _completadoPorNombre;
  DateTime? _completadoEn;

  bool _cargando = true;
  bool _guardando = false;

  bool get _soloLectura => !widget.editable || _completado;

  @override
  void initState() {
    super.initState();
    _obsCtrl = TextEditingController();
    _cargar();
  }

  @override
  void dispose() {
    _obsCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final ejecucion = await ServicioSalida.obtenerEjecucion(widget.salidaId);

    for (final item in widget.checklist.items) {
      final match = ejecucion.checklistItems.where((c) => c.itemId == item.id);
      _itemsCompletados[item.id] =
          match.isNotEmpty ? match.first.completado : false;
    }

    _evidencias = List<EvidenciaChecklistSalida>.from(
      ejecucion.checklistEvidencias,
    );
    _obsCtrl.text = ejecucion.checklistObservaciones;
    _completado = ejecucion.checklistCompletado;
    _completadoPorNombre = ejecucion.checklistCompletadoPorNombre;
    _completadoEn = ejecucion.checklistCompletadoEn;

    if (mounted) setState(() => _cargando = false);
  }

  List<ChecklistItemEjecucionSalida> _construirItems() {
    return widget.checklist.items
        .map(
          (item) => ChecklistItemEjecucionSalida(
            itemId: item.id,
            completado: _itemsCompletados[item.id] ?? false,
          ),
        )
        .toList();
  }

  Future<void> _persistir({
    required bool completado,
  }) async {
    final usuario = await servicioAutenticacion.getUsuarioActual();
    await ServicioSalida.guardarChecklistEjecucion(
      salidaId: widget.salidaId,
      items: _construirItems(),
      evidencias: _evidencias,
      observaciones: _obsCtrl.text.trim(),
      completado: completado,
      completadoPorNombre: usuario?.nombre ?? 'Líder de cuadrilla',
      completadoPorUserId: usuario?.id,
    );
  }

  Future<void> _agregarEvidencia(ImageSource source) async {
    try {
      final XFile? archivo = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (archivo == null) return;
      final evidencia = await ServicioChecklistSalida.guardarEvidencia(
        rutaOrigen: archivo.path,
      );
      if (!mounted) return;
      setState(() => _evidencias = [..._evidencias, evidencia]);
    } catch (e) {
      if (!mounted) return;
      _snack('No se pudo adjuntar la evidencia: $e');
    }
  }

  Future<void> _mostrarOpcionesEvidencia() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined,
                  color: primaryColor),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(ctx);
                _agregarEvidencia(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: primaryColor),
              title: const Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(ctx);
                _agregarEvidencia(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _eliminarEvidencia(EvidenciaChecklistSalida evidencia) async {
    await ServicioChecklistSalida.eliminarArchivo(evidencia.rutaLocal);
    if (!mounted) return;
    setState(
      () => _evidencias =
          _evidencias.where((e) => e.id != evidencia.id).toList(),
    );
  }

  String? _validarParaCompletar() {
    final pendientes = widget.checklist.items
        .where((i) => !(_itemsCompletados[i.id] ?? false))
        .toList();
    if (pendientes.isNotEmpty) {
      return 'Marca todos los ítems del checklist';
    }
    if (_evidencias.isEmpty) {
      return 'Adjunta al menos una evidencia (foto)';
    }
    return null;
  }

  Future<void> _guardarBorrador() async {
    setState(() => _guardando = true);
    try {
      await _persistir(completado: false);
      if (!mounted) return;
      setState(() => _guardando = false);
      _snack('Borrador guardado');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      _snack('No se pudo guardar: $e');
    }
  }

  Future<void> _completarChecklist() async {
    final error = _validarParaCompletar();
    if (error != null) {
      _snack(error);
      return;
    }

    setState(() => _guardando = true);
    try {
      for (final item in widget.checklist.items) {
        _itemsCompletados[item.id] = true;
      }
      await _persistir(completado: true);
      if (!mounted) return;
      setState(() {
        _guardando = false;
        _completado = true;
        _completadoEn = DateTime.now();
      });
      _snack('Checklist completado');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      _snack('No se pudo completar el checklist: $e');
    }
  }

  void _snack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor, size: 18),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          widget.checklist.nombre,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_completado) _buildBannerCompletado(),
                if (_completado) const SizedBox(height: 12),
                _buildSeccionItems(),
                const SizedBox(height: 12),
                _buildSeccionObservaciones(),
                const SizedBox(height: 12),
                _buildSeccionEvidencias(),
                const SizedBox(height: 24),
                if (!_soloLectura) _buildBotones(),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildBannerCompletado() {
    final fecha = _completadoEn;
    final fechaTexto = fecha == null
        ? ''
        : '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Checklist completado',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                if (_completadoPorNombre != null)
                  Text(
                    'Por $_completadoPorNombre${fechaTexto.isNotEmpty ? ' · $fechaTexto' : ''}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccion({
    required String titulo,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSeccionItems() {
    return _buildSeccion(
      titulo: 'Ítems del checklist',
      child: Column(
        children: widget.checklist.items.map(_buildFilaItem).toList(),
      ),
    );
  }

  Widget _buildFilaItem(ItemListaChequeo item) {
    final marcado = _itemsCompletados[item.id] ?? false;

    return CheckboxListTile(
      value: marcado,
      onChanged: _soloLectura
          ? null
          : (v) => setState(() => _itemsCompletados[item.id] = v ?? false),
      title: Text(item.titulo),
      subtitle: item.descripcion.isNotEmpty ? Text(item.descripcion) : null,
      activeColor: primaryColor,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSeccionObservaciones() {
    return _buildSeccion(
      titulo: 'Observaciones',
      child: TextField(
        controller: _obsCtrl,
        enabled: !_soloLectura,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: 'Notas adicionales (opcional)',
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSeccionEvidencias() {
    return _buildSeccion(
      titulo: 'Evidencias de la salida',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_soloLectura)
            OutlinedButton.icon(
              onPressed: _mostrarOpcionesEvidencia,
              icon: const Icon(Icons.add_a_photo_outlined, color: primaryColor),
              label: const Text(
                'Agregar foto',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          if (_evidencias.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Sin evidencias adjuntas',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            )
          else ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _evidencias.map(_buildMiniaturaEvidencia).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniaturaEvidencia(EvidenciaChecklistSalida evidencia) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(evidencia.rutaLocal),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 90,
              height: 90,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
            ),
          ),
        ),
        if (!_soloLectura)
          Positioned(
            right: 2,
            top: 2,
            child: GestureDetector(
              onTap: () => _eliminarEvidencia(evidencia),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBotones() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _guardando ? null : _completarChecklist,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Completar checklist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _guardando ? null : _guardarBorrador,
            icon: const Icon(Icons.save_outlined, color: primaryColor),
            label: const Text(
              'Guardar borrador',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
