import 'package:flutter/material.dart';
import '../theme.dart';

class FinalizarTareaScreen extends StatefulWidget {
  final String tituloTarea;
  final String? featureNombre;
  final int checklistCompletados;
  final int checklistTotal;
  final int evidenciasCount;

  const FinalizarTareaScreen({
    super.key,
    required this.tituloTarea,
    this.featureNombre,
    required this.checklistCompletados,
    required this.checklistTotal,
    required this.evidenciasCount,
  });

  @override
  State<FinalizarTareaScreen> createState() => _FinalizarTareaScreenState();
}

class _FinalizarTareaScreenState extends State<FinalizarTareaScreen> {
  static const Color primaryColor = terrasachaPrimaryColor;
  static const Color backgroundColor = terrasachaBackgroundColor;

  bool _protocoloConfirmado = false;
  bool _cerrando = false;

  double get _checklistRatio {
    if (widget.checklistTotal <= 0) return 0;
    return (widget.checklistCompletados / widget.checklistTotal).clamp(0.0, 1.0);
  }

  int get _checklistPct => (_checklistRatio * 100).round();

  String get _checklistTexto {
    if (widget.checklistTotal <= 0) return 'Checklist: sin datos del día';
    return 'Checklist: $_checklistPct% '
        '(${widget.checklistCompletados}/${widget.checklistTotal})';
  }

  Future<void> _finalizar(BuildContext context) async {
    if (!_protocoloConfirmado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes confirmar el protocolo antes de cerrar'),
        ),
      );
      return;
    }

    setState(() => _cerrando = true);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro finalizado correctamente'),
        backgroundColor: primaryColor,
      ),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _volverAEdicion(BuildContext context) {
    Navigator.pop(context);
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
          'Finalizar tarea',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    widget.tituloTarea,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  if (widget.featureNombre != null &&
                      widget.featureNombre!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.featureNombre!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChecklistIndicator(),
                      const SizedBox(width: 36),
                      _buildEvidenciasIndicator(),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 24),
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
                              const TextSpan(
                                text: '¿Confirmas que el protocolo se ha cumplido '
                                    'totalmente para respaldo? ',
                              ),
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
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _protocoloConfirmado = !_protocoloConfirmado),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: _protocoloConfirmado
                            ? primaryColor.withValues(alpha: 0.08)
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: [
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
                      onPressed: _cerrando ? null : () => _finalizar(context),
                      icon: _cerrando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline, size: 20),
                      label: Text(
                        _cerrando ? 'Cerrando...' : 'Finalizar',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: () => _volverAEdicion(context),
                      child: Text(
                        'Volver a edición',
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

  Widget _buildChecklistIndicator() {
    final completado = _checklistRatio >= 1.0;

    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: _checklistRatio,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  completado ? Icons.check_circle : Icons.playlist_add_check_circle_outlined,
                  size: 34,
                  color: completado ? primaryColor : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _checklistTexto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

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
        Text(
          'Evidencias: ${widget.evidenciasCount} foto(s)',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _mostrarInfoProtocolo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Información'),
        content: const Text(
          'Al confirmar, certificas que todos los pasos del protocolo fueron '
          'completados correctamente y que las evidencias adjuntas respaldan '
          'la ejecución de la tarea.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Entendido',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );

  }
}
