import '../theme.dart';
// lib/Screens/TareasScreen.dart
import 'package:flutter/material.dart';

import '../models/usuario_campo.dart';
import '../screens/EjecucionRegistroScreen.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_salida.dart';

// ── Modelos locales (se reemplazarán con modelos de DataStore) ────────────────

enum EstadoTarea { enCurso, pendiente, completada }

class Tarea {
  final String id;
  final String titulo;
  final String descripcion;
  /// Estado individual de cada feature/sub-área de la plantilla: la tarea
  /// se completa feature por feature, no toda de una sola vez.
  final List<FeatureTareaVista> features;
  EstadoTarea estado;
  bool expandida;
  final String? salidaId;
  final String? asignacionId;
  final String? ubicacionRuta;
  /// Día de asignación en campo (`fechaSubArea`).
  final DateTime? fechaAsignacion;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.features,
    this.estado = EstadoTarea.enCurso,
    this.expandida = false,
    this.salidaId,
    this.asignacionId,
    this.ubicacionRuta,
    this.fechaAsignacion,
  });
}

/// Filtro de fecha: `null` = todas; `_sinFecha` = sin día; DateTime = día concreto.
class _FiltroFecha {
  final DateTime? dia;
  final bool sinFecha;

  const _FiltroFecha.todas()
      : dia = null,
        sinFecha = false;

  const _FiltroFecha.sinFecha()
      : dia = null,
        sinFecha = true;

  const _FiltroFecha.dia(DateTime this.dia) : sinFecha = false;

  bool get esTodas => dia == null && !sinFecha;
}

