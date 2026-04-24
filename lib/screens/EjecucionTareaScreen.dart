// lib/Screens/EjecucionTareaScreen.dart
import 'dart:async';
import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────
//  Modelos locales
// ──────────────────────────────────────────────────────────────
class ItemVerificacion {
  final String label;
  bool completado;

  ItemVerificacion({required this.label, required this.completado});
}

// ──────────────────────────────────────────────────────────────
//  Pantalla
// ──────────────────────────────────────────────────────────────
class EjecucionTareaScreen extends StatefulWidget {
  const EjecucionTareaScreen({super.key});

  @override
  State<EjecucionTareaScreen> createState() => _EjecucionTareaScreenState();
}

class _EjecucionTareaScreenState extends State<EjecucionTareaScreen>
    with TickerProviderStateMixin {
  // ── Colores (mismo sistema de diseño) ──────────────────────
  static const Color primaryColor = Color(0xFF8A8F4A);
  static const Color backgroundColor = Color(0xFFF8F7F1);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF3E3E1F);
  static const Color borderColor = Color(0xFFB8B27A);
  static const Color labelColor = Color(0xFF8A8F4A);

  // ── Estado del formulario ───────────────────────────────────
  final TextEditingController _jefeCuadrillaCtrl =
  TextEditingController(text: 'Alejandro Ramírez');
  final TextEditingController _numTrabajadoresCtrl =
  TextEditingController(text: '12');
  final TextEditingController _ubicacionCtrl =
  TextEditingController(text: 'Parcela Norte - Sector B');

  final List<String> _plantillas = [
    'Plantilla: Cosecha Diaria (2024-05-15)',
    'Plantilla: Siembra General (2024-05-10)',
    'Plantilla: Riego Programado (2024-05-08)',
  ];
  String _plantillaSeleccionada = 'Plantilla: Cosecha Diaria (2024-05-15)';

  // ── Checklist ───────────────────────────────────────────────
  final List<ItemVerificacion> _checklist = [
    ItemVerificacion(label: 'Inspección de herramientas', completado: true),
    ItemVerificacion(label: 'Revisión de seguridad', completado: false),
    ItemVerificacion(label: 'Registro de insumos', completado: true),
    ItemVerificacion(label: 'Captura de datos climáticos', completado: false),
    ItemVerificacion(label: 'Validación de conteo', completado: false),
  ];

  // ── Estado del audio (simulado) ─────────────────────────────
  bool _grabando = false;
  bool _tieneGrabacion = true; // Simulamos que ya hay una grabación
  int _segundosGrabados = 195; // 03:15 en segundos
  Timer? _timer;

  // ── Animación de ondas ──────────────────────────────────────
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _jefeCuadrillaCtrl.dispose();
    _numTrabajadoresCtrl.dispose();
    _ubicacionCtrl.dispose();
    _timer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  // ── Lógica audio ────────────────────────────────────────────

  void _toggleGrabacion() {
    setState(() {
      if (_grabando) {
        _grabando = false;
        _tieneGrabacion = true;
        _timer?.cancel();
      } else {
        _grabando = true;
        _tieneGrabacion = false;
        _segundosGrabados = 0;
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() => _segundosGrabados++);
        });
      }
    });
  }

  String get _tiempoFormateado {
    final m = (_segundosGrabados ~/ 60).toString().padLeft(2, '0');
    final s = (_segundosGrabados % 60).toString().padLeft(2, '0');
    return '00:$m:$s';
  }

  // ── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Seleccionar plantilla'),
            const SizedBox(height: 8),
            _buildDropdownPlantilla(),
            const SizedBox(height: 22),
            _buildSectionLabel('Datos de la Cuadrilla'),
            const SizedBox(height: 10),
            _buildCampoTexto('Jefe de Cuadrilla', _jefeCuadrillaCtrl),
            const SizedBox(height: 10),
            _buildCampoTexto(
              'Número de Trabajadores',
              _numTrabajadoresCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            _buildCampoTexto('Ubicación', _ubicacionCtrl),
            const SizedBox(height: 22),
            _buildSectionLabel('Registro de Audio'),
            const SizedBox(height: 10),
            _buildAudioWidget(),
            const SizedBox(height: 22),
            _buildSectionLabel('Lista de Verificación'),
            const SizedBox(height: 10),
            _buildChecklist(),
            const SizedBox(height: 28),
            _buildBotonGuardar(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Ejecución de Tarea',
        style: TextStyle(
          color: Color(0xFF5B5B2E),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  // ── Label de sección ────────────────────────────────────────

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: labelColor,
      ),
    );
  }

  // ── Dropdown plantilla ──────────────────────────────────────

  Widget _buildDropdownPlantilla() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _plantillaSeleccionada,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: darkText),
          style: const TextStyle(
            fontSize: 14.5,
            color: Color(0xFF303030),
            fontFamily: 'sans-serif',
          ),
          onChanged: (val) {
            if (val != null) setState(() => _plantillaSeleccionada = val);
          },
          items: _plantillas
              .map(
                (p) => DropdownMenuItem(value: p, child: Text(p)),
          )
              .toList(),
        ),
      ),
    );
  }

  // ── Campo de texto ──────────────────────────────────────────

  Widget _buildCampoTexto(
      String label,
      TextEditingController ctrl, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF606060),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14.5, color: Color(0xFF1E1E1E)),
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: cardColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryColor, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // ── Widget de audio ─────────────────────────────────────────

  Widget _buildAudioWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        children: [
          // Botón micrófono
          GestureDetector(
            onTap: _toggleGrabacion,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _grabando
                        ? const Color(0xFFD94040)
                        : primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _grabando ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                if (!_grabando && _tieneGrabacion)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: primaryColor,
                      size: 13,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Visualizador de ondas
          Expanded(
            child: _grabando
                ? _buildOndasAnimadas()
                : _tieneGrabacion
                ? _buildOndasEstaticas()
                : const Text(
              'Presiona el micrófono para grabar',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Tiempo
          Text(
            _tiempoFormateado,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF404040),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOndasAnimadas() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(18, (i) {
            final double factor = (i % 3 == 0)
                ? _waveController.value
                : (i % 3 == 1)
                ? 1 - _waveController.value
                : 0.5 + _waveController.value * 0.4;
            final double height = 8 + factor * 26;
            return Container(
              width: 3.5,
              height: height,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildOndasEstaticas() {
    // Alturas fijas que simulan una grabación real
    const heights = [
      12.0, 22.0, 18.0, 30.0, 14.0, 28.0, 20.0, 32.0, 16.0,
      26.0, 12.0, 24.0, 34.0, 18.0, 22.0, 10.0, 28.0, 20.0,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: heights
          .map(
            (h) => Container(
          width: 3.5,
          height: h,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      )
          .toList(),
    );
  }

  // ── Checklist ───────────────────────────────────────────────

  Widget _buildChecklist() {
    return Column(
      children: _checklist
          .map((item) => _buildItemVerificacion(item))
          .toList(),
    );
  }

  Widget _buildItemVerificacion(ItemVerificacion item) {
    return GestureDetector(
      onTap: () => setState(() => item.completado = !item.completado),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.completado
                ? primaryColor.withOpacity(0.5)
                : borderColor.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Círculo de estado
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.completado
                    ? primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: item.completado
                      ? primaryColor
                      : Colors.grey.shade400,
                  width: 1.8,
                ),
              ),
              child: item.completado
                  ? const Icon(Icons.check, color: Colors.white, size: 15)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF303030),
                  ),
                  children: [
                    TextSpan(text: item.label),
                    TextSpan(
                      text: item.completado
                          ? '  (Completado)'
                          : '  (Pendiente)',
                      style: TextStyle(
                        color: item.completado
                            ? primaryColor
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Botón guardar ───────────────────────────────────────────

  Widget _buildBotonGuardar() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: _guardarProgreso,
        child: const Text(
          'Guardar progreso',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _guardarProgreso() {
    final completados =
        _checklist.where((e) => e.completado).length;
    final total = _checklist.length;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Progreso guardado: $completados/$total ítems completados',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}