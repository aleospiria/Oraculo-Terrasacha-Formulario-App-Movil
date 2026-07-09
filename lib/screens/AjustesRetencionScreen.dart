import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/plan_campo_borrador.dart';
import '../utils/servicio_configuracion_retencion.dart';

/// Pantalla de ajustes para el tiempo de caducidad (retención) de datos
/// en el dispositivo. El valor es global y por defecto es de 30 días.
class AjustesRetencionScreen extends StatefulWidget {
  const AjustesRetencionScreen({super.key});

  @override
  State<AjustesRetencionScreen> createState() => _AjustesRetencionScreenState();
}

class _AjustesRetencionScreenState extends State<AjustesRetencionScreen> {
  static const Color primaryColor = Color(0xFF4A5C24);
  static const Color backgroundColor = Color(0xFFF7F8F6);
  static const Color cardColor = Color(0xFFEEF2E6);

  late int _diasSeleccionados;
  final TextEditingController _personalizadoCtrl = TextEditingController();
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _diasSeleccionados = ServicioConfiguracionRetencion.diasActuales;
    if (!ServicioConfiguracionRetencion.presets.contains(_diasSeleccionados)) {
      _personalizadoCtrl.text = _diasSeleccionados.toString();
    }
  }

  @override
  void dispose() {
    _personalizadoCtrl.dispose();
    super.dispose();
  }

  bool get _esPreset =>
      ServicioConfiguracionRetencion.presets.contains(_diasSeleccionados);

  void _seleccionarPreset(int dias) {
    setState(() {
      _diasSeleccionados = dias;
      _personalizadoCtrl.clear();
    });
    FocusScope.of(context).unfocus();
  }

  void _onPersonalizadoChanged(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return;
    setState(() => _diasSeleccionados = parsed);
  }

  Future<void> _guardar() async {
    final dias = _diasSeleccionados;
    if (dias < ServicioConfiguracionRetencion.minDias ||
        dias > ServicioConfiguracionRetencion.maxDias) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ingresa un valor entre ${ServicioConfiguracionRetencion.minDias} '
            'y ${ServicioConfiguracionRetencion.maxDias} días',
          ),
        ),
      );
      return;
    }

    setState(() => _guardando = true);
    final guardado = await ServicioConfiguracionRetencion.guardar(dias);
    if (!mounted) return;
    setState(() {
      _guardando = false;
      _diasSeleccionados = guardado;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Caducidad actualizada a $guardado días'),
        backgroundColor: primaryColor,
      ),
    );
    Navigator.pop(context, guardado);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Caducidad de datos',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          const Text(
            'Tiempo de caducidad',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Los datos se eliminan del dispositivo al cumplir este tiempo. '
            'Por defecto son ${SalidaCampo.diasRetencionPorDefecto} días.',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          _buildPresets(),
          const SizedBox(height: 20),
          _buildPersonalizado(),
          const SizedBox(height: 12),
          _buildNotaGracia(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: _guardando ? null : _guardar,
            child: _guardando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Guardar cambios',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule, color: primaryColor, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Valor actual',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_diasSeleccionados días',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresets() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ServicioConfiguracionRetencion.presets.map((dias) {
        final seleccionado = _esPreset && _diasSeleccionados == dias;
        return ChoiceChip(
          label: Text('$dias días'),
          selected: seleccionado,
          onSelected: (_) => _seleccionarPreset(dias),
          selectedColor: primaryColor,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: seleccionado ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: seleccionado ? primaryColor : Colors.grey[300]!,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPersonalizado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personalizado',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _personalizadoCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: _onPersonalizadoChanged,
          decoration: InputDecoration(
            hintText:
                'Entre ${ServicioConfiguracionRetencion.minDias} y ${ServicioConfiguracionRetencion.maxDias} días',
            suffixText: 'días',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildNotaGracia() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Los datos que aún no se han sincronizado con la nube tienen '
            '${SalidaCampo.diasGraciaSinSync} días de gracia adicionales antes '
            'de eliminarse definitivamente.',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}
