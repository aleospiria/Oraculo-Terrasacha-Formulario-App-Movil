import '../theme.dart';
// lib/screens/EjecucionRegistroScreen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

import '../main.dart';
import '../models/coordenada_actual.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';
import '../utils/roles_campo.dart';
import '../utils/servicio_audios.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_evidencia_registro.dart';
import '../utils/servicio_plantillas.dart';
import '../utils/servicio_salida.dart';
import '../utils/servicio_transcripcion_voz.dart';
import '../utils/servicio_ubicacion_actual.dart';
import '../widgets/coordenada_actual_panel.dart';
import 'package:capturador_datos_offline/screens/FinalizarTareaScreen.dart';

/// Registro de una feature/sub-área concreta dentro de una tarea asignada.
/// Cada feature tiene su propio audio, transcripción, coordenadas,
/// observaciones y evidencia fotográfica, y se completa de forma
/// independiente del resto de features de la misma tarea.
class EjecucionRegistroScreen extends StatefulWidget {
  final String? salidaId;
  final String? asignacionId;
  final String? featureId;
  final String? featureNombre;
  final String tituloTarea;
  final String? ubicacionRuta;

  const EjecucionRegistroScreen({
    super.key,
    this.salidaId,
    this.asignacionId,
    this.featureId,
    this.featureNombre,
    this.tituloTarea = 'Ejecución de registro',
    this.ubicacionRuta,
  });

  @override
  State<EjecucionRegistroScreen> createState() =>
      _EjecucionRegistroScreenState();
}

class _EjecucionRegistroScreenState extends State<EjecucionRegistroScreen> {
  static const Color primaryColor = terrasachaPrimaryColor;
  static const Color backgroundColor = terrasachaBackgroundColor;

  final _picker = ImagePicker();

  String? _rutaAudio;
  /// Último texto transcrito automáticamente del audio, antes de que el
  /// operador lo edite en observaciones (se conserva para saber que el
  /// registro tiene una transcripción, aparte del texto final editado).
  String? _transcripcionCruda;
  bool _transcribiendo = false;
  String? _errorTranscripcion;

  List<EvidenciaRegistroFeature> _evidencias = [];

  final TextEditingController _observacionesCtrl = TextEditingController();
  final TextEditingController _valorNumericoCtrl = TextEditingController();
  bool _cargandoRegistro = true;
  bool _registroPreviamenteCompletado = false;
  bool _tareaFinalizada = false;
  bool _guardando = false;
  CoordenadaActual? _coordenadaActual;
  bool _esMedicionNumerica = false;
  String? _unidadMedida;
  bool _acordeonObsExpandido = false;
  bool _acordeonEvidenciaExpandido = false;
  final ExpansionTileController _obsExpansionCtrl = ExpansionTileController();
  final ExpansionTileController _evidenciaExpansionCtrl =
      ExpansionTileController();

  bool get _requiereObservacion => !_esMedicionNumerica;

  bool get _registraMedicionEnCampo =>
      hasRole('operador') ||
      hasRole('lider_cuadrilla') ||
      RolesCampo.capturaCoordenadasEnRegistro(currentUserRole);

  bool get _requiereCoordenadas =>
      _registraMedicionEnCampo ||
      plantillaRequiereCoordenadasGps(
        widget.featureNombre != null ? [widget.featureNombre!] : const [],
      );

  bool get _mostrarCoordenadas => _requiereCoordenadas;

  bool get _tieneContextoSalida =>
      widget.salidaId != null &&
      widget.asignacionId != null &&
      widget.featureId != null;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    if (_mostrarCoordenadas) {
      ServicioUbicacionActual.solicitarPermiso();
    }
    await Future.wait([
      _cargarMetaFeature(),
      _cargarRegistroExistente(),
    ]);
    if (!mounted) return;
    setState(() {
      _acordeonObsExpandido = _requiereObservacion ||
          _observacionesCtrl.text.trim().isNotEmpty;
      _acordeonEvidenciaExpandido = _evidencias.isNotEmpty;
    });
    // Tras cargar, sincronizar acordeones (ExpansionTile ignora initiallyExpanded
    // si ya tiene controller).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_acordeonObsExpandido) {
        _obsExpansionCtrl.expand();
      }
      if (_acordeonEvidenciaExpandido) {
        _evidenciaExpansionCtrl.expand();
      }
    });
  }

  Future<void> _cargarMetaFeature() async {
    final featureId = widget.featureId;
    if (featureId == null || featureId.isEmpty) return;
    final meta = await ServicioPlantillas.obtenerFeaturePorId(featureId);
    if (!mounted || meta == null) return;
    setState(() {
      _esMedicionNumerica = meta.requiereValorNumerico;
      _unidadMedida = meta.unidadVisible;
    });
  }

  /// Marca la feature como "en curso" y precarga los datos ya guardados de
  /// un registro previo (si el operador vuelve a abrir una feature que ya
  /// había empezado o completado), para poder revisarlos o corregirlos.
  Future<void> _cargarRegistroExistente() async {
    if (!_tieneContextoSalida) {
      if (mounted) setState(() => _cargandoRegistro = false);
      return;
    }

    await ServicioSalida.marcarFeatureEnCurso(
      salidaId: widget.salidaId!,
      asignacionId: widget.asignacionId!,
      featureId: widget.featureId!,
    );

    final ejecucion = await ServicioSalida.obtenerEjecucion(widget.salidaId!);
    final asignacion = ejecucion.asignaciones
        .where((a) => a.asignacionId == widget.asignacionId)
        .firstOrNull;
    final registro = asignacion?.registroDeFeature(widget.featureId!);

    if (!mounted) return;
    setState(() {
      if (registro != null) {
        _rutaAudio = registro.rutaAudio;
        _transcripcionCruda = registro.transcripcionAudio;
        _observacionesCtrl.text = registro.observaciones ?? '';
        if (registro.valorNumerico != null) {
          _valorNumericoCtrl.text = registro.valorNumerico.toString();
        }
        _evidencias = List<EvidenciaRegistroFeature>.from(registro.evidencias);
        _acordeonObsExpandido =
            (registro.observaciones?.trim().isNotEmpty ?? false) ||
                !_esMedicionNumerica;
        _acordeonEvidenciaExpandido = registro.evidencias.isNotEmpty;
        _registroPreviamenteCompletado =
            registro.estado == EstadoAsignacionEjecucion.completada;
        if (registro.tieneCoordenadas) {
          _coordenadaActual = CoordenadaActual(
            latitud: registro.latitud!,
            longitud: registro.longitud!,
            precisionMetros: registro.precisionMetros,
            capturadaEn: registro.coordenadasCapturadasEn ?? DateTime.now(),
          );
        }
      }
      _cargandoRegistro = false;
    });
  }

  @override
  void dispose() {
    _observacionesCtrl.dispose();
    _valorNumericoCtrl.dispose();
    super.dispose();
  }

  // ── Transcripción offline ────────────────────────────────────────────────

  Future<void> _transcribirAudio() async {
    final ruta = _rutaAudio;
    if (ruta == null || _transcribiendo) return;

    setState(() {
      _transcribiendo = true;
      _errorTranscripcion = null;
    });

    try {
      await ServicioTranscripcionVoz.asegurarModeloDisponible();
      final texto = await ServicioTranscripcionVoz.transcribir(ruta);

      if (!mounted) return;
      if (texto.isEmpty) {
        setState(() => _errorTranscripcion =
            'No se detectó voz reconocible en el audio.');
      } else {
        setState(() {
          final actual = _observacionesCtrl.text.trim();
          _observacionesCtrl.text =
              actual.isEmpty ? texto : '$actual\n$texto';
          _transcripcionCruda = texto;
          _acordeonObsExpandido = true;
        });
        _obsExpansionCtrl.expand();
        _mostrarSnack(
          'Transcripción agregada a observaciones. Revisa el texto.',
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorTranscripcion =
          'No se pudo transcribir automáticamente (¿sin conexión la primera '
          'vez?). El audio queda guardado como evidencia igual.');
    } finally {
      if (mounted) setState(() => _transcribiendo = false);
    }
  }

  void _mostrarSnack(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), behavior: SnackBarBehavior.floating),
    );
  }

  // ── Evidencia fotográfica ────────────────────────────────────────────────

  Future<void> _agregarEvidencia(ImageSource source) async {
    try {
      final XFile? archivo = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (archivo == null) return;
      final evidencia = await ServicioEvidenciaRegistro.guardarEvidencia(
        rutaOrigen: archivo.path,
      );
      if (!mounted) return;
      setState(() {
        _evidencias = [..._evidencias, evidencia];
        _acordeonEvidenciaExpandido = true;
      });
      _evidenciaExpansionCtrl.expand();
    } catch (e) {
      if (!mounted) return;
      _mostrarSnack('No se pudo adjuntar la foto: $e');
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
              leading:
                  const Icon(Icons.photo_camera_outlined, color: primaryColor),
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

  Future<void> _eliminarEvidencia(EvidenciaRegistroFeature evidencia) async {
    await ServicioEvidenciaRegistro.eliminarArchivo(evidencia.rutaLocal);
    if (!mounted) return;
    setState(
      () => _evidencias = _evidencias.where((e) => e.id != evidencia.id).toList(),
    );
  }

  // ── Guardado ─────────────────────────────────────────────────────────────

  Future<void> _finalizarTarea(BuildContext context) async {
    final valorTexto = _valorNumericoCtrl.text.trim().replaceAll(',', '.');
    final valorNumerico = double.tryParse(valorTexto);

    if (_esMedicionNumerica) {
      if (valorTexto.isEmpty || valorNumerico == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ingresa el valor numérico de la medición'),
          ),
        );
        return;
      }
    } else if (_observacionesCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La observación es obligatoria para esta medición'),
        ),
      );
      setState(() => _acordeonObsExpandido = true);
      _obsExpansionCtrl.expand();
      return;
    }

    var coordenada = await ServicioUbicacionActual.obtenerUnaVez();
    coordenada ??= _coordenadaActual;

    if (_requiereCoordenadas && coordenada == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Se requiere señal GPS para finalizar. Activa la ubicación e intenta de nuevo.',
          ),
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    if (_tieneContextoSalida) {
      await ServicioSalida.guardarRegistroFeature(
        salidaId: widget.salidaId!,
        asignacionId: widget.asignacionId!,
        featureId: widget.featureId!,
        featureNombre: widget.featureNombre ?? widget.featureId!,
        coordenada: coordenada,
        observaciones: _observacionesCtrl.text.trim().isEmpty
            ? null
            : _observacionesCtrl.text.trim(),
        valorNumerico: _esMedicionNumerica ? valorNumerico : null,
        rutaAudio: _rutaAudio,
        transcripcionAudio: _transcripcionCruda,
        evidencias: _evidencias,
      );
    }

    if (!context.mounted) return;
    setState(() {
      _guardando = false;
      _tareaFinalizada = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro guardado exitosamente'),
        backgroundColor: primaryColor,
      ),
    );

    var checklistCompletados = 0;
    var checklistTotal = 0;
    final salidaId = widget.salidaId;
    if (salidaId != null) {
      final usuario = await servicioAutenticacion.getUsuarioActual();
      if (usuario != null) {
        final checklists = await ServicioSalida.listarChecklistsParaUsuario(
          usuario,
        );
        ChecklistSalidaVista? checklistVista;
        for (final vista in checklists) {
          if (vista.salidaId == salidaId) {
            checklistVista = vista;
            break;
          }
        }
        if (checklistVista != null) {
          checklistCompletados = checklistVista.itemsCompletados;
          checklistTotal = checklistVista.itemsTotal;
        }
      }
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FinalizarTareaScreen(
              tituloTarea: widget.tituloTarea,
              featureNombre: widget.featureNombre,
              checklistCompletados: checklistCompletados,
              checklistTotal: checklistTotal,
              evidenciasCount: _evidencias.length,
            ),
          ),
        );
      }
    });
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
          'Ejecución de Registro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              radius: 18,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: _cargandoRegistro
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoTarea(),
                  const SizedBox(height: 20),
                  if (widget.ubicacionRuta != null) ...[
                    _buildZonaAsignada(),
                    const SizedBox(height: 20),
                  ],
                  if (_registroPreviamenteCompletado) ...[
                    _buildBannerCompletado(),
                    const SizedBox(height: 20),
                  ],
                  if (_mostrarCoordenadas) ...[
                    CoordenadaActualPanel(
                      soloLectura: true,
                      titulo: 'Coordenadas del registro',
                      primaryColor: primaryColor,
                      onCoordenadaChanged: (coord) {
                        setState(() => _coordenadaActual = coord);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                  grabadorAudio(
                    recordConfig: const RecordConfig(
                      encoder: AudioEncoder.wav,
                      sampleRate: ServicioTranscripcionVoz.sampleRate,
                      numChannels: 1,
                    ),
                    extensionArchivo: 'wav',
                    onGrabacionCompleta: (path) {
                      setState(() {
                        _rutaAudio = path;
                        _transcripcionCruda = null;
                      });
                      _transcribirAudio();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTranscripcionEstado(),
                  if (_esMedicionNumerica) ...[
                    const SizedBox(height: 24),
                    _buildCampoValorNumerico(),
                  ],
                  const SizedBox(height: 24),
                  _buildEvidencias(),
                  const SizedBox(height: 16),
                  _buildObservaciones(),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _tareaFinalizada || _guardando
                            ? Colors.grey
                            : primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _tareaFinalizada || _guardando
                          ? null
                          : () => _finalizarTarea(context),
                      icon: _guardando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(_tareaFinalizada ? Icons.check : Icons.save),
                      label: Text(
                        _guardando
                            ? 'Guardando…'
                            : _tareaFinalizada
                                ? 'Registro Guardado'
                                : 'Finalizar y Guardar',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoTarea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.assignment, color: primaryColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tituloTarea,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (widget.featureNombre != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.featureNombre!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
                if (_requiereCoordenadas) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Las coordenadas GPS se capturan del celular al finalizar. No se pueden editar manualmente.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'En ejecución',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCompletado() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: primaryColor),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Esta feature ya fue registrada como completada. Puedes '
              'revisar o corregir los datos y volver a guardar.',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZonaAsignada() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.map_outlined, color: primaryColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zona asignada (solo lectura)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.ubicacionRuta!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscripcionEstado() {
    if (_transcribiendo) {
      return Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Transcribiendo audio a texto (puede tardar la primera vez, '
              'requiere internet solo para descargar el modelo)…',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      );
    }

    if (_errorTranscripcion != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorTranscripcion!,
              style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
            ),
          ),
          if (_rutaAudio != null)
            TextButton(
              onPressed: _transcribirAudio,
              child: const Text('Reintentar'),
            ),
        ],
      );
    }

    if (_rutaAudio != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _transcribirAudio,
          icon: const Icon(Icons.subtitles_outlined, color: primaryColor),
          label: const Text(
            'Transcribir audio a texto',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCampoValorNumerico() {
    final unidad = _unidadMedida;
    final etiquetaUnidad =
        (unidad != null && unidad.isNotEmpty) ? ' ($unidad)' : '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.straighten, color: primaryColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Valor de la medición$etiquetaUnidad',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Obligatorio',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _valorNumericoCtrl,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            style: terrasachaInputTextStyle,
            decoration: InputDecoration(
              hintText: unidad != null && unidad.isNotEmpty
                  ? 'Ej: 12.5 $unidad'
                  : 'Ingresa el valor medido',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              suffixText: unidad,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: primaryColor, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcordeon({
    required ExpansionTileController controller,
    required bool expandido,
    required ValueChanged<bool> onExpansionChanged,
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required Widget hijo,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: controller,
          initiallyExpanded: expandido,
          onExpansionChanged: onExpansionChanged,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Icon(icono, color: primaryColor, size: 22),
          title: Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitulo,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          children: [hijo],
        ),
      ),
    );
  }

  Widget _buildEvidencias() {
    final n = _evidencias.length;
    return _buildAcordeon(
      controller: _evidenciaExpansionCtrl,
      expandido: _acordeonEvidenciaExpandido,
      onExpansionChanged: (v) => setState(() => _acordeonEvidenciaExpandido = v),
      icono: Icons.photo_camera_outlined,
      titulo: 'Evidencia fotográfica',
      subtitulo: n == 0
          ? 'Opcional · sin fotos'
          : 'Opcional · $n foto${n == 1 ? '' : 's'}',
      hijo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
          if (_evidencias.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Sin fotos adjuntas',
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

  Widget _buildMiniaturaEvidencia(EvidenciaRegistroFeature evidencia) {
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

  Widget _buildObservaciones() {
    final obligatorio = _requiereObservacion;
    return _buildAcordeon(
      controller: _obsExpansionCtrl,
      expandido: _acordeonObsExpandido,
      onExpansionChanged: (v) => setState(() => _acordeonObsExpandido = v),
      icono: Icons.edit_note,
      titulo: 'Observaciones',
      subtitulo: obligatorio
          ? 'Obligatorio para esta medición'
          : 'Opcional',
      hijo: TextField(
        textCapitalization: terrasachaCapitalizacionTexto,
        inputFormatters: terrasachaFormattersTexto(),
        controller: _observacionesCtrl,
        maxLines: 4,
        style: terrasachaInputTextStyle,
        decoration: InputDecoration(
          hintText: obligatorio
              ? 'Describe lo observado en campo...'
              : 'Notas adicionales (opcional)...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
