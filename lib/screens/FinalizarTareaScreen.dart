// lib/screens/FinalizarTareaScreen.dart
import 'package:flutter/material.dart';

class FinalizarTareaScreen extends StatefulWidget {
  const FinalizarTareaScreen({super.key});

  @override
  State<FinalizarTareaScreen> createState() => _FinalizarTareaScreenState();
}

class _FinalizarTareaScreenState extends State<FinalizarTareaScreen> {
  static const Color primaryColor = Color(0xFF4A5C24);
  static const Color backgroundColor = Color(0xFFF7F8F6);

  bool _protocoloConfirmado = false;
  bool _sincronizando = false;

  void _finalizarYSincronizar(BuildContext context) async {
    if (!_protocoloConfirmado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes confirmar el protocolo antes de finalizar')),
      );
      return;
    }

    setState(() => _sincronizando = true);

    // TODO: Lógica de sincronización con backend
    await Future.delayed(const Duration(seconds: 2)); // Simula sync

    if (!mounted) return;
    setState(() => _sincronizando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarea finalizada y sincronizada'),
        backgroundColor: primaryColor,
      ),
    );

    // Volver al inicio (pop todas las pantallas del flujo)
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _guardarBorrador(BuildContext context) {
    // TODO: Guardar en base de datos local como borrador
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Guardado como borrador')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Finalizar Tarea',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 18,
              child: Icon(Icons.person, color: Colors.grey.shade600, size: 20),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // === Indicadores: Checklist + Evidencias ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Checklist circular
                      _buildChecklistIndicator(),
                      const SizedBox(width: 40),
                      // Evidencias
                      _buildEvidenciasIndicator(),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // === Separador ===
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 30),

                  // === Pregunta de confirmación ===
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            children: [
                              const TextSpan(text: '¿Confirmas que el protocolo se ha cumplido totalmente para respaldo? '),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: GestureDetector(
                                  onTap: () => _mostrarInfoProtocolo(context),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 22,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // === Toggle de confirmación ===
                  GestureDetector(
                    onTap: () {
                      setState(() => _protocoloConfirmado = !_protocoloConfirmado);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: _protocoloConfirmado
                            ? primaryColor.withOpacity(0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _protocoloConfirmado
                              ? primaryColor
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _protocoloConfirmado
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: _protocoloConfirmado
                                ? primaryColor
                                : Colors.grey.shade400,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sí, confirmo el cumplimiento total',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _protocoloConfirmado
                                    ? primaryColor
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // === Botones inferiores ===
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: [
                  // Botón Finalizar y Sincronizar
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _protocoloConfirmado
                            ? primaryColor
                            : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: _protocoloConfirmado ? 2 : 0,
                      ),
                      onPressed: _sincronizando
                          ? null
                          : () => _finalizarYSincronizar(context),
                      icon: _sincronizando
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.ios_share, size: 20),
                      label: Text(
                        _sincronizando
                            ? 'Sincronizando...'
                            : 'Finalizar y Sincronizar',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Botón Guardar como borrador
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: () => _guardarBorrador(context),
                      child: Text(
                        'Guardar como borrador',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === Indicador circular de Checklist ===
  Widget _buildChecklistIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Círculo de progreso
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: 1.0, // 100%
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              // Ícono check
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 36,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Checklist: 100%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // === Indicador de Evidencias ===
  Widget _buildEvidenciasIndicator() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.photo_library_outlined,
            size: 40,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Evidencias: 12 fotos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // === Diálogo info del protocolo ===
  void _mostrarInfoProtocolo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Información'),
        content: const Text(
          'Al confirmar, certificas que todos los pasos del protocolo '
              'fueron completados correctamente y que las evidencias '
              'adjuntas respaldan la ejecución de la tarea.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }
}