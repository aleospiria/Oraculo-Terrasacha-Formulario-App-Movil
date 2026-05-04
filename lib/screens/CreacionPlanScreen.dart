// lib/Screens/CreacionPlanScreen.dart
import 'package:flutter/material.dart';

class CreacionPlanScreen extends StatefulWidget {
  const CreacionPlanScreen({super.key});

  @override
  State<CreacionPlanScreen> createState() => _CreacionPlanScreenState();
}

class _CreacionPlanScreenState extends State<CreacionPlanScreen> {
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);
  final Color cardColor = const Color(0xFFEEF2E6);
  final Color accentColor = const Color(0xFFC8A97A); // dorado pasos inactivos

  int _pasoActual = 1; // 1-4, luego 5 = resumen
  final int _totalPasos = 4;

  // ── Datos del plan que se van acumulando paso a paso ──────────────────────
  final TextEditingController _nombrePlanCtrl = TextEditingController();
  String? _ubicacionSeleccionada;
  final List<_UsuarioPlan> _usuariosSeleccionados = [];
  String? _checklistSeleccionado;
  String? _zonaSeleccionada;

  // Datos de prueba
  final List<String> _ubicaciones = [
    'Zona Norte - Parcela A',
    'Zona Sur - Lote B',
    'Lote Experimental 3',
    'Finca Principal',
  ];

  final List<_UsuarioPlan> _usuariosDisponibles = [
    _UsuarioPlan(nombre: 'Juan Pérez', rol: 'Operador',
        mediciones: ['Humedad', 'Calidad de Agua', 'Reforestación']),
    _UsuarioPlan(nombre: 'María Rodríguez', rol: 'Jefe',
        mediciones: ['Humedad', 'Calidad de Agua', 'Reforestación']),
    _UsuarioPlan(nombre: 'Carlos Gómez', rol: 'Operador',
        mediciones: ['Humedad', 'Calidad de Agua', 'Reforestación']),
    _UsuarioPlan(nombre: 'Ana Silva', rol: 'Operador',
        mediciones: ['Humedad', 'Calidad de Agua', 'Reforestación']),
    _UsuarioPlan(nombre: 'Pedro Ramos', rol: 'Operador',
        mediciones: ['Humedad', 'Calidad de Agua', 'Reforestación']),
  ];

  final List<String> _checklists = [
    'Mantenimiento de Cultivo v4',
    'Protocolo de Campo v2',
    'Inspección Fitosanitaria v1',
  ];

  final List<Map<String, String>> _requerimientos = [
    {
      'titulo': 'Equipo de Protección (EPP)',
      'subtitulo': 'Uso obligatorio de casco y botas de seguridad.',
      'icono': 'casco',
    },
    {
      'titulo': 'Calibración de Sensores',
      'subtitulo': 'Ajuste de precisión en sensores de suelo y aire.',
      'icono': 'sensor',
    },
    {
      'titulo': 'Registro de Coordenadas GPS',
      'subtitulo': 'Captura de puntos clave en la parcela 1.',
      'icono': 'gps',
    },
  ];

  final List<String> _zonas = [
    'Zona Norte - Parcela A',
    'Zona Sur - Lote B',
    'Lote Experimental 3',
  ];

  String _busquedaUsuario = '';

  @override
  void dispose() {
    _nombrePlanCtrl.dispose();
    super.dispose();
  }

  // ── Navegación entre pasos ────────────────────────────────────────────────

  void _continuar() {
    if (_pasoActual == 1 && _nombrePlanCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor ingresa el nombre del plan'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() {
      if (_pasoActual < _totalPasos) {
        _pasoActual++;
      } else {
        _pasoActual = 5; // resumen final
      }
    });
  }

  void _retroceder() {
    setState(() {
      if (_pasoActual > 1) _pasoActual--;
    });
  }

  // ── Indicador de pasos ────────────────────────────────────────────────────

  Widget _buildIndicadorPasos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPasos, (i) {
        final numero = i + 1;
        final completado = numero < _pasoActual;
        final activo = numero == _pasoActual;

        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completado || activo ? primaryColor : accentColor,
                border: Border.all(
                  color: completado || activo ? primaryColor : accentColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: completado
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Text(
                  '$numero',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            if (numero < _totalPasos)
              Container(
                width: 40,
                height: 2,
                color: numero < _pasoActual ? primaryColor : accentColor,
              ),
          ],
        );
      }),
    );
  }

  // ── Paso 1: Info básica ───────────────────────────────────────────────────

  Widget _buildPaso1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paso 1 de 4',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'Configura los elementos necesarios para la operación en campo.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
          ),
          const SizedBox(height: 28),

          const Text('Nombre del plan',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _nombrePlanCtrl,
            decoration: _inputDecoration('Ingresa el nombre del plan'),
          ),
          const SizedBox(height: 20),

          const Text('Ubicación',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          _buildDropdown(
            hint: 'Seleccionar ubicación',
            valor: _ubicacionSeleccionada,
            opciones: _ubicaciones,
            onChanged: (v) => setState(() => _ubicacionSeleccionada = v),
          ),
        ],
      ),
    );
  }

  // ── Paso 2: Equipo ────────────────────────────────────────────────────────

  Widget _buildPaso2() {
    final usuariosFiltrados = _usuariosDisponibles
        .where((u) =>
        u.nombre.toLowerCase().contains(_busquedaUsuario.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _busquedaUsuario = v),
            decoration: _inputDecoration('Buscar usuarios',
                prefixIcon: Icons.search),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Usuarios disponibles',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87)),
              Text(
                '(${_usuariosSeleccionados.length} Seleccionados)',
                style: TextStyle(color: primaryColor, fontSize: 13),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: usuariosFiltrados.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final usuario = usuariosFiltrados[i];
              final seleccionado = _usuariosSeleccionados
                  .any((u) => u.nombre == usuario.nombre);

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor.withOpacity(0.15),
                          radius: 22,
                          child: Text(
                            usuario.nombre[0],
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            usuario.nombre,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            if (seleccionado) {
                              _usuariosSeleccionados.removeWhere(
                                      (u) => u.nombre == usuario.nombre);
                            } else {
                              _usuariosSeleccionados.add(usuario);
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: seleccionado
                                  ? primaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: seleccionado
                                    ? primaryColor
                                    : Colors.grey[400]!,
                                width: 1.5,
                              ),
                            ),
                            child: seleccionado
                                ? const Icon(Icons.check,
                                color: Colors.white, size: 14)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildDropdownPequeno(usuario),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: usuario.mediciones.map((m) {
                        final activo = m != 'Reforestación';
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: activo
                                ? primaryColor
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                m,
                                style: TextStyle(
                                  color: activo ? Colors.white : Colors.grey[600],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (activo) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.check,
                                    color: Colors.white, size: 10),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownPequeno(_UsuarioPlan usuario) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: usuario.rol,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
          items: ['Operador', 'Jefe', 'Supervisor']
              .map((r) => DropdownMenuItem(
            value: r,
            child: Text(r, style: const TextStyle(fontSize: 12)),
          ))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => usuario.rol = v);
          },
        ),
      ),
    );
  }

  // ── Paso 3: Requerimientos ────────────────────────────────────────────────

  Widget _buildPaso3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera verde
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Requerimientos de Campo',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                SizedBox(height: 2),
                Text('(Paso 3 de 4)',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Configuración de lista de chequeo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildDropdown(
            hint: 'Seleccionar existente\nElegir una lista...',
            valor: _checklistSeleccionado,
            opciones: _checklists,
            onChanged: (v) => setState(() => _checklistSeleccionado = v),
          ),
          const SizedBox(height: 12),

          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(double.infinity, 50),
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.add, color: primaryColor),
            label: Text('Crear nueva',
                style: TextStyle(
                    color: primaryColor, fontWeight: FontWeight.w600)),
            onPressed: () {},
          ),
          const SizedBox(height: 24),

          const Text('Requerimientos de Campo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: _requerimientos.asMap().entries.map((entry) {
                final i = entry.key;
                final req = entry.value;
                final esUltimo = i == _requerimientos.length - 1;

                IconData icono;
                switch (req['icono']) {
                  case 'casco':
                    icono = Icons.safety_check_outlined;
                    break;
                  case 'sensor':
                    icono = Icons.build_outlined;
                    break;
                  default:
                    icono = Icons.location_on_outlined;
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(icono, color: primaryColor, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(req['titulo']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(req['subtitulo']!,
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!esUltimo) Divider(height: 1, color: Colors.grey[100]),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Paso 4: Topología ─────────────────────────────────────────────────────

  Widget _buildPaso4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuración de Topología',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text('Paso 4 de 4',
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Topología / Zona',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      hint: 'Seleccionar zona...',
                      valor: _zonaSeleccionada,
                      opciones: _zonas,
                      onChanged: (v) =>
                          setState(() => _zonaSeleccionada = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.map_outlined, color: primaryColor, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Paso 5: Resumen final ─────────────────────────────────────────────────

  Widget _buildResumenFinal() {
    final equipoTexto = _usuariosSeleccionados.isEmpty
        ? 'Sin equipo asignado'
        : '${_usuariosSeleccionados.length} Usuario${_usuariosSeleccionados.length > 1 ? 's' : ''}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resumen del Plan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildFilaResumen(
                  icono: Icons.assignment_outlined,
                  label: 'Nombre del Plan:',
                  valor: _nombrePlanCtrl.text.isNotEmpty
                      ? _nombrePlanCtrl.text
                      : 'Sin nombre',
                ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildFilaResumen(
                  icono: Icons.group_outlined,
                  label: 'Equipo:',
                  valor: equipoTexto,
                ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildFilaResumen(
                  icono: Icons.checklist_outlined,
                  label: 'Checklist Seleccionado:',
                  valor: _checklistSeleccionado ?? 'Sin checklist',
                ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildFilaResumen(
                  icono: Icons.location_on_outlined,
                  label: 'Plantilla/Zona:',
                  valor: _zonaSeleccionada ?? 'Sin zona',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilaResumen({
    required IconData icono,
    required String label,
    required String valor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: primaryColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 4),
                Text(valor,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers UI ────────────────────────────────────────────────────────────

  InputDecoration _inputDecoration(String hint, {IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.grey[400], size: 20)
          : null,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? valor,
    required List<String> opciones,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint,
              style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          value: valor,
          icon:
          Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
          items: opciones
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── Build principal ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final esResumen = _pasoActual == 5;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: esResumen ? Colors.white : backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: esResumen ? Colors.black87 : primaryColor, size: 18),
          onPressed: () {
            if (_pasoActual > 1) {
              _retroceder();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: esResumen
            ? const Text(
          'Resumen y Confirmación Final',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        )
            : _pasoActual == 2
            ? const Text(
          'Asignación de Equipo y Mediciones',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        )
            : null,
        // Barra de progreso en resumen
        bottom: esResumen
            ? PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Colors.grey[200],
            valueColor:
            AlwaysStoppedAnimation<Color>(primaryColor),
            minHeight: 4,
          ),
        )
            : null,
      ),
      body: Column(
        children: [
          // Cabecera pasos 1 y 4 (sin el indicador en paso 2 y 3 que tiene su propio header)
          if (!esResumen && _pasoActual != 2) ...[
            if (_pasoActual != 3)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  children: [
                    Text(
                      'Creación de Plan de Campo',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este plan es fundamental para organizar y asegurar el éxito de las operaciones en campo. Define los recursos y objetivos clave.',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildIndicadorPasos(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            if (_pasoActual == 3)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: _buildIndicadorPasos(),
              ),
          ],
          if (!esResumen && _pasoActual == 2)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                '(Paso 2 de 4)',
                style:
                TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ),

          // Contenido del paso actual
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.15, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: KeyedSubtree(
                key: ValueKey(_pasoActual),
                child: _buildContenidoPaso(),
              ),
            ),
          ),

          // Botón inferior
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: esResumen ? _crearPlan : _continuar,
                child: Text(
                  esResumen ? 'Crear plan' : 'Continuar',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),

          if (esResumen)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Terrasacha, 2024',
                style:
                TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContenidoPaso() {
    switch (_pasoActual) {
      case 1:
        return _buildPaso1();
      case 2:
        return _buildPaso2();
      case 3:
        return _buildPaso3();
      case 4:
        return _buildPaso4();
      case 5:
        return _buildResumenFinal();
      default:
        return _buildPaso1();
    }
  }

  Future<void> _crearPlan() async {
    // TODO: guardar con Amplify.DataStore.save(Plan(...))
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('¡Plan creado exitosamente!'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context, true);
  }
}

// ── Modelo local ──────────────────────────────────────────────────────────────

class _UsuarioPlan {
  final String nombre;
  String rol;
  final List<String> mediciones;

  _UsuarioPlan({
    required this.nombre,
    required this.rol,
    required this.mediciones,
  });
}