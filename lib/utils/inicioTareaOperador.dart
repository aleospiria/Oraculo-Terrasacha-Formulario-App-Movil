// lib/Utils/
// .dart
import 'package:flutter/material.dart';
import 'package:capturador_datos_offline/screens/EjecucionRegistroScreen.dart';

class InicioTareaOperador {
  static const Color primaryColor = Color(0xFF4A5C24);
  static const Color backgroundColor = Color(0xFFF7F8F6);

  /// Llamar desde cualquier Screen:
  /// InicioTareaOperador.show(context);
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const _ContenidoTarea(),
        ),
      ),
    );
  }

  /// Alternativa: navegar como pantalla completa
  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InicioTareaOperadorScreen()),
    );
  }
}

/// Screen completa (para usar con navigate)
class InicioTareaOperadorScreen extends StatelessWidget {
  const InicioTareaOperadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InicioTareaOperador.backgroundColor,
      appBar: AppBar(
        backgroundColor: InicioTareaOperador.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Inicio de Tarea Operador',
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
      body: const _ContenidoTarea(),
    );
  }
}

/// Widget interno con todo el contenido visual
class _ContenidoTarea extends StatelessWidget {
  const _ContenidoTarea();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Indicador sync offline
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                'Sincronizado sin conexión',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Card de la tarea
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  const Text(
                    'Tarea: Mantenimiento de Sensor #45B',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ubicación: Finca La Esperanza, Lote 7',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),

                  // Mapa placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      color: const Color(0xFFE8EDE0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Fondo degradado simulando mapa
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFD4DFC7).withOpacity(0.5),
                                  const Color(0xFFE8EDE0),
                                  const Color(0xFFF0F3EB),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          // Líneas simulando caminos
                          CustomPaint(
                            size: const Size(double.infinity, 160),
                            painter: _CaminosPainter(),
                          ),
                          // Pin
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 2)),
                                  ],
                                ),
                                child: const Icon(Icons.location_on, color: InicioTareaOperador.primaryColor, size: 28),
                              ),
                              Container(
                                width: 2,
                                height: 8,
                                color: InicioTareaOperador.primaryColor.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Estado
                  Row(
                    children: [
                      const Text(
                        'Estado Actual:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Pendiente',
                          style: TextStyle(
                            color: Color(0xFFB8860B),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Botón Iniciar Tarea
          SizedBox(
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: InicioTareaOperador.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EjecucionRegistroScreen()),
                );
              },
              child: const Text(
                'Iniciar Tarea',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pinta líneas curvas simulando caminos de mapa
class _CaminosPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCDD8BE)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final p1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.25, size.width * 0.6, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.4, size.width, size.height * 0.3);
    canvas.drawPath(p1, paint);

    final p2 = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.65, size.width * 0.7, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.8, size.width, size.height * 0.7);
    canvas.drawPath(p2, paint);

    final p3 = Path()
      ..moveTo(size.width * 0.5, 0)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.5, size.width * 0.55, size.height);
    canvas.drawPath(p3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}