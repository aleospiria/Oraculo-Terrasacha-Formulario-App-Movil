// lib/Screens/TareasScreen.dart
import 'package:flutter/material.dart';

// ── Modelos locales (se reemplazarán con modelos de DataStore) ────────────────

enum EstadoTarea { enCurso, pendiente, completada }

class ItemChecklist {
  final String texto;
  bool completado;
  ItemChecklist({required this.texto, this.completado = false});
}

class Tarea {
  final String id;
  final String titulo;
  final String descripcion;
  final List<ItemChecklist> checklist;
  EstadoTarea estado;
  bool expandida;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.checklist,
    this.estado = EstadoTarea.enCurso,
    this.expandida = false,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen>
    with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);
  final Color cardColor = const Color(0xFFEEF2E6);

  late TabController _tabController;

  // Datos de prueba
  final List<Tarea> _tareas = [
    Tarea(
      id: '1',
      titulo: 'Levantamiento de Parcela Norte',
      descripcion: 'Revisar salud de los árboles y registrar datos de campo.',
      expandida: true,
      checklist: [
        ItemChecklist(texto: 'Identificar especie forestal'),
        ItemChecklist(texto: 'Medir DAP (Diámetro)'),
        ItemChecklist(texto: 'Registrar coordenadas GPS'),
        ItemChecklist(texto: 'Subir foto de la placa'),
      ],
    ),
    Tarea(
      id: '2',
      titulo: 'Censo de árboles nativos',
      descripcion: 'Conteo y registro de especies nativas en zona sur.',
      checklist: [
        ItemChecklist(texto: 'Delimitar zona de censo'),
        ItemChecklist(texto: 'Registrar especies encontradas'),
        ItemChecklist(texto: 'Fotografiar ejemplares'),
      ],
    ),
    Tarea(
      id: '3',
      titulo: 'Registro fitosanitario',
      descripcion: 'Evaluar estado sanitario de los árboles del predio.',
      estado: EstadoTarea.pendiente,
      checklist: [
        ItemChecklist(texto: 'Inspección visual de plagas'),
        ItemChecklist(texto: 'Tomar muestras de hojas'),
        ItemChecklist(texto: 'Completar formulario sanitario'),
      ],
    ),
    Tarea(
      id: '4',
      titulo: 'Inventario parcela sur',
      descripcion: 'Completar inventario de la última parcela del ciclo.',
      estado: EstadoTarea.completada,
      checklist: [
        ItemChecklist(texto: 'Contar individuos', completado: true),
        ItemChecklist(texto: 'Medir alturas', completado: true),
        ItemChecklist(texto: 'Enviar reporte', completado: true),
      ],
    ),
  ];

  List<Tarea> get _enCurso =>
      _tareas.where((t) => t.estado == EstadoTarea.enCurso).toList();
  List<Tarea> get _pendientes =>
      _tareas.where((t) => t.estado == EstadoTarea.pendiente).toList();
  List<Tarea> get _completadas =>
      _tareas.where((t) => t.estado == EstadoTarea.completada).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Diálogo nueva tarea ───────────────────────────────────────────────────

  Future<void> _mostrarDialogoNuevaTarea() async {
    final tituloCtrl = TextEditingController();
    String? proyectoSeleccionado;
    String? asignadoA;

    final proyectos = ['Meta Navajas', 'proyecto prueba', 'sisi'];
    final usuarios = ['Juan Pérez', 'María García', 'Carlos López'];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
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
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Crear nueva tarea',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              // Nombre de la tarea
              TextField(
                controller: tituloCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Registro fitosanitario',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[50],
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
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),

              // Proyecto asociado
              _buildDropdownModal(
                hint: 'Proyecto asociado',
                icono: Icons.folder_outlined,
                valor: proyectoSeleccionado,
                opciones: proyectos,
                onChanged: (v) => setModal(() => proyectoSeleccionado = v),
              ),
              const SizedBox(height: 12),

              // Asignar a
              _buildDropdownModal(
                hint: 'Asignar a',
                icono: Icons.person_outline,
                valor: asignadoA,
                opciones: usuarios,
                onChanged: (v) => setModal(() => asignadoA = v),
              ),
              const SizedBox(height: 24),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        final titulo = tituloCtrl.text.trim();
                        if (titulo.isEmpty) return;
                        setState(() {
                          _tareas.insert(
                            0,
                            Tarea(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              titulo: titulo,
                              descripcion: proyectoSeleccionado != null
                                  ? 'Proyecto: $proyectoSeleccionado'
                                  : 'Sin proyecto asociado',
                              checklist: [],
                              estado: EstadoTarea.pendiente,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Crear tarea',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownModal({
    required String hint,
    required IconData icono,
    required String? valor,
    required List<String> opciones,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icono, color: Colors.grey[400], size: 18),
              const SizedBox(width: 8),
              Text(hint, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
            ],
          ),
          value: valor,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
          items: opciones
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChanged,
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
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: primaryColor, size: 16),
                Text(
                  'Terrasacha',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 120,
        title: const Text(
          'Tareas',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          tabs: [
            Tab(text: 'En curso (${_enCurso.length})'),
            Tab(text: 'Pendientes (${_pendientes.length})'),
            Tab(text: 'Completadas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListaTareas(_enCurso),
          _buildListaTareas(_pendientes),
          _buildListaTareas(_completadas),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _mostrarDialogoNuevaTarea,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildListaTareas(List<Tarea> tareas) {
    if (tareas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 64, color: primaryColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'Sin tareas aquí',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tareas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _buildTareaCard(tareas[i]),
    );
  }

  Widget _buildTareaCard(Tarea tarea) {
    final completados =
        tarea.checklist.where((c) => c.completado).length;
    final total = tarea.checklist.length;
    final progreso = total > 0 ? completados / total : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cabecera
          GestureDetector(
            onTap: () => setState(() => tarea.expandida = !tarea.expandida),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: tarea.expandida ? cardColor : Colors.white,
                borderRadius: tarea.expandida
                    ? const BorderRadius.vertical(top: Radius.circular(14))
                    : BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tarea.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(Icons.person_outline, color: Colors.grey[400], size: 20),
                  const SizedBox(width: 6),
                  Icon(
                    tarea.expandida
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),

          // Contenido expandido
          if (tarea.expandida) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descripción
                  Text(
                    tarea.descripcion,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Checklist
                  if (tarea.checklist.isNotEmpty) ...[
                    ...tarea.checklist.map(
                          (item) => GestureDetector(
                        onTap: () =>
                            setState(() => item.completado = !item.completado),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: item.completado
                                      ? primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: item.completado
                                        ? primaryColor
                                        : Colors.grey[400]!,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: item.completado
                                    ? const Icon(Icons.check,
                                    color: Colors.white, size: 12)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.texto,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: item.completado
                                        ? Colors.grey[400]
                                        : Colors.black87,
                                    decoration: item.completado
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Barra de progreso
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progreso,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                        AlwaysStoppedAnimation<Color>(primaryColor),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completados de $total completados',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11,
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Botón marcar completada
                  if (tarea.estado != EstadoTarea.completada)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            tarea.estado = EstadoTarea.completada;
                            tarea.expandida = false;
                            // Marcar todos los items del checklist
                            for (var item in tarea.checklist) {
                              item.completado = true;
                            }
                          });
                        },
                        child: const Text(
                          'Marcar como completada',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}