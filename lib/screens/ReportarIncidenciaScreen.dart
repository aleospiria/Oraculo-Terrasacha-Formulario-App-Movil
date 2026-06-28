import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import '../models/reporte_accidente.dart';
import '../utils/servicio_accidentes.dart';
import '../utils/servicio_audios.dart';
import 'FirmaScreen.dart';

class ReportarIncidenciaScreen extends StatefulWidget {
  final String? reporteId;

  const ReportarIncidenciaScreen({super.key, this.reporteId});

  @override
  State<ReportarIncidenciaScreen> createState() => _ReportarIncidenciaScreenState();
}

class _ReportarIncidenciaScreenState extends State<ReportarIncidenciaScreen> {
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);
  final ServicioAccidentes _servicio = ServicioAccidentes();

  int _currentStep = 0;
  bool _cargando = false;
  late ReporteAccidente _r;
  bool _editando = false;
  String? _baseDir;

  // Audio recording state
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _grabandoAudio = false;
  Duration _tiempoGrabado = Duration.zero;
  Timer? _audioTimer;
  int? _audioPlayingIndex;

  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    final dir = await _servicio.directorio;
    _baseDir = dir.path;

    if (widget.reporteId != null) {
      final existente = await _servicio.obtener(widget.reporteId!);
      if (existente != null) {
        setState(() {
          _r = existente;
          _editando = true;
        });
        return;
      }
    }
    setState(() {
      _r = ReporteAccidente(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    });
  }

  @override
  void dispose() {
    _audioTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _ctrlVinculado(String valor, void Function(String) setter) {
    final c = TextEditingController(text: valor);
    c.addListener(() => setter(c.text));
    _controllers.add(c);
    return c;
  }

  Future<void> _guardar() async {
    _r.fechaModificacion = DateTime.now();
    await _servicio.guardar(_r);
  }

  bool _validarPaso(int paso) {
    switch (paso) {
      case 0:
        return _r.razonSocial.isNotEmpty && _r.nit.isNotEmpty;
      case 1:
        return _r.trabajadorNombre.isNotEmpty && _r.trabajadorNumeroId.isNotEmpty;
      case 2:
        return _r.predioNombre.isNotEmpty && _r.visitaTipoActividad.isNotEmpty;
      case 3:
        return _r.accidenteDescripcion.isNotEmpty && _r.accidenteTipo.isNotEmpty;
      case 4:
        return _r.entornoClima.isNotEmpty && _r.entornoTerreno.isNotEmpty;
      case 5:
        return true;
      case 6:
        return _r.reporteNombre.isNotEmpty;
      default:
        return true;
    }
  }

  void _siguiente() {
    if (!_validarPaso(_currentStep)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Completa los campos obligatorios antes de continuar'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_currentStep < 6) {
      setState(() => _currentStep++);
    }
  }

  Future<void> _enviar() async {
    if (!_validarPaso(_currentStep)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Completa los campos obligatorios del paso actual'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _cargando = true);

    if (!_editando) {
      _r.fechaCreacion = DateTime.now();
      _r.accidenteMes = ReporteAccidente.mesFromDate(_r.accidenteFecha);
      if (_r.accidenteHora.isEmpty) {
        _r.accidenteHora = ReporteAccidente.horaFromDate(_r.accidenteFecha);
      }
    }

    await _guardar();

    if (!mounted) return;
    setState(() => _cargando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editando ? 'Reporte actualizado' : 'Reporte guardado exitosamente'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context, true);
  }

  Future<void> _seleccionarFecha(bool esAccidente) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: esAccidente ? _r.accidenteFecha : _r.reporteFecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      locale: const Locale('es', 'CO'),
    );
    if (picked != null) {
      setState(() {
        if (esAccidente) {
          _r.accidenteFecha = picked;
          _r.accidenteMes = ReporteAccidente.mesFromDate(picked);
        } else {
          _r.reporteFecha = picked;
        }
      });
    }
  }

  Future<void> _seleccionarHora() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_r.accidenteFecha),
    );
    if (picked != null) {
      setState(() {
        _r.accidenteFecha = DateTime(
          _r.accidenteFecha.year,
          _r.accidenteFecha.month,
          _r.accidenteFecha.day,
          picked.hour,
          picked.minute,
        );
        _r.accidenteHora = ReporteAccidente.horaFromDate(_r.accidenteFecha);
      });
    }
  }

  Widget _dropdown(String titulo, String? valor, List<String> opciones, void Function(String?) onChanged,
      {bool obligatorio = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              if (obligatorio) const Text(' *', style: TextStyle(color: Colors.redAccent, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: opciones.contains(valor) ? valor : null,
                hint: Text('Seleccionar...', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                isExpanded: true,
                items: opciones.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 14)))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campo(String titulo, TextEditingController ctrl,
      {TextInputType tipo = TextInputType.text, bool obligatorio = true, int? maxLines = 1, List<TextInputFormatter>? formatters}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              if (obligatorio) const Text(' *', style: TextStyle(color: Colors.redAccent, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            keyboardType: tipo,
            maxLines: maxLines,
            inputFormatters: formatters,
            decoration: InputDecoration(
              hintText: 'Ingresa $titulo'.toLowerCase(),
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: primaryColor, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switch(String titulo, bool valor, void Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          Switch(value: valor, onChanged: onChanged, activeTrackColor: primaryColor),
        ],
      ),
    );
  }

  Widget _fecha(String titulo, DateTime fecha, bool esAccidente) {
    final meses = ReporteAccidente.meses;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _seleccionarFecha(esAccidente),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: primaryColor, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirmaWidget() {
    final bool tieneFirma = _r.firmaBytes != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Firma', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _abrirFirma,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: tieneFirma
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(_r.firmaBytes!, fit: BoxFit.contain),
                    )
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.draw, color: Colors.grey[400], size: 22),
                          const SizedBox(width: 8),
                          Text('Toca para firmar',
                              style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFotosWidget() {
    final fotos = _r.fotosEvidencia;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fotos.isNotEmpty)
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...List.generate(fotos.length, (i) => _buildFotoThumb(i)),
                  _buildFotoAddBoton(),
                ],
              ),
            )
          else
            _buildFotoAddBoton(),
        ],
      ),
    );
  }

  Widget _buildFotoThumb(int index) {
    final path = '${_baseDir!}/${_r.id}_fotos/${_r.fotosEvidencia[index]}';

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(path),
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, color: Colors.grey[400]),
              ),
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () => _eliminarFoto(index),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFotoAddBoton() {
    return GestureDetector(
      onTap: _tomarFoto,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: Colors.grey[500], size: 28),
            const SizedBox(height: 4),
            Text('Tomar foto', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Future<void> _abrirFirma() async {
    final bytes = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(builder: (_) => const FirmaScreen()),
    );
    if (bytes != null && mounted) {
      setState(() => _r.setFirmaDesdeBytes(bytes));
    }
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (xFile == null || !mounted) return;

    final nombre = await _servicio.guardarFoto(_r.id, File(xFile.path));
    setState(() => _r.fotosEvidencia = [..._r.fotosEvidencia, nombre]);
  }

  Future<void> _eliminarFoto(int index) async {
    final nombre = _r.fotosEvidencia[index];
    await _servicio.eliminarFoto(_r.id, nombre);
    setState(() {
      _r.fotosEvidencia = [..._r.fotosEvidencia]..removeAt(index);
    });
  }

  // ============================================================
  //  Audio (notas de voz)
  // ============================================================

  Widget _buildAudiosWidget() {
    final audios = _r.audiosEvidencia;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(audios.length, (i) => _buildAudioEntry(i)),
          if (_grabandoAudio) _buildRecordButton(),
          if (!_grabandoAudio && audios.isNotEmpty) const SizedBox(height: 8),
          if (!_grabandoAudio) _buildRecordButton(),
        ],
      ),
    );
  }

  Widget _buildAudioEntry(int index) {
    final duracion = _r.audiosDuracion.length > index ? _r.audiosDuracion[index] : 0;
    final playing = _audioPlayingIndex == index;
    final mm = (duracion ~/ 60).toString().padLeft(2, '0');
    final ss = (duracion % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.audio_file, color: primaryColor, size: 22),
          const SizedBox(width: 8),
          Text('Nota de voz ${index + 1}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text('$mm:$ss',
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _togglePlayAudio(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                playing ? Icons.pause : Icons.play_arrow,
                color: primaryColor,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _eliminarAudio(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.red, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordButton() {
    if (_grabandoAudio) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Grabando ${_fmtDuration(_tiempoGrabado)}',
              style: const TextStyle(fontSize: 13, color: Colors.red),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _detenerGrabacionAudio,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.stop, color: Colors.red, size: 18),
                    SizedBox(width: 4),
                    Text('Detener', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _iniciarGrabacionAudio,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic_none, color: Colors.grey[500], size: 20),
            const SizedBox(width: 6),
            Text('Agregar nota de voz',
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ],
        ),
      ),
    );
  }

  String _fmtDuration(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _iniciarGrabacionAudio() async {
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) return;

    final dir = await _servicio.directorio;
    final path = '${dir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
      path: path,
    );

    setState(() {
      _grabandoAudio = true;
      _tiempoGrabado = Duration.zero;
    });

    _audioTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _tiempoGrabado += const Duration(seconds: 1));
    });
  }

  Future<void> _detenerGrabacionAudio() async {
    _audioTimer?.cancel();
    final path = await _audioRecorder.stop();

    if (path == null || !mounted) return;

    final duracion = _tiempoGrabado.inSeconds;
    final nombre = await ServicioAudios.guardarAudio(_r.id, File(path));

    setState(() {
      _grabandoAudio = false;
      _r.audiosEvidencia = [..._r.audiosEvidencia, nombre];
      _r.audiosDuracion = [..._r.audiosDuracion, duracion];
    });
  }

  Future<void> _togglePlayAudio(int index) async {
    if (_audioPlayingIndex == index) {
      await _audioPlayer.pause();
      setState(() => _audioPlayingIndex = null);
      return;
    }

    final nombre = _r.audiosEvidencia[index];
    final ruta = await ServicioAudios.obtenerRutaAudio(_r.id, nombre);

    try {
      await _audioPlayer.setFilePath(ruta);
      await _audioPlayer.play();
      setState(() => _audioPlayingIndex = index);
      _audioPlayer.playerStateStream.firstWhere(
        (s) => s.processingState == ProcessingState.completed,
      ).then((_) {
        if (mounted) setState(() => _audioPlayingIndex = null);
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al reproducir el audio')),
        );
      }
    }
  }

  Future<void> _eliminarAudio(int index) async {
    final nombre = _r.audiosEvidencia[index];
    await ServicioAudios.eliminarAudio(_r.id, nombre);
    if (_audioPlayingIndex == index) {
      await _audioPlayer.stop();
      _audioPlayingIndex = null;
    }
    setState(() {
      _r.audiosEvidencia = [..._r.audiosEvidencia]..removeAt(index);
      _r.audiosDuracion = [..._r.audiosDuracion]..removeAt(index);
    });
  }

  Widget _buildPaso0() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos del empleador', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          _campo('Razón social', _ctrlVinculado(_r.razonSocial, (v) => _r.razonSocial = v)),
          _campo('NIT', _ctrlVinculado(_r.nit, (v) => _r.nit = v), tipo: TextInputType.number),
          _campo('Dirección principal', _ctrlVinculado(_r.direccion, (v) => _r.direccion = v)),
          _campo('Teléfono', _ctrlVinculado(_r.telefono, (v) => _r.telefono = v), tipo: TextInputType.phone),
          _campo('ARL', _ctrlVinculado(_r.arl, (v) => _r.arl = v)),
          _campo('Actividad económica', _ctrlVinculado(_r.actividadEconomica, (v) => _r.actividadEconomica = v)),
        ],
      ),
    );
  }

  Widget _buildPaso1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos del trabajador / contratista', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          _campo('Nombre completo', _ctrlVinculado(_r.trabajadorNombre, (v) => _r.trabajadorNombre = v)),
          _dropdown('Tipo de identificación', _r.trabajadorTipoId, ReporteAccidente.tiposIdentificacion,
              (v) => setState(() => _r.trabajadorTipoId = v!)),
          _campo('Número de identificación', _ctrlVinculado(_r.trabajadorNumeroId, (v) => _r.trabajadorNumeroId = v)),
          _campo('Cargo o rol en la visita', _ctrlVinculado(_r.trabajadorCargo, (v) => _r.trabajadorCargo = v)),
          _campo('Tipo de contrato', _ctrlVinculado(_r.trabajadorTipoContrato, (v) => _r.trabajadorTipoContrato = v)),
          _campo('Antigüedad en el cargo', _ctrlVinculado(_r.trabajadorAntiguedad, (v) => _r.trabajadorAntiguedad = v)),
          _campo('Teléfono de contacto', _ctrlVinculado(_r.trabajadorTelefono, (v) => _r.trabajadorTelefono = v),
              tipo: TextInputType.phone),
        ],
      ),
    );
  }

  Widget _buildPaso2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos de la visita de campo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          _campo('Nombre del predio', _ctrlVinculado(_r.predioNombre, (v) => _r.predioNombre = v)),
          _campo('Municipio', _ctrlVinculado(_r.predioMunicipio, (v) => _r.predioMunicipio = v)),
          _campo('Departamento', _ctrlVinculado(_r.predioDepartamento, (v) => _r.predioDepartamento = v)),
          _dropdown('Tipo de actividad de la visita', _r.visitaTipoActividad, ReporteAccidente.tiposActividad,
              (v) => setState(() => _r.visitaTipoActividad = v!)),
        ],
      ),
    );
  }

  Widget _buildPaso3() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Información del accidente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          _fecha('Fecha del accidente', _r.accidenteFecha, true),
          GestureDetector(
            onTap: _seleccionarHora,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hora del accidente', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: primaryColor, size: 18),
                        const SizedBox(width: 10),
                        Text(_r.accidenteHora.isNotEmpty ? _r.accidenteHora : 'Seleccionar hora',
                            style: TextStyle(fontSize: 14, color: _r.accidenteHora.isNotEmpty ? Colors.black87 : Colors.grey[400])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _campo('Lugar exacto (coordenadas)', _ctrlVinculado(_r.accidenteLugarCoordenadas, (v) => _r.accidenteLugarCoordenadas = v)),
          _dropdown('Tipo de accidente', _r.accidenteTipo, ReporteAccidente.tiposAccidente, (v) {
            setState(() => _r.accidenteTipo = v!);
          }),
          if (_r.accidenteTipo == 'Otro')
            _campo('Especifique otro tipo', _ctrlVinculado(_r.accidenteTipoOtro ?? '', (v) => _r.accidenteTipoOtro = v)),
          _campo('Descripción detallada de los hechos', _ctrlVinculado(_r.accidenteDescripcion, (v) => _r.accidenteDescripcion = v),
              maxLines: 4),
          _dropdown('Parte del cuerpo afectada', _r.accidenteParteCuerpo, ReporteAccidente.partesCuerpo,
              (v) => setState(() => _r.accidenteParteCuerpo = v!)),
          _dropdown('Tipo de lesión', _r.accidenteTipoLesion, ReporteAccidente.tiposLesion,
              (v) => setState(() => _r.accidenteTipoLesion = v!)),
          _switch('¿Requiere atención médica inmediata?', _r.accidenteAtencionMedica,
              (v) => setState(() => _r.accidenteAtencionMedica = v)),
          if (_r.accidenteAtencionMedica)
            _campo('Centro asistencial', _ctrlVinculado(_r.accidenteCentroAsistencial, (v) => _r.accidenteCentroAsistencial = v)),
          _switch('¿Accidente con incapacidad?', _r.accidenteIncapacidad,
              (v) => setState(() => _r.accidenteIncapacidad = v)),
          if (_r.accidenteIncapacidad)
            _campo('Días de incapacidad', _ctrlVinculado(_r.accidenteDiasIncapacidad?.toString() ?? '', (v) {
              _r.accidenteDiasIncapacidad = int.tryParse(v);
            }), tipo: TextInputType.number),
          _switch('¿Chequeo preoperacional?', _r.accidenteChequeoPreop,
              (v) => setState(() => _r.accidenteChequeoPreop = v)),
          if (_r.accidenteChequeoPreop)
            _dropdown('Resultado chequeo', _r.accidenteResultadoChequeo, ReporteAccidente.resultadosChequeo,
                (v) => setState(() => _r.accidenteResultadoChequeo = v)),
          _dropdown('Causa principal', _r.accidenteCausaPrincipal, ReporteAccidente.causasPrincipales,
              (v) => setState(() => _r.accidenteCausaPrincipal = v!)),
          const SizedBox(height: 16),
          const Text('Evidencia fotográfica', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildFotosWidget(),
        ],
      ),
    );
  }

  Widget _buildPaso4() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Condiciones del entorno', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          _dropdown('Condiciones climáticas', _r.entornoClima, ReporteAccidente.climas,
              (v) => setState(() => _r.entornoClima = v!)),
          _dropdown('Estado del terreno', _r.entornoTerreno, ReporteAccidente.terrenos,
              (v) => setState(() => _r.entornoTerreno = v!)),
          _switch('¿Uso de EPP al momento del accidente?', _r.entornoUsoEPP,
              (v) => setState(() => _r.entornoUsoEPP = v)),
          _dropdown('Tipo de riesgo', _r.entornoTipoRiesgo, ReporteAccidente.tiposRiesgo,
              (v) => setState(() => _r.entornoTipoRiesgo = v!)),
        ],
      ),
    );
  }

  Widget _buildPaso5() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Testigos (si aplica)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          _campo('Nombre del testigo', _ctrlVinculado(_r.testigoNombre ?? '', (v) => _r.testigoNombre = v),
              obligatorio: false),
          _campo('Contacto del testigo', _ctrlVinculado(_r.testigoContacto ?? '', (v) => _r.testigoContacto = v),
              obligatorio: false),
        ],
      ),
    );
  }

  Widget _buildPaso6() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos del reporte', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          _campo('Nombre de quien reporta', _ctrlVinculado(_r.reporteNombre, (v) => _r.reporteNombre = v)),
          _campo('Cargo', _ctrlVinculado(_r.reporteCargo, (v) => _r.reporteCargo = v)),
          _fecha('Fecha de diligenciamiento', _r.reporteFecha, false),
          const SizedBox(height: 16),
          const Text('Notas de voz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildAudiosWidget(),
          const SizedBox(height: 16),
          _buildFirmaWidget(),
        ],
      ),
    );
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
        title: Text(
          _editando ? 'Editar Reporte' : 'Nuevo Reporte de Accidente',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: _r.id.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              onStepContinue: _currentStep < 6 ? _siguiente : _enviar,
              onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
              controlsBuilder: (ctx, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      if (_currentStep < 6)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: details.onStepContinue,
                          child: const Text('Siguiente', style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _cargando ? null : _enviar,
                          child: _cargando
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : const Text('Guardar Reporte', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      const SizedBox(width: 12),
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: Text('Anterior', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
                        ),
                    ],
                  ),
                );
              },
              steps: [
                Step(title: const Text('Empleador'), isActive: _currentStep >= 0, state: _currentStep == 0 ? StepState.indexed : (_r.razonSocial.isNotEmpty ? StepState.complete : StepState.indexed), content: _buildPaso0()),
                Step(title: const Text('Trabajador'), isActive: _currentStep >= 1, state: _currentStep == 1 ? StepState.indexed : (_r.trabajadorNombre.isNotEmpty ? StepState.complete : StepState.indexed), content: _buildPaso1()),
                Step(title: const Text('Visita'), isActive: _currentStep >= 2, state: _currentStep == 2 ? StepState.indexed : (_r.predioNombre.isNotEmpty ? StepState.complete : StepState.indexed), content: _buildPaso2()),
                Step(title: const Text('Accidente'), isActive: _currentStep >= 3, state: _currentStep == 3 ? StepState.indexed : (_r.accidenteDescripcion.isNotEmpty ? StepState.complete : StepState.indexed), content: _buildPaso3()),
                Step(title: const Text('Entorno'), isActive: _currentStep >= 4, state: _currentStep == 4 ? StepState.indexed : (_r.entornoClima.isNotEmpty ? StepState.complete : StepState.indexed), content: _buildPaso4()),
                Step(title: const Text('Testigos'), isActive: _currentStep >= 5, state: _currentStep == 5 ? StepState.indexed : StepState.indexed, content: _buildPaso5()),
                Step(title: const Text('Reporte'), isActive: _currentStep >= 6, state: _currentStep == 6 ? StepState.indexed : (_r.reporteNombre.isNotEmpty ? StepState.complete : StepState.indexed), content: _buildPaso6()),
              ],
            ),
    );
  }
}
