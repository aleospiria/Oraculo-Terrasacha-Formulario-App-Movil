// lib/Screens/ReportarIncidenciaScreen.dart
import 'package:flutter/material.dart';

class ReportarIncidenciaScreen extends StatefulWidget {
  const ReportarIncidenciaScreen({super.key});

  @override
  State<ReportarIncidenciaScreen> createState() =>
      _ReportarIncidenciaScreenState();
}

class _ReportarIncidenciaScreenState extends State<ReportarIncidenciaScreen> {
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color accentColor = const Color(0xFFD4AF37); // dorado del botón del diseño
  final Color backgroundColor = const Color(0xFFF7F8F6);

  final TextEditingController _descripcionCtrl = TextEditingController();
  String? _usuarioSeleccionado;
  String? _imagenEvidencia; // En el futuro: ruta/url de la imagen

  // Usuarios de prueba — se reemplazará con query al backend
  final List<String> _usuarios = [
    'Juan Pérez',
    'María García',
    'Carlos López',
    'Ana Martínez',
  ];

  bool _enviando = false;

  @override
  void dispose() {
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarUsuario() async {
    final resultado = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Seleccionar usuario afectado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ..._usuarios.map((u) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Text(
                  u[0],
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(u),
              trailing: _usuarioSeleccionado == u
                  ? Icon(Icons.check_circle, color: primaryColor)
                  : null,
              onTap: () => Navigator.pop(ctx, u),
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (resultado != null) {
      setState(() => _usuarioSeleccionado = resultado);
    }
  }

  Future<void> _subirEvidencia() async {
    // TODO: cuando haya backend, conectar con image_picker y subir a S3/Storage
    // Por ahora simula que se seleccionó una imagen
    setState(() => _imagenEvidencia = 'evidencia_simulada.jpg');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Evidencia adjuntada (simulado)'),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _enviarReporte() async {
    final desc = _descripcionCtrl.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor escribe una descripción'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _enviando = true);

    // TODO: cuando haya backend, guardar con Amplify.DataStore.save(Incidencia(...))
    await Future.delayed(const Duration(milliseconds: 800)); // simula guardado

    if (!mounted) return;
    setState(() => _enviando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reporte enviado exitosamente'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context, true); // devuelve true para que RegistroIncidencia refresque
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reporte de Incidencias en Campo',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título grande
            const Text(
              'Reportar Incidencia',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 32),

            // ── Descripción ──────────────────────────────────────────────
            const Text(
              'Descripción del evento',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descripcionCtrl,
              maxLines: 5,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Describe lo sucedido, ubicación y detalles...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
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
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),

            // ── Usuario afectado ─────────────────────────────────────────
            const Text(
              'Usuario Afectado',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _seleccionarUsuario,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _usuarioSeleccionado ??
                            'Seleccionar equipo (Ej. Juan Pérez)',
                        style: TextStyle(
                          color: _usuarioSeleccionado != null
                              ? Colors.black87
                              : Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Evidencia ────────────────────────────────────────────────
            GestureDetector(
              onTap: _subirEvidencia,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _imagenEvidencia != null
                          ? Icons.check_circle_outline
                          : Icons.camera_alt_outlined,
                      color: _imagenEvidencia != null
                          ? primaryColor
                          : Colors.black87,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _imagenEvidencia != null
                          ? 'Evidencia adjuntada ✓'
                          : 'Subir Evidencia de Incidencia',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: _imagenEvidencia != null
                            ? primaryColor
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 120), // espacio para el botón fijo
          ],
        ),
      ),

      // ── Botón fijo inferior ──────────────────────────────────────────────
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4B483), // dorado del diseño
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFD4B483).withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: _enviando ? null : _enviarReporte,
            child: _enviando
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text(
              'Enviar Reporte',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}