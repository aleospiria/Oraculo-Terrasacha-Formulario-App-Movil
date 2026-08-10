import '../theme.dart';
// lib/screens/ChequeoVehiculoScreen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../models/chequeo_vehiculo.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_chequeo_vehiculo.dart';
import '../utils/servicio_salida.dart';

/// Pantalla de chequeo de transporte para el líder de cuadrilla.
///
/// Permite clonar el último chequeo, revalidar la licencia del conductor,
/// adjuntar evidencia multimedia y firmar antes de completar.
class ChequeoVehiculoScreen extends StatefulWidget {
  final String salidaId;
  final bool editable;

  const ChequeoVehiculoScreen({
    super.key,
    required this.salidaId,
    this.editable = true,
  });

  @override
  State<ChequeoVehiculoScreen> createState() => _ChequeoVehiculoScreenState();
}

class _ChequeoVehiculoScreenState extends State<ChequeoVehiculoScreen> {
  static const Color primaryColor = terrasachaPrimaryColor;
  static const Color backgroundColor = terrasachaBackgroundColor;

  final _picker = ImagePicker();
  final SignatureController _firmaCtrl = SignatureController(
    penStrokeWidth: 2.5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  late final TextEditingController _placaCtrl;
  late final TextEditingController _marcaCtrl;
  late final TextEditingController _conductorCtrl;
  late final TextEditingController _licenciaCtrl;
  late final TextEditingController _obsCtrl;

  bool _aplicaTransporte = true;
  String? _categoria;
  DateTime? _vencimiento;
  List<ItemChequeoTransporte> _items = [];
  List<EvidenciaChequeoVehiculo> _evidencias = [];
  FirmaChequeoVehiculo? _firmaExistente;

  String? _chequeoId;
  String? _clonadoDesdeId;
  DateTime? _creadoEn;

  bool _cargando = true;
  bool _guardando = false;

  bool get _soloLectura => !widget.editable;

  @override
  void initState() {
    super.initState();
    _placaCtrl = TextEditingController();
    _marcaCtrl = TextEditingController();
    _conductorCtrl = TextEditingController();
    _licenciaCtrl = TextEditingController();
    _obsCtrl = TextEditingController();
    _cargar();
  }

  @override
  void dispose() {
    _placaCtrl.dispose();
    _marcaCtrl.dispose();
    _conductorCtrl.dispose();
    _licenciaCtrl.dispose();
    _obsCtrl.dispose();
    _firmaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final existente =
        await ServicioSalida.obtenerChequeoVehiculo(widget.salidaId);
    final chequeo = existente ?? ServicioChequeoVehiculo.nuevo(widget.salidaId);
    _hidratar(chequeo);
    if (mounted) setState(() => _cargando = false);
  }

  void _hidratar(ChequeoVehiculoSalida chequeo) {
    _chequeoId = chequeo.id;
    _clonadoDesdeId = chequeo.clonadoDesdeId;
    _creadoEn = chequeo.creadoEn;
    _aplicaTransporte = chequeo.aplicaTransporte;
    _placaCtrl.text = chequeo.placa;
    _marcaCtrl.text = chequeo.marcaModelo ?? '';
    _conductorCtrl.text = chequeo.conductor.nombre;
    _licenciaCtrl.text = chequeo.conductor.numeroLicencia;
    _categoria = chequeo.conductor.categoriaLicencia.trim().isEmpty
        ? null
        : chequeo.conductor.categoriaLicencia.trim().toUpperCase();
    _vencimiento = chequeo.conductor.vencimientoLicencia;
    _obsCtrl.text = chequeo.observaciones;
    _items = chequeo.items.isNotEmpty
        ? chequeo.items
        : ServicioChequeoVehiculo.plantillaItems();
    _evidencias = List<EvidenciaChequeoVehiculo>.from(chequeo.evidencias);
    _firmaExistente = chequeo.firma;
  }

  ConductorVehiculo _conductorActual() => ConductorVehiculo(
        nombre: _conductorCtrl.text.trim(),
        numeroLicencia: _licenciaCtrl.text.trim(),
        categoriaLicencia: _categoria ?? '',
        vencimientoLicencia: _vencimiento,
      );

  ChequeoVehiculoSalida _construir({
    required bool completado,
    FirmaChequeoVehiculo? firma,
  }) {
    final ahora = DateTime.now();
    return ChequeoVehiculoSalida(
      id: _chequeoId ?? ServicioChequeoVehiculo.generarId(),
      salidaId: widget.salidaId,
      aplicaTransporte: _aplicaTransporte,
      placa: _placaCtrl.text.trim().toUpperCase(),
      marcaModelo:
          _marcaCtrl.text.trim().isEmpty ? null : _marcaCtrl.text.trim(),
      conductor: _conductorActual(),
      items: _items,
      observaciones: _obsCtrl.text.trim(),
      evidencias: _evidencias,
      firma: firma ?? _firmaExistente,
      clonadoDesdeId: _clonadoDesdeId,
      completado: completado,
      creadoEn: _creadoEn ?? ahora,
      actualizadoEn: ahora,
      completadoEn: completado ? ahora : null,
    );
  }

  // ── Acciones ────────────────────────────────────────────────────────────

  Future<void> _usarUltimoChequeo() async {
    final placa = _placaCtrl.text.trim();
    final ultimo = await ServicioChequeoVehiculo.obtenerUltimoCompletado(
      placa: placa.isEmpty ? null : placa,
    );
    if (!mounted) return;
    if (ultimo == null) {
      _snack('No hay chequeos anteriores para clonar');
      return;
    }
    final clon = ServicioChequeoVehiculo.clonarDesde(
      ultimo,
      salidaId: widget.salidaId,
    );
    setState(() => _hidratar(clon));
    _snack('Chequeo anterior cargado. Revisa y actualiza los datos.');
  }

  Future<void> _seleccionarVencimiento() async {
    final ahora = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: _vencimiento ?? ahora,
      firstDate: DateTime(ahora.year - 5),
      lastDate: DateTime(ahora.year + 15),
    );
    if (fecha != null) setState(() => _vencimiento = fecha);
  }

  Future<void> _agregarEvidencia(ImageSource source) async {
    try {
      final XFile? archivo = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (archivo == null) return;
      final evidencia = await ServicioChequeoVehiculo.guardarEvidencia(
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
              leading:
                  const Icon(Icons.photo_library_outlined, color: primaryColor),
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

  Future<void> _eliminarEvidencia(EvidenciaChequeoVehiculo evidencia) async {
    await ServicioChequeoVehiculo.eliminarArchivo(evidencia.rutaLocal);
    if (!mounted) return;
    setState(
      () => _evidencias =
          _evidencias.where((e) => e.id != evidencia.id).toList(),
    );
  }

  Future<void> _guardarBorrador() async {
    setState(() => _guardando = true);
    final chequeo = _construir(completado: false);
    await ServicioSalida.guardarChequeoVehiculo(
      salidaId: widget.salidaId,
      chequeo: chequeo,
    );
    if (!mounted) return;
    setState(() {
      _guardando = false;
      _chequeoId = chequeo.id;
    });
    _snack('Borrador guardado');
    Navigator.pop(context, true);
  }

  String? _validarParaCompletar() {
    if (!_aplicaTransporte) return null;
    if (_placaCtrl.text.trim().isEmpty) return 'Ingresa la placa del vehículo';

    final errorLicencia =
        ServicioChequeoVehiculo.validarLicencia(_conductorActual());
    if (errorLicencia != null) return errorLicencia;

    if (_items.any((i) => i.respuesta == null)) {
      return 'Responde todos los ítems del chequeo';
    }
    final conductorAutorizado = _items.firstWhere(
      (i) => i.id == 'transporte_01',
      orElse: () => _items.first,
    );
    if (conductorAutorizado.respuesta == RespuestaItemTransporte.no) {
      return 'El conductor no está autorizado; no se puede completar';
    }
    if (_evidencias.isEmpty) {
      return 'Adjunta al menos una evidencia (foto)';
    }
    if (_firmaExistente == null && _firmaCtrl.isEmpty) {
      return 'La firma es obligatoria para completar el chequeo';
    }
    return null;
  }

  Future<void> _firmarYCompletar() async {
    final error = _validarParaCompletar();
    if (error != null) {
      _snack(error);
      return;
    }

    setState(() => _guardando = true);
    try {
      FirmaChequeoVehiculo? firma = _firmaExistente;

      if (_firmaCtrl.isNotEmpty) {
        final bytes = await _firmaCtrl.toPngBytes();
        if (bytes == null) {
          setState(() => _guardando = false);
          _snack('No se pudo procesar la firma');
          return;
        }
        final ruta = await ServicioChequeoVehiculo.guardarFirmaPng(bytes);
        final usuario = await servicioAutenticacion.getUsuarioActual();
        firma = FirmaChequeoVehiculo(
          rutaImagenLocal: ruta,
          firmadoPorNombre: usuario?.nombre ?? 'Líder de cuadrilla',
          firmadoPorUserId: usuario?.id,
          firmadoEn: DateTime.now(),
        );
      }

      final chequeo = _construir(completado: true, firma: firma);
      await ServicioSalida.guardarChequeoVehiculo(
        salidaId: widget.salidaId,
        chequeo: chequeo,
      );
      await ServicioChequeoVehiculo.registrarEnHistorial(chequeo);

      if (!mounted) return;
      setState(() => _guardando = false);
      _snack('Chequeo de transporte completado');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      _snack('No se pudo completar el chequeo: $e');
    }
  }

  void _snack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), behavior: SnackBarBehavior.floating),
    );
  }

  // ── UI ────────────────────────────────────────────────────────────────────

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
        title: const Text(
          'Chequeo de transporte',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          if (!_soloLectura)
            TextButton.icon(
              onPressed: _guardando ? null : _usarUltimoChequeo,
              icon: const Icon(Icons.content_copy, size: 18, color: primaryColor),
              label: const Text(
                'Usar último',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildToggleTransporte(),
                if (_aplicaTransporte) ...[
                  const SizedBox(height: 12),
                  _buildSeccionVehiculo(),
                  const SizedBox(height: 12),
                  _buildSeccionConductor(),
                  const SizedBox(height: 12),
                  _buildSeccionItems(),
                  const SizedBox(height: 12),
                  _buildSeccionObservaciones(),
                  const SizedBox(height: 12),
                  _buildSeccionEvidencias(),
                  const SizedBox(height: 12),
                  _buildSeccionFirma(),
                ],
                const SizedBox(height: 24),
                if (!_soloLectura) _buildBotones(),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildSeccion({required String titulo, required Widget child}) {
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

  InputDecoration _dec(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: primaryColor, size: 20) : null,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  Widget _buildToggleTransporte() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        value: _aplicaTransporte,
        activeThumbColor: primaryColor,
        contentPadding: EdgeInsets.zero,
        onChanged: _soloLectura
            ? null
            : (v) => setState(() => _aplicaTransporte = v),
        title: const Text(
          'Esta salida usa vehículo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text(
          'Desactívalo si no se requiere transporte',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildSeccionVehiculo() {
    return _buildSeccion(
      titulo: 'Vehículo',
      child: Column(
        children: [
          TextField(
            controller: _placaCtrl,
            enabled: !_soloLectura,
            textCapitalization: TextCapitalization.characters,
            decoration: _dec('Placa', icon: Icons.directions_car_outlined),
          ),
          const SizedBox(height: 12),
          TextField(
            textCapitalization: terrasachaCapitalizacionTexto,
            inputFormatters: terrasachaFormattersTexto(),
            controller: _marcaCtrl,
            enabled: !_soloLectura,
            decoration: _dec('Marca / modelo (opcional)',
                icon: Icons.info_outline),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionConductor() {
    final conductor = _conductorActual();
    final errorLicencia = _aplicaTransporte
        ? ServicioChequeoVehiculo.validarLicencia(conductor)
        : null;
    final mostrarError = errorLicencia != null &&
        (conductor.nombre.isNotEmpty ||
            conductor.numeroLicencia.isNotEmpty ||
            _vencimiento != null ||
            _categoria != null);

    return _buildSeccion(
      titulo: 'Conductor y licencia',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            textCapitalization: terrasachaCapitalizacionTexto,
            inputFormatters: terrasachaFormattersTexto(),
            controller: _conductorCtrl,
            enabled: !_soloLectura,
            onChanged: (_) => setState(() {}),
            decoration: _dec('Nombre del conductor',
                icon: Icons.person_outline),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _licenciaCtrl,
            enabled: !_soloLectura,
            textCapitalization: TextCapitalization.characters,
            onChanged: (_) => setState(() {}),
            decoration: _dec('Número de licencia', icon: Icons.badge_outlined),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _categoria,
                  isExpanded: true,
                  decoration: _dec('Categoría'),
                  items: ServicioChequeoVehiculo.categoriasPermitidasPorDefecto
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: _soloLectura
                      ? null
                      : (v) => setState(() => _categoria = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: _soloLectura ? null : _seleccionarVencimiento,
                  child: InputDecorator(
                    decoration: _dec('Vence', icon: Icons.event_outlined),
                    child: Text(
                      _vencimiento == null
                          ? '—'
                          : '${_vencimiento!.day.toString().padLeft(2, '0')}/${_vencimiento!.month.toString().padLeft(2, '0')}/${_vencimiento!.year}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (mostrarError) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.redAccent, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    errorLicencia,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ] else if (_aplicaTransporte && conductor.datosCompletos) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.verified_outlined,
                    color: primaryColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Licencia vigente y categoría válida',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeccionItems() {
    return _buildSeccion(
      titulo: 'Chequeo del vehículo',
      child: Column(
        children: _items
            .asMap()
            .entries
            .map((entry) => _buildFilaItem(entry.key, entry.value))
            .toList(),
      ),
    );
  }

  Widget _buildFilaItem(int index, ItemChequeoTransporte item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${index + 1}. ${item.titulo}',
              style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: RespuestaItemTransporte.values.map((r) {
              final seleccionado = item.respuesta == r;
              return ChoiceChip(
                label: Text(r.etiqueta),
                selected: seleccionado,
                selectedColor: r == RespuestaItemTransporte.no
                    ? Colors.redAccent.withValues(alpha: 0.15)
                    : primaryColor.withValues(alpha: 0.15),
                labelStyle: TextStyle(
                  color: seleccionado
                      ? (r == RespuestaItemTransporte.no
                          ? Colors.redAccent
                          : primaryColor)
                      : Colors.black54,
                  fontWeight:
                      seleccionado ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                onSelected: _soloLectura
                    ? null
                    : (_) => setState(
                          () => _items[index] = item.copyWith(respuesta: r),
                        ),
              );
            }).toList(),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  Widget _buildSeccionObservaciones() {
    return _buildSeccion(
      titulo: 'Observaciones',
      child: TextField(
        textCapitalization: terrasachaCapitalizacionTexto,
        inputFormatters: terrasachaFormattersTexto(),
        controller: _obsCtrl,
        enabled: !_soloLectura,
        maxLines: 3,
        decoration: _dec('Ej. cambio de conductor, ruido en frenos...'),
      ),
    );
  }

  Widget _buildSeccionEvidencias() {
    return _buildSeccion(
      titulo: 'Evidencias',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_soloLectura)
            OutlinedButton.icon(
              onPressed: _mostrarOpcionesEvidencia,
              icon: const Icon(Icons.add_a_photo_outlined, color: primaryColor),
              label: const Text(
                'Agregar foto',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
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

  Widget _buildMiniaturaEvidencia(EvidenciaChequeoVehiculo evidencia) {
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

  Widget _buildSeccionFirma() {
    if (_firmaExistente != null) {
      return _buildSeccion(
        titulo: 'Firma',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(_firmaExistente!.rutaImagenLocal),
                height: 140,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Text('Firma registrada'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Firmado por ${_firmaExistente!.firmadoPorNombre}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
            if (!_soloLectura)
              TextButton.icon(
                onPressed: () => setState(() => _firmaExistente = null),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Volver a firmar'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
              ),
          ],
        ),
      );
    }

    return _buildSeccion(
      titulo: 'Firma del responsable',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade50,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Signature(
                controller: _firmaCtrl,
                height: 160,
                backgroundColor: Colors.grey.shade50,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _firmaCtrl.clear(),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Limpiar firma'),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotones() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _guardando ? null : _firmarYCompletar,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Firmar y completar'),
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
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
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