// ── Screen ────────────────────────────────────────────────────────────────────

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key, this.embedded = false});

  /// Cuando es true, la barra inferior la provee [PanelControlScreen].
  final bool embedded;

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen>
    with SingleTickerProviderStateMixin {
  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;
  final Color cardColor = terrasachaCardColor;

  late TabController _tabController;
  bool _cargando = true;
  bool _filtroInicializado = false;
  _FiltroFecha _filtroFecha = const _FiltroFecha.todas();

  final List<Tarea> _tareas = [];
  /// Días suspendidos (clima) de salidas del usuario: fecha → etiqueta motivo.
  final Map<DateTime, String> _diasSuspendidos = {};

  List<Tarea> get _filtradasPorFecha {
    if (_filtroFecha.esTodas) return List<Tarea>.from(_tareas);
    if (_filtroFecha.sinFecha) {
      return _tareas.where((t) => t.fechaAsignacion == null).toList();
    }
    final dia = _filtroFecha.dia!;
    return _tareas
        .where(
          (t) =>
              t.fechaAsignacion != null &&
              ServicioSalida.normalizarFecha(t.fechaAsignacion!) == dia,
        )
        .toList();
  }

  List<Tarea> get _enCurso => _filtradasPorFecha
      .where((t) => t.estado == EstadoTarea.enCurso)
      .toList();
  List<Tarea> get _pendientes => _filtradasPorFecha
      .where((t) => t.estado == EstadoTarea.pendiente)
      .toList();
  List<Tarea> get _completadas => _filtradasPorFecha
      .where((t) => t.estado == EstadoTarea.completada)
      .toList();

  List<DateTime> get _fechasDisponibles {
    final set = <DateTime>{};
    for (final t in _tareas) {
      final f = t.fechaAsignacion;
      if (f != null) set.add(ServicioSalida.normalizarFecha(f));
    }
    set.addAll(_diasSuspendidos.keys);
    final lista = set.toList()..sort();
    return lista;
  }

  String? _motivoSuspendido(DateTime? dia) {
    if (dia == null) return null;
    return _diasSuspendidos[ServicioSalida.normalizarFecha(dia)];
  }

  bool get _haySinFecha => _tareas.any((t) => t.fechaAsignacion == null);

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
    final salidas = await ServicioSalida.listarSalidasParaUsuario(usuario);
    final suspendidos = <DateTime, String>{};
    for (final s in salidas) {
      for (final d in s.diasSuspendidos) {
        suspendidos[ServicioSalida.normalizarFecha(d.fecha)] = d.motivoEtiqueta;
      }
    }
    if (!mounted) return;
    setState(() {
      _tareas
        ..clear()
        ..addAll(vistas.map(_tareaDesdeVista));
      _diasSuspendidos
        ..clear()
        ..addAll(suspendidos);
      if (!_filtroInicializado) {
        _filtroFecha = _filtroInicialSugerido();
        _filtroInicializado = true;
      } else if (!_filtroAunValido(_filtroFecha)) {
        _filtroFecha = _filtroInicialSugerido();
      }
      _cargando = false;
    });
  }

  bool _filtroAunValido(_FiltroFecha filtro) {
    if (filtro.esTodas) return true;
    if (filtro.sinFecha) return _haySinFecha;
    final dia = filtro.dia;
    if (dia == null) return false;
    return _fechasDisponibles.any((f) => f == dia) ||
        _diasSuspendidos.containsKey(dia);
  }

  _FiltroFecha _filtroInicialSugerido() {
    final hoy = ServicioSalida.normalizarFecha(DateTime.now());
    final fechas = _fechasDisponibles;
    if (fechas.any((f) => f == hoy)) return _FiltroFecha.dia(hoy);
    if (fechas.length == 1 && !_haySinFecha) {
      return _FiltroFecha.dia(fechas.first);
    }
    return const _FiltroFecha.todas();
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
      descripcion: vista.salidaNombre,
      ubicacionRuta: vista.ubicacionRuta,
      features: vista.features,
      estado: estado,
      fechaAsignacion: vista.fechaAsignacion,
    );
  }

  /// Abre el registro de una feature/sub-área concreta de la tarea. Cada
  /// feature se registra y completa de forma independiente.
  Future<void> _abrirEjecucion(Tarea tarea, FeatureTareaVista feature) async {
    if (tarea.salidaId == null || tarea.asignacionId == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EjecucionRegistroScreen(
          salidaId: tarea.salidaId,
          asignacionId: tarea.asignacionId,
          featureId: feature.featureId,
          featureNombre: feature.featureNombre,
          tituloTarea: tarea.titulo,
          ubicacionRuta: tarea.ubicacionRuta,
        ),
      ),
    );

    if (!mounted) return;
    await _cargarTareas();
  }

  String _formatFecha(DateTime fecha) {
    final hoy = ServicioSalida.normalizarFecha(DateTime.now());
    final dia = ServicioSalida.normalizarFecha(fecha);
    final manana = hoy.add(const Duration(days: 1));
    final ayer = hoy.subtract(const Duration(days: 1));
    if (dia == hoy) return 'Hoy';
    if (dia == manana) return 'Mañana';
    if (dia == ayer) return 'Ayer';
    const meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]}';
  }

  String _formatFechaLarga(DateTime fecha) {
    const dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${dias[fecha.weekday - 1]} ${fecha.day} de ${meses[fecha.month - 1]}';
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
        leading: widget.embedded
            ? null
            : GestureDetector(
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
        automaticallyImplyLeading: !widget.embedded,
        leadingWidth: widget.embedded ? null : 120,
        title: const Text(
          'Tareas',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _cargando ? null : _cargarTareas,
            icon: Icon(Icons.refresh, color: primaryColor),
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
          isScrollable: true,
          tabs: [
            Tab(text: 'Pendientes (${_pendientes.length})'),
            Tab(text: 'En curso (${_enCurso.length})'),
            Tab(text: 'Completadas (${_completadas.length})'),
          ],
        ),
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Column(
              children: [
                if (_fechasDisponibles.isNotEmpty || _haySinFecha)
                  _buildSelectorFechas(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildListaTareas(_pendientes),
                      _buildListaTareas(_enCurso),
                      _buildListaTareas(_completadas),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSelectorFechas() {
    final fechas = _fechasDisponibles;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fecha de asignación',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _chipFecha(
                  etiqueta: 'Todas',
                  seleccionado: _filtroFecha.esTodas,
                  onTap: () =>
                      setState(() => _filtroFecha = const _FiltroFecha.todas()),
                ),
                ...fechas.map(
                  (dia) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _chipFecha(
                      etiqueta: _motivoSuspendido(dia) != null
                          ? '${_formatFecha(dia)} · N/A'
                          : _formatFecha(dia),
                      seleccionado: !_filtroFecha.sinFecha &&
                          _filtroFecha.dia != null &&
                          _filtroFecha.dia == dia,
                      onTap: () =>
                          setState(() => _filtroFecha = _FiltroFecha.dia(dia)),
                    ),
                  ),
                ),
                if (_haySinFecha)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _chipFecha(
                      etiqueta: 'Sin fecha',
                      seleccionado: _filtroFecha.sinFecha,
                      onTap: () => setState(
                        () => _filtroFecha = const _FiltroFecha.sinFecha(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipFecha({
    required String etiqueta,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(etiqueta),
      selected: seleccionado,
      onSelected: (_) => onTap(),
      selectedColor: primaryColor.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: seleccionado ? primaryColor : Colors.grey[700],
        fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
        fontSize: 12,
      ),
      side: BorderSide(
        color: seleccionado ? primaryColor : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildListaTareas(List<Tarea> tareas) {
    if (tareas.isEmpty) {
      final motivo = !_filtroFecha.esTodas && !_filtroFecha.sinFecha
          ? _motivoSuspendido(_filtroFecha.dia)
          : null;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              motivo != null
                  ? Icons.cloud_off_outlined
                  : Icons.assignment_outlined,
              size: 64,
              color: primaryColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              motivo != null
                  ? 'Día suspendido ($motivo)'
                  : (_filtroFecha.esTodas
                      ? 'Sin tareas aquí'
                      : 'Sin tareas en esta fecha'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
            if (motivo != null) ...[
              const SizedBox(height: 8),
              Text(
                'Las mediciones pendientes se movieron a otro día',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
            ],
          ],
        ),
      );
    }

    // Con "Todas", agrupar por fecha para leer el calendario de un vistazo.
    if (_filtroFecha.esTodas) {
      final grupos = _agruparPorFecha(tareas);
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: grupos.length,
        itemBuilder: (ctx, i) {
          final grupo = grupos[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (i > 0) const SizedBox(height: 8),
              _buildEncabezadoFecha(grupo.etiqueta),
              const SizedBox(height: 8),
              ...grupo.tareas.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildTareaCard(t),
                ),
              ),
            ],
          );
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tareas.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _buildTareaCard(tareas[i]),
    );
  }

  List<({String etiqueta, List<Tarea> tareas})> _agruparPorFecha(
    List<Tarea> tareas,
  ) {
    final mapa = <DateTime?, List<Tarea>>{};
    for (final t in tareas) {
      final key = t.fechaAsignacion == null
          ? null
          : ServicioSalida.normalizarFecha(t.fechaAsignacion!);
      (mapa[key] ??= []).add(t);
    }
    final keys = mapa.keys.toList()
      ..sort((a, b) {
        if (a == null && b == null) return 0;
        if (a == null) return 1;
        if (b == null) return -1;
        return a.compareTo(b);
      });
    return keys
        .map(
          (k) {
            final motivo = k == null ? null : _motivoSuspendido(k);
            final base = k == null
                ? 'Sin fecha de asignación'
                : _formatFechaLarga(k);
            return (
              etiqueta: motivo != null ? '$base · suspendido ($motivo)' : base,
              tareas: mapa[k]!,
            );
          },
        )
        .toList();
  }

  Widget _buildEncabezadoFecha(String etiqueta) {
    return Row(
      children: [
        Icon(Icons.calendar_today_outlined, size: 14, color: primaryColor),
        const SizedBox(width: 6),
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTareaCard(Tarea tarea) {
    final completados = tarea.features
        .where((f) => f.estado == EstadoTareaSalida.completada)
        .length;
    final total = tarea.features.length;
    final progreso = total > 0 ? completados / total : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tarea.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        if (tarea.fechaAsignacion != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _formatFecha(tarea.fechaAsignacion!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
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
                  Text(
                    tarea.descripcion,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  if (tarea.fechaAsignacion != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Asignada: ${_formatFechaLarga(tarea.fechaAsignacion!)}',
                      style: TextStyle(
                        color: primaryColor.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),

                  if (tarea.features.isNotEmpty) ...[
                    ...tarea.features.map((f) => _buildFilaFeature(tarea, f)),
                    const SizedBox(height: 6),
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
                      '$completados de $total features completadas',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilaFeature(Tarea tarea, FeatureTareaVista feature) {
    final completada = feature.estado == EstadoTareaSalida.completada;
    final enCurso = feature.estado == EstadoTareaSalida.enCurso;
    final Color color = completada
        ? primaryColor
        : (enCurso ? const Color(0xFFDD6B20) : Colors.grey);
    final String etiqueta =
        completada ? 'Completada' : (enCurso ? 'En curso' : 'Pendiente');
    final bool puedeRegistrar =
        tarea.salidaId != null && tarea.asignacionId != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: terrasachaBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            completada ? Icons.check_circle : Icons.radio_button_unchecked,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.featureNombre,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  etiqueta,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (puedeRegistrar)
            TextButton(
              onPressed: () => _abrirEjecucion(tarea, feature),
              style: TextButton.styleFrom(foregroundColor: primaryColor),
              child: Text(completada ? 'Ver registro' : 'Registrar'),
            ),
        ],
      ),
    );
  }
}
