import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/checklist_salida_ejecucion.dart';
import '../models/lista_chequeo.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_checklist_salida.dart';
import '../utils/servicio_salida.dart';
import '../theme.dart';

/// Checklist de salida de una persona del equipo (operador o líder de
/// cuadrilla) para un día concreto de la salida. Solo el líder de cuadrilla
/// puede marcar ítems, adjuntar evidencia y cerrar el checklist de cualquier
/// persona (incluido el suyo). El dueño del checklist y el jefe de cuadrilla
/// pueden dejar observaciones diferenciadas por autor.
class ChecklistSalidaScreen extends StatefulWidget {
  final String salidaId;
  final ChecklistPlanAsignado checklist;
  final String personaId;
  final String personaNombre;
  final String personaRol;

  /// Día calendario de la salida al que corresponde este checklist.
  final DateTime fecha;

  /// El líder de cuadrilla marca ítems, adjunta evidencia y cierra el
  /// checklist de esta persona.
  final bool puedeEditarItems;

  /// Quien abre la pantalla es el dueño del checklist (el operador viendo el
  /// suyo, o el líder viendo el suyo propio) y puede escribir su observación.
  final bool puedeEditarObservacion;

  const ChecklistSalidaScreen({
    super.key,
    required this.salidaId,
    required this.checklist,
    required this.personaId,
    required this.personaNombre,
    required this.personaRol,
    required this.fecha,
    this.puedeEditarItems = false,
    this.puedeEditarObservacion = false,
  });

  @override
  State<ChecklistSalidaScreen> createState() => _ChecklistSalidaScreenState();
}

class _ChecklistSalidaScreenState extends State<ChecklistSalidaScreen> {
  static const Color primaryColor = terrasachaPrimaryColor;
  static const Color backgroundColor = terrasachaBackgroundColor;

  final _picker = ImagePicker();
  late final TextEditingController _obsCtrl;

  final Map<String, bool> _itemsCompletados = {};
  List<EvidenciaChecklistSalida> _evidencias = [];
  bool _completado = false;
  String? _completadoPorNombre;
  DateTime? _completadoEn;
  List<ChecklistPersonaEjecucion> _historial = [];
  List<ObservacionChecklistPersona> _observaciones = [];
  UsuarioCampo? _usuarioActual;

  bool _cargando = true;
  bool _guardando = false;
  bool _guardandoObservacion = false;
  bool _clonando = false;

  /// Ítems y evidencias son de solo lectura una vez cerrados, o si quien
  /// mira la pantalla no es el líder de cuadrilla.
  bool get _soloLecturaItems => !widget.puedeEditarItems || _completado;

  /// `dueno` si quien escribe es el titular; `supervisor` si es el jefe de
  /// cuadrilla revisando el checklist de otro.
  String get _tipoObservacionActual =>
      widget.puedeEditarObservacion ? 'dueno' : 'supervisor';

  bool get _puedeEscribirObservacion =>
      widget.puedeEditarObservacion || widget.puedeEditarItems;

  bool get _esChecklistPropio => widget.puedeEditarObservacion;

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
    final usuario = await servicioAutenticacion.getUsuarioActual();
    final fechaNorm = ServicioSalida.normalizarFecha(widget.fecha);
    final ejecucion = await ServicioSalida.obtenerEjecucion(widget.salidaId);
    final personal = ejecucion.checklistsPersonales.where(
      (c) => c.personaId == widget.personaId && c.fecha == fechaNorm,
    );
    final actual = personal.isNotEmpty ? personal.first : null;

    for (final item in widget.checklist.items) {
      final match =
          actual?.items.where((c) => c.itemId == item.id) ?? const [];
      _itemsCompletados[item.id] = match.isNotEmpty ? match.first.completado : false;
    }

    _evidencias = List<EvidenciaChecklistSalida>.from(
      actual?.evidencias ?? const [],
    );
    _observaciones = List<ObservacionChecklistPersona>.from(
      actual?.observaciones ?? const [],
    );
    _usuarioActual = usuario;
    final obsPropia = actual?.observacionDeAutor(
      autorUserId: usuario?.id ?? '',
      autorNombre: usuario?.nombre ?? '',
      tipo: _tipoObservacionActual,
    );
    _obsCtrl.text = obsPropia?.texto ?? '';
    _completado = actual?.completado ?? false;
    _completadoPorNombre = actual?.completadoPorNombre;
    _completadoEn = actual?.completadoEn;

    if (widget.puedeEditarItems && !_completado) {
      _historial = await ServicioSalida.historialChecklistPersona(
        salidaId: widget.salidaId,
        personaId: widget.personaId,
        excluirFecha: fechaNorm,
      );
    }

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

  Future<void> _persistir({required bool completado}) async {
    final usuario = await servicioAutenticacion.getUsuarioActual();
    await ServicioSalida.guardarChecklistPersona(
      salidaId: widget.salidaId,
      personaId: widget.personaId,
      personaNombre: widget.personaNombre,
      personaRol: widget.personaRol,
      fecha: widget.fecha,
      items: _construirItems(),
      evidencias: _evidencias,
      completado: completado,
      completadoPorNombre: usuario?.nombre ?? 'Líder de cuadrilla',
      completadoPorUserId: usuario?.id,
      // Solo se actualiza la observación cuando quien guarda es su dueño;
      // si el líder edita el checklist de otra persona, se conserva la que
      // ya existía.
      observacion: widget.puedeEditarObservacion ? _obsCtrl.text.trim() : null,
    );
  }

  /// Copia ítems, evidencias (archivos) y observaciones de un día anterior.
  Future<void> _clonarDeFecha(ChecklistPersonaEjecucion origen) async {
    setState(() => _clonando = true);
    try {
      final ahora = DateTime.now();
      final evidenciasNuevas = <EvidenciaChecklistSalida>[];
      for (final ev in origen.evidencias) {
        final origenFile = File(ev.rutaLocal);
        if (!await origenFile.exists()) continue;
        final copia = await ServicioChecklistSalida.guardarEvidencia(
          rutaOrigen: ev.rutaLocal,
          descripcion: ev.descripcion,
        );
        evidenciasNuevas.add(copia);
      }

      final observacionesNuevas = origen.observaciones
          .map(
            (o) => ObservacionChecklistPersona(
              texto: o.texto,
              autorNombre: o.autorNombre,
              autorUserId: o.autorUserId,
              autorRol: o.autorRol,
              tipo: o.tipo,
              actualizadoEn: ahora,
            ),
          )
          .toList();

      if (!mounted) return;
      setState(() {
        for (final item in origen.items) {
          _itemsCompletados[item.itemId] = item.completado;
        }
        _evidencias = evidenciasNuevas;
        _observaciones = observacionesNuevas;
        ObservacionChecklistPersona? mia;
        for (final o in observacionesNuevas) {
          if (_esMiObservacion(o)) {
            mia = o;
            break;
          }
        }
        _obsCtrl.text = mia?.texto ?? '';
        _clonando = false;
      });

      await ServicioSalida.guardarChecklistPersona(
        salidaId: widget.salidaId,
        personaId: widget.personaId,
        personaNombre: widget.personaNombre,
        personaRol: widget.personaRol,
        fecha: widget.fecha,
        items: _construirItems(),
        evidencias: _evidencias,
        completado: false,
        observaciones: observacionesNuevas,
      );

      if (!mounted) return;
      _snack(
        'Clonado del ${_formatearFecha(origen.fecha)}: '
        'ítems, ${evidenciasNuevas.length} evidencia(s) y '
        '${observacionesNuevas.length} observación(es).',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _clonando = false);
      _snack('No se pudo clonar el checklist: $e');
    }
  }

  Future<void> _mostrarSelectorClonar() async {
    if (_historial.isEmpty) {
      _snack('No hay checklists de días anteriores para clonar');
      return;
    }
    setState(() => _clonando = true);
    final seleccionado = await showModalBottomSheet<ChecklistPersonaEjecucion>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Clonar checklist de un día anterior',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Text(
                'Se copiarán ítems, fotos y observaciones.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            ..._historial.map(
              (c) => ListTile(
                leading: const Icon(Icons.history, color: primaryColor),
                title: Text(_formatearFecha(c.fecha)),
                subtitle: Text(
                  c.completado ? 'Completado' : 'Sin completar',
                ),
                onTap: () => Navigator.pop(ctx, c),
              ),
            ),
          ],
        ),
      ),
    );
    if (seleccionado != null) {
      await _clonarDeFecha(seleccionado);
    } else if (mounted) {
      setState(() => _clonando = false);
    }
  }

  String _formatearFecha(DateTime fecha) =>
      '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

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
    if (_evidencias.isEmpty) {
      return 'Adjunta al menos una evidencia (foto)';
    }
    return null;
  }

  Future<void> _guardarBorrador() async {
    setState(() => _guardando = true);
    try {
      await _persistir(completado: false);
      if (_puedeEscribirObservacion) {
        final usuario = _usuarioActual ??
            await servicioAutenticacion.getUsuarioActual();
        if (usuario != null) {
          await ServicioSalida.guardarObservacionChecklistPersona(
            salidaId: widget.salidaId,
            personaId: widget.personaId,
            personaNombre: widget.personaNombre,
            personaRol: widget.personaRol,
            fecha: widget.fecha,
            observacion: _obsCtrl.text.trim(),
            autorNombre: usuario.nombre,
            autorUserId: usuario.id,
            autorRol: usuario.rolCognito,
            tipo: _tipoObservacionActual,
          );
        }
      }
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
      await _persistir(completado: true);
      if (_puedeEscribirObservacion) {
        final usuario = _usuarioActual ??
            await servicioAutenticacion.getUsuarioActual();
        if (usuario != null) {
          await ServicioSalida.guardarObservacionChecklistPersona(
            salidaId: widget.salidaId,
            personaId: widget.personaId,
            personaNombre: widget.personaNombre,
            personaRol: widget.personaRol,
            fecha: widget.fecha,
            observacion: _obsCtrl.text.trim(),
            autorNombre: usuario.nombre,
            autorUserId: usuario.id,
            autorRol: usuario.rolCognito,
            tipo: _tipoObservacionActual,
          );
        }
      }
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

  Future<void> _guardarObservacion() async {
    final usuario = _usuarioActual;
    if (usuario == null) {
      _snack('No se pudo identificar al usuario');
      return;
    }

    setState(() => _guardandoObservacion = true);
    try {
      await ServicioSalida.guardarObservacionChecklistPersona(
        salidaId: widget.salidaId,
        personaId: widget.personaId,
        personaNombre: widget.personaNombre,
        personaRol: widget.personaRol,
        fecha: widget.fecha,
        observacion: _obsCtrl.text.trim(),
        autorNombre: usuario.nombre,
        autorUserId: usuario.id,
        autorRol: usuario.rolCognito,
        tipo: _tipoObservacionActual,
      );
      if (!mounted) return;
      setState(() => _guardandoObservacion = false);
      _snack('Observación guardada');
      await _cargar();
      if (mounted) setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardandoObservacion = false);
      _snack('No se pudo guardar la observación: $e');
    }
  }

  bool _esMiObservacion(ObservacionChecklistPersona obs) {
    final usuario = _usuarioActual;
    if (usuario == null) return false;
    return obs.coincideAutor(
      userId: usuario.id,
      nombre: usuario.nombre,
      tipoObs: _tipoObservacionActual,
    );
  }

  List<ObservacionChecklistPersona> get _observacionesDeOtros =>
      _observaciones.where((o) => !_esMiObservacion(o)).toList();

  ObservacionChecklistPersona? get _miObservacionActual {
    for (final obs in _observaciones) {
      if (_esMiObservacion(obs)) return obs;
    }
    return null;
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
                _buildEncabezadoPersona(),
                const SizedBox(height: 12),
                if (_completado) _buildBannerCompletado(),
                if (_completado) const SizedBox(height: 12),
                _buildSeccionItems(),
                const SizedBox(height: 12),
                _buildSeccionObservaciones(
                  mostrarBotonPropio: _puedeEscribirObservacion,
                ),
                const SizedBox(height: 12),
                _buildSeccionEvidencias(),
                const SizedBox(height: 24),
                if (!_soloLecturaItems) _buildBotones(),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildEncabezadoPersona() {
    final tituloPersona = _esChecklistPropio ? 'Tú' : widget.personaNombre;
    final subtituloPersona = _esChecklistPropio
        ? 'Tu checklist · ${_formatearFecha(widget.fecha)}'
        : '${widget.personaRol} · ${_formatearFecha(widget.fecha)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: primaryColor),
          const SizedBox(width: 10),
              Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tituloPersona,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtituloPersona,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
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
    final mostrarClonar =
        widget.puedeEditarItems && !_completado && _historial.isNotEmpty;

    return _buildSeccion(
      titulo: 'Ítems del checklist',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (mostrarClonar) ...[
            OutlinedButton.icon(
              onPressed: _clonando ? null : _mostrarSelectorClonar,
              icon: const Icon(Icons.history, color: primaryColor),
              label: const Text(
                'Clonar checklist de un día anterior',
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
            const SizedBox(height: 8),
          ],
          ...widget.checklist.items.map(_buildFilaItem),
        ],
      ),
    );
  }

  Widget _buildFilaItem(ItemListaChequeo item) {
    final marcado = _itemsCompletados[item.id] ?? false;

    return CheckboxListTile(
      value: marcado,
      onChanged: _soloLecturaItems
          ? null
          : (v) => setState(() => _itemsCompletados[item.id] = v ?? false),
      title: Text(item.titulo),
      subtitle: item.descripcion.isNotEmpty ? Text(item.descripcion) : null,
      activeColor: primaryColor,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSeccionObservaciones({required bool mostrarBotonPropio}) {
    final soloLecturaObservacion = !_puedeEscribirObservacion;
    final otras = _observacionesDeOtros;
    final mia = _miObservacionActual;
    final etiquetaCampo = widget.puedeEditarObservacion
        ? 'Tu observación (operador)'
        : widget.puedeEditarItems
            ? 'Tu observación (jefe de cuadrilla)'
            : 'Observación';

    return _buildSeccion(
      titulo: 'Observaciones',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (otras.isNotEmpty) ...[
            ...otras.map(_buildTarjetaObservacion),
          ],
          if (mia != null) ...[
            _buildTarjetaObservacion(mia),
          ],
          if (otras.isNotEmpty || mia != null) const SizedBox(height: 12),
          if (_puedeEscribirObservacion || otras.isNotEmpty)
            TextField(
              textCapitalization: terrasachaCapitalizacionTexto,
              inputFormatters: terrasachaFormattersTexto(),
              controller: _obsCtrl,
              enabled: !soloLecturaObservacion,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: soloLecturaObservacion
                    ? 'Sin observaciones'
                    : '$etiquetaCampo (opcional)',
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: primaryColor, width: 2),
                ),
              ),
            )
          else
            Text(
              'Sin observaciones',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          if (mostrarBotonPropio) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _guardandoObservacion ? null : _guardarObservacion,
                icon: _guardandoObservacion
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.comment_outlined, color: primaryColor),
                label: Text(
                  _guardandoObservacion
                      ? 'Guardando...'
                      : 'Guardar observación',
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTarjetaObservacion(ObservacionChecklistPersona obs) {
    final esSupervisor = obs.tipo == 'supervisor';
    final autorEtiqueta = _esMiObservacion(obs) ? 'Tú' : obs.etiquetaAutor;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: esSupervisor ? Colors.orange.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: esSupervisor ? Colors.orange.shade200 : Colors.green.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            autorEtiqueta,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: esSupervisor ? Colors.orange.shade800 : Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            obs.texto,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionEvidencias() {
    return _buildSeccion(
      titulo: 'Evidencias',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_soloLecturaItems)
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
        if (!_soloLecturaItems)
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
