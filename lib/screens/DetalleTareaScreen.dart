// lib/Screens/DetalleTareaScreen.dart
import 'package:flutter/material.dart';
import 'package:capturador_datos_offline/screens/EjecucionTareaScreen.dart';

class TareaDetalle {
  final String operador;
  final String ubicacion;
  final String estado;
  final String duracion;
  final int progreso; // 0 – 100
  final List<String> checklist;
  final List<String> evidencias; // rutas de assets o URLs (aquí usamos placeholders)

  const TareaDetalle({
    required this.operador,
    required this.ubicacion,
    required this.estado,
    required this.duracion,
    required this.progreso,
    required this.checklist,
    required this.evidencias,
  });
}

// ──────────────────────────────────────────────────────────────
//  Pantalla
// ──────────────────────────────────────────────────────────────
class DetalleTareaScreen extends StatefulWidget {
  final TareaDetalle tarea;

  const DetalleTareaScreen({super.key, required this.tarea});

  @override
  State<DetalleTareaScreen> createState() => _DetalleTareaScreenState();
}

class _DetalleTareaScreenState extends State<DetalleTareaScreen>
    with SingleTickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF8A8F4A);
  static const Color backgroundColor = Color(0xFFF8F7F1);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF3E3E1F);
  static const Color borderColor = Color(0xFFB8B27A);

  late AnimationController _animController;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _progressAnim = Tween<double>(
      begin: 0,
      end: widget.tarea.progreso / 100,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────────────────────

  String get _badgeLabel {
    switch (widget.tarea.estado) {
      case 'Completado':
        return 'Completado';
      case 'Validación':
        return 'Revisión';
      case 'En progreso':
        return 'En progreso';
      default:
        return 'Pendiente';
    }
  }

  Color get _badgeColor {
    switch (widget.tarea.estado) {
      case 'Completado':
        return primaryColor;
      case 'Validación':
        return const Color(0xFFD4890A);
      case 'En progreso':
        return const Color(0xFF4A7FA5);
      default:
        return Colors.grey.shade600;
    }
  }

  // ── build ───────────────────────────────────────────────────

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
            _buildResumenCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Checklist completado'),
            const SizedBox(height: 12),
            _buildChecklist(),
            const SizedBox(height: 24),
            _buildSectionTitle('Evidencias'),
            const SizedBox(height: 12),
            _buildEvidencias(),
            const SizedBox(height: 32),
            _buildActionButtons(),
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
        'Detalle de Tarea',
        style: TextStyle(
          color: Color(0xFF5B5B2E),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Chip(
            label: Text(
              _badgeLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: _badgeColor,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  // ── Resumen ─────────────────────────────────────────────────

  Widget _buildResumenCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de la Actividad',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 14),
          _buildResumenRow('Operador:', widget.tarea.operador),
          const SizedBox(height: 6),
          _buildResumenRow('Ubicación:', widget.tarea.ubicacion),
          const SizedBox(height: 6),
          _buildResumenRow('Duración:', widget.tarea.duracion),
          const SizedBox(height: 6),
          _buildResumenRow(
            'Progreso:',
            '${widget.tarea.progreso}%'
                '${widget.tarea.progreso == 100 ? ' (Completado)' : ''}',
          ),
          const SizedBox(height: 12),
          // Barra de progreso animada
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AnimatedBuilder(
              animation: _progressAnim,
              builder: (_, __) => LinearProgressIndicator(
                value: _progressAnim.value,
                minHeight: 8,
                backgroundColor: const Color(0xFFE4E4D0),
                valueColor:
                const AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14.5, color: Color(0xFF303030)),
        children: [
          TextSpan(
            text: '$label  ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  // ── Checklist ───────────────────────────────────────────────

  Widget _buildChecklist() {
    return Column(
      children: widget.tarea.checklist
          .map((item) => _buildCheckItem(item))
          .toList(),
    );
  }

  Widget _buildCheckItem(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14.5,
                color: Color(0xFF303030),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Evidencias ──────────────────────────────────────────────

  Widget _buildEvidencias() {
    // Usamos placeholder de red para demo; en producción serían assets o URLs reales.
    const placeholders = [
      'https://picsum.photos/seed/soil/200/200',
      'https://picsum.photos/seed/tools/200/200',
      'https://picsum.photos/seed/crops/200/200',
      'https://picsum.photos/seed/tablet/200/200',
    ];

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: placeholders.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showEvidenciaDialog(placeholders[index]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                placeholders[index],
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 88,
                  height: 88,
                  color: const Color(0xFFE4E4D0),
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: Colors.grey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEvidenciaDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  // ── Botones ─────────────────────────────────────────────────

  Widget _buildActionButtons() {
    final bool completado = widget.tarea.estado == 'Completado';

    return Column(
      children: [
        // Botón principal
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              if (completado) {
                _showActionSnackbar('Checklist validado ✓');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EjecucionTareaScreen(),
                  ),
                );
              }
            },
            child: Text(
              completado ? 'Validar checklist' : 'Marcar como completado',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Botón secundario
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: darkText,
              side: BorderSide(color: borderColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => _showActionSnackbar('Abriendo editor…'),
            child: const Text(
              'Editar / completar',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ─────────────────────────────────────────────────

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
    );
  }

  void _showActionSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}