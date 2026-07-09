// lib/Screens/TareasScreen.dart
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';
import '../screens/EjecucionRegistroScreen.dart';
import '../utils/roles_campo.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_salida.dart';

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
  final String? salidaId;
  final String? asignacionId;
  final String? ubicacionRuta;
  final List<String> featureNombres;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.checklist,
    this.estado = EstadoTarea.enCurso,
    this.expandida = false,
    this.salidaId,
    this.asignacionId,
    this.ubicacionRuta,
    this.featureNombres = const [],
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
  bool _cargando = true;

  final List<Tarea> _tareas = [];

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
    _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    setState(() => _cargando = true);

    final usuario = await servicioAutenticacion.getUsuarioActual();
    if (usuario == null) {
      if (mounted) setState(() => _cargando = false);
      return;
    }

    final vistas = await ServicioSalida.listarTareasParaUsuario(usuario);

    if (!mounted) return;
    setState(() {
      _tareas
        ..clear()
        ..addAll(vistas.map(_tareaDesdeVista));
      _cargando = false;
    });
  }

  Tarea _tareaDesdeVista(TareaSalidaVista vista) {
    final estado = switch (vista.estado) {
      EstadoTareaSalida.completada => EstadoTarea.completada,
      EstadoTareaSalida.enCurso => EstadoTarea.enCurso,
      EstadoTareaSalida.pendiente => EstadoTarea.pendiente,
    };

    return Tarea(
      id: vista.asignacionId,
      salidaId: vista.salidaId,
      asignacionId: vista.asignacionId,
      titulo: vista.templateNombre,
      descripcion:
          '${vista.salidaNombre} · ${vista.featureNombres.join(', ')}',
      ubicacionRuta: vista.ubicacionRuta,
      featureNombres: vista.featureNombres,
      estado: estado,
      checklist: vista.featureNombres
          .map((f) => ItemChecklist(texto: f))
          .toList(),
    );
  }

  Future<void> _abrirEjecucion(Tarea tarea) async {
    if (tarea.salidaId == null || tarea.asignacionId == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EjecucionRegistroScreen(
          salidaId: tarea.salidaId,
          asignacionId: tarea.asignacionId,
          tituloTarea: tarea.titulo,
          ubicacionRuta: tarea.ubicacionRuta,
          featureNombres: tarea.featureNombres,
        ),
      ),
    );

    if (!mounted) return;
    await _cargarTareas();
  }

  Future<void> _marcarCompletada(Tarea tarea) async {
    if (tarea.salidaId != null && tarea.asignacionId != null) {
      await ServicioSalida.actualizarEstadoAsignacion(
        salidaId: tarea.salidaId!,
        asignacionId: tarea.asignacionId!,
        estado: EstadoAsignacionEjecucion.completada,
      );
    }
    setState(() => tarea.estado = EstadoTarea.completada);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        actions: [
          if (RolesCampo.puedeReportarIncidencias(currentUserRole))
            IconButton(
              tooltip: 'Reportar incidencia',
              icon: Icon(Icons.warning_amber_outlined, color: primaryColor),
              onPressed: () => Navigator.pushNamed(context, '/incidencias'),
            ),
        ],
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
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : TabBarView(
        controller: _tabController,
        children: [
          _buildListaTareas(_enCurso),
          _buildListaTareas(_pendientes),
          _buildListaTareas(_completadas),
        ],
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

                  if (tarea.estado != EstadoTarea.completada &&
                      tarea.salidaId != null &&
                      tarea.asignacionId != null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _abrirEjecucion(tarea),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text(
                          'Ejecutar registro',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  if (tarea.estado != EstadoTarea.completada) ...[
                    if (tarea.salidaId != null && tarea.asignacionId != null)
                      const SizedBox(height: 10),
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
                        onPressed: () async {
                          await _marcarCompletada(tarea);
                          if (!mounted) return;
                          setState(() {
                            tarea.expandida = false;
                            for (final item in tarea.checklist) {
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
                  ],
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