// lib/screens/EjecucionRegistroScreen.dart
import 'package:flutter/material.dart';
import 'package:capturador_datos_offline/utils/servicio_audios.dart';
import 'package:capturador_datos_offline/screens/FinalizarTareaScreen.dart';

class EjecucionRegistroScreen extends StatefulWidget {
  const EjecucionRegistroScreen({super.key});

  @override
  State<EjecucionRegistroScreen> createState() => _EjecucionRegistroScreenState();
}

class _EjecucionRegistroScreenState extends State<EjecucionRegistroScreen> {
  static const Color primaryColor = Color(0xFF4A5C24);
  static const Color backgroundColor = Color(0xFFF7F8F6);

  String? _rutaAudio;
  final TextEditingController _observacionesCtrl = TextEditingController();
  bool _tareaFinalizada = false;

  @override
  void dispose() {
    _observacionesCtrl.dispose();
    super.dispose();
  }

  void _finalizarTarea(BuildContext context) {
    if (_rutaAudio == null && _observacionesCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un audio o una observación')),
      );
      return;
    }

    debugPrint('Audio guardado: $_rutaAudio');
    debugPrint('Observaciones: ${_observacionesCtrl.text}');

    // TODO: Guardar en tu base de datos local aquí

    setState(() => _tareaFinalizada = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro guardado exitosamente'),
        backgroundColor: primaryColor,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FinalizarTareaScreen()),
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              radius: 18,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === Info de la tarea ===
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment, color: primaryColor, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mantenimiento de Sensor #45B',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Finca La Esperanza, Lote 7',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
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
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // === Grabador de Audio ===
            grabadorAudio(
              onGrabacionCompleta: (path) {
                setState(() => _rutaAudio = path);
                debugPrint('Audio capturado: $path');
              },
            ),
            const SizedBox(height: 24),

            // === Observaciones ===
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_note, color: primaryColor, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Observaciones',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _observacionesCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Escribe tus observaciones aquí...',
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
                ],
              ),
            ),
            const SizedBox(height: 32),

            // === Botón Finalizar ===
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tareaFinalizada ? Colors.grey : primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: _tareaFinalizada ? null : () => _finalizarTarea(context),
                icon: Icon(_tareaFinalizada ? Icons.check : Icons.save),
                label: Text(
                  _tareaFinalizada ? 'Registro Guardado' : 'Finalizar y Guardar',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}