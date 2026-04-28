// lib/Screens/RegistroIncidenciaScreen.dart
import 'package:flutter/material.dart';

enum NivelPrioridad { alta, media, baja }

enum EstadoIncidencia { abierta, enProceso, resuelta }

class Incidencia {
  final String id;
  final NivelPrioridad nivel;
  final String descripcion;
  final DateTime fechaCreacion;
  EstadoIncidencia estado;

  Incidencia({
    required this.id,
    required this.nivel,
    required this.descripcion,
    required this.fechaCreacion,
    this.estado = EstadoIncidencia.abierta,
  });
}

class RegistroIncidenciaScreen extends StatefulWidget {
  const RegistroIncidenciaScreen({super.key});

  @override
  State<RegistroIncidenciaScreen> createState() =>
      _RegistroIncidenciaScreenState();
}

class _RegistroIncidenciaScreenState extends State<RegistroIncidenciaScreen>
    with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);

  late AnimationController _animController;

  // Datos de prueba — cuando se conecte el backend se reemplaza por queries
  final List<Incidencia> _incidencias = [
    Incidencia(
      id: '1',
      nivel: NivelPrioridad.alta,
      descripcion: 'Fuga de agua en parcela 3B. Requiere atención inmediata.',
      fechaCreacion: DateTime.now().subtract(const Duration(minutes: 15)),
      estado: EstadoIncidencia.abierta,
    ),
    Incidencia(
      id: '2',
      nivel: NivelPrioridad.media,
      descripcion: 'Fallo en sensor de humedad, sector norte. Revisar conexión.',
      fechaCreacion: DateTime.now().subtract(const Duration(hours: 1)),
      estado: EstadoIncidencia.abierta,
    ),
    Incidencia(
      id: '3',
      nivel: NivelPrioridad.baja,
      descripcion: 'Herramientas olvidadas en campo. Recoger al finalizar turno.',
      fechaCreacion: DateTime.now().subtract(const Duration(hours: 3)),
      estado: EstadoIncidencia.resuelta,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Helpers de color y texto ──────────────────────────────────────────────

  Color _colorNivel(NivelPrioridad nivel) {
    switch (nivel) {
      case NivelPrioridad.alta:
        return const Color(0xFFE53E3E);
      case NivelPrioridad.media:
        return const Color(0xFFDD6B20);
      case NivelPrioridad.baja:
        return const Color(0xFF4A5C24);
    }
  }

  IconData _iconNivel(NivelPrioridad nivel) {
    switch (nivel) {
      case NivelPrioridad.alta:
        return Icons.local_fire_department;
      case NivelPrioridad.media:
        return Icons.build;
      case NivelPrioridad.baja:
        return Icons.eco;
    }
  }

  String _labelNivel(NivelPrioridad nivel) {
    switch (nivel) {
      case NivelPrioridad.alta:
        return 'Alta';
      case NivelPrioridad.media:
        return 'Media';
      case NivelPrioridad.baja:
        return 'Baja';
    }
  }

  Color _colorEstado(EstadoIncidencia estado) {
    switch (estado) {
      case EstadoIncidencia.abierta:
        return const Color(0xFFE53E3E);
      case EstadoIncidencia.enProceso:
        return const Color(0xFFDD6B20);
      case EstadoIncidencia.resuelta:
        return const Color(0xFF4A5C24);
    }
  }

  String _labelEstado(EstadoIncidencia estado) {
    switch (estado) {
      case EstadoIncidencia.abierta:
        return 'Abierta';
      case EstadoIncidencia.enProceso:
        return 'En proceso';
      case EstadoIncidencia.resuelta:
        return 'Resuelta';
    }
  }

  String _tiempoRelativo(DateTime fecha) {
    final diff = DateTime.now().difference(fecha);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} hora${diff.inHours > 1 ? 's' : ''}';
    return 'Hace ${diff.inDays} día${diff.inDays > 1 ? 's' : ''}';
  }

  // ── Diálogo para reportar nueva incidencia ────────────────────────────────

  Future<void> _mostrarDialogoNuevaIncidencia() async {
    NivelPrioridad nivelSeleccionado = NivelPrioridad.media;
    final TextEditingController descCtrl = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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
                'Nueva Incidencia',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              // Selector de nivel
              const Text(
                'Nivel de prioridad',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: NivelPrioridad.values.map((nivel) {
                  final selected = nivel == nivelSeleccionado;
                  final color = _colorNivel(nivel);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setModalState(() => nivelSeleccionado = nivel),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                          selected ? color.withOpacity(0.12) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected ? color : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _iconNivel(nivel),
                              color: selected ? color : Colors.grey,
                              size: 22,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _labelNivel(nivel),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: selected ? color : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Campo descripción
              const Text(
                'Descripción',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Describe la incidencia...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[50],
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
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
              const SizedBox(height: 24),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final desc = descCtrl.text.trim();
                    if (desc.isEmpty) return;

                    // TODO: cuando haya backend, guardar con Amplify.DataStore.save(...)
                    setState(() {
                      _incidencias.insert(
                        0,
                        Incidencia(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          nivel: nivelSeleccionado,
                          descripcion: desc,
                          fechaCreacion: DateTime.now(),
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text(
                    'Reportar Incidencia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
          'Registro de Incidencias',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Resumen rápido
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                _buildResumenChip(
                  label: 'Abiertas',
                  count: _incidencias
                      .where((i) => i.estado == EstadoIncidencia.abierta)
                      .length,
                  color: const Color(0xFFE53E3E),
                ),
                const SizedBox(width: 12),
                _buildResumenChip(
                  label: 'En proceso',
                  count: _incidencias
                      .where((i) => i.estado == EstadoIncidencia.enProceso)
                      .length,
                  color: const Color(0xFFDD6B20),
                ),
                const SizedBox(width: 12),
                _buildResumenChip(
                  label: 'Resueltas',
                  count: _incidencias
                      .where((i) => i.estado == EstadoIncidencia.resuelta)
                      .length,
                  color: const Color(0xFF4A5C24),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Lista de incidencias
          Expanded(
            child: _incidencias.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 64, color: primaryColor.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'Sin incidencias reportadas',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _incidencias.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, index) {
                final delay =
                Duration(milliseconds: 80 * index);
                return AnimatedBuilder(
                  animation: _animController,
                  builder: (ctx, child) {
                    final progress = Curves.easeOut.transform(
                      (((_animController.value * 1000) -
                          delay.inMilliseconds) /
                          400)
                          .clamp(0.0, 1.0),
                    );
                    return Opacity(
                      opacity: progress,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - progress)),
                        child: child,
                      ),
                    );
                  },
                  child: _buildIncidenciaCard(_incidencias[index]),
                );
              },
            ),
          ),
        ],
      ),

      // Botón inferior
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
          ),
          onPressed: _mostrarDialogoNuevaIncidencia,
          child: const Text(
            'Reportar Incidencia',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumenChip({
    required String label,
    required int count,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidenciaCard(Incidencia inc) {
    final nivelColor = _colorNivel(inc.nivel);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Barra lateral de color
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: nivelColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),

            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabecera: nivel + tiempo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(_iconNivel(inc.nivel),
                                color: nivelColor, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              _labelNivel(inc.nivel),
                              style: TextStyle(
                                color: nivelColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _tiempoRelativo(inc.fechaCreacion),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Descripción
                    Text(
                      inc.descripcion,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Badge estado + botón cambiar estado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _colorEstado(inc.estado).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _labelEstado(inc.estado),
                            style: TextStyle(
                              color: _colorEstado(inc.estado),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        // Botón para avanzar estado (solo si no está resuelta)
                        if (inc.estado != EstadoIncidencia.resuelta)
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                inc.estado =
                                inc.estado == EstadoIncidencia.abierta
                                    ? EstadoIncidencia.enProceso
                                    : EstadoIncidencia.resuelta;
                              });
                            },
                            child: Text(
                              inc.estado == EstadoIncidencia.abierta
                                  ? 'Marcar en proceso →'
                                  : 'Marcar resuelta →',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
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
}