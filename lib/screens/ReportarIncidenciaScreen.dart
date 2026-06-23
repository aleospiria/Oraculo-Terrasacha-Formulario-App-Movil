import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/reporte_accidente.dart';
import '../utils/servicio_accidentes.dart';

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

  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
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
          _campo('Firma', _ctrlVinculado(_r.reporteFirma ?? '', (v) => _r.reporteFirma = v),
              obligatorio: false),
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
