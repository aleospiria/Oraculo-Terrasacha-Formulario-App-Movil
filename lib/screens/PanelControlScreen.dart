import '../theme.dart';
// lib/Screens/PanelControlScreen.dart
import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:capturador_datos_offline/screens/ProyectosMenuScreen.dart';
import 'package:capturador_datos_offline/screens/CreacionPlanScreen.dart';
import 'package:capturador_datos_offline/screens/DetalleSalidaScreen.dart';
import 'package:capturador_datos_offline/main.dart';

import '../models/Project.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';
import '../utils/servicio_salida.dart';
import '../utils/servicioAutenticacion.dart';
import '../widgets/terrasacha_logo.dart';
import 'AjustesRetencionScreen.dart';
import 'ChecklistSalidaScreen.dart';
import 'GestionListasChequeoScreen.dart';
import 'GestionPlantillasScreen.dart';
import 'GestionUsuariosScreen.dart';
import 'MapaSalidasScreen.dart';
import 'TareasScreen.dart';

class PanelControlScreen extends StatefulWidget {
  const PanelControlScreen({super.key, this.initialTabIndex = 0});

  /// Pestaña inicial de la barra inferior (0=Inicio, 1=Proyectos, …).
  final int initialTabIndex;

  @override
  State<PanelControlScreen> createState() => _PanelControlScreenState();
}

class _PanelControlScreenState extends State<PanelControlScreen> {
  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;
  final Color cardColor = terrasachaCardColor;

  int _bottomIndex = 0;
  bool _sincronizando = true;
  int _proyectosActivos = 0;
  int _tareasEnCurso = 0;
  String _ultimaSincronizacion = '--:--';
  List<SalidaCampo> _planesRecientes = [];
  List<ChecklistSalidaVista> _checklistsOperador = [];
  StreamSubscription? _syncSubscription;

  @override
  void initState() {
    super.initState();
    _bottomIndex = _normalizarTabInicial(widget.initialTabIndex);
    _esperarSincronizacion();
    _cargarResumen();
  }

  void _irATab(int index) {
    setState(() => _bottomIndex = index);
  }

  int _normalizarTabInicial(int index) {
    if (hasRole('lider_proyecto')) {
      if (index == 3) return 2;
      if (index == 2 || index >= 4) return 0;
      return index.clamp(0, 2);
    }
    return index.clamp(0, 3);
  }

  Future<void> _cargarResumen() async {
    if (hasRole('operador')) {
      await _cargarPlanesRecientes();
      return;
    }
    await Future.wait([
      _cargarProyectosActivos(),
      _cargarPlanesRecientes(),
    ]);
  }

  Future<void> _cargarProyectosActivos() async {
    try {
      final request = ModelQueries.list(Project.classType);
      final response = await Amplify.API.query(request: request).response;

      if (response.errors.isNotEmpty) {
        debugPrint('❌ Error cargando proyectos: ${response.errors}');
        return;
      }

      final items = response.data?.items.whereType<Project>().toList() ?? [];
      final activos = items.where((p) => p.status == 'activo').length;

      if (!mounted) return;
      setState(() {
        _proyectosActivos = activos;
        _ultimaSincronizacion = DateTime.now().toString().substring(11, 16);
      });
    } catch (e) {
      debugPrint('❌ Error en query de proyectos: $e');
    }
  }

  Future<void> _cargarPlanesRecientes() async {
    try {
      if (hasRole('operador')) {
        final usuario = await servicioAutenticacion.getUsuarioActual();
        if (usuario != null) {
          final tareas = await ServicioSalida.listarTareasParaUsuario(usuario);
          final checklists =
              await ServicioSalida.listarChecklistsParaUsuario(usuario);
          final activas = tareas
              .where(
                (t) =>
                    t.estado == EstadoTareaSalida.pendiente ||
                    t.estado == EstadoTareaSalida.enCurso,
              )
              .length;

          if (!mounted) return;
          setState(() {
            _planesRecientes = [];
            _tareasEnCurso = activas;
            _checklistsOperador = checklists;
          });
        }
        return;
      }

      final planes = await ServicioSalida.listar();
      planes.sort((a, b) => b.actualizadoEn.compareTo(a.actualizadoEn));

      final enCurso = planes
          .where(
            (p) =>
                p.estado == EstadoSalida.enCurso ||
                p.estado == EstadoSalida.programada,
          )
          .length;

      if (!mounted) return;
      setState(() {
        _planesRecientes = planes.take(3).toList();
        _tareasEnCurso = enCurso;
        _checklistsOperador = [];
      });
    } catch (e) {
      debugPrint('❌ Error cargando planes: $e');
    }
  }

  Future<void> _abrirChecklistOperador(ChecklistSalidaVista vista) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChecklistSalidaScreen(
          salidaId: vista.salidaId,
          checklist: vista.checklist,
          personaId: vista.personaId,
          personaNombre: vista.personaNombre,
          personaRol: vista.personaRol,
          fecha: vista.fecha,
          puedeEditarItems: false,
          puedeEditarObservacion: true,
        ),
      ),
    );
    if (!mounted) return;
    await _cargarResumen();
  }

  @override
  void dispose() {
    _syncSubscription?.cancel();
    super.dispose();
  }

  /// Espera la sincronización con timeout y verificación de datos locales
  /// Si ya hay datos en local, muestra la UI inmediatamente (offline-first)
  Future<void> _esperarSincronizacion() async {
    // Si ya hay datos locales, mostrar UI inmediatamente
    if (hasLocalData) {
      safePrint('✅ Datos locales disponibles - mostrando UI inmediatamente');
      if (mounted) setState(() => _sincronizando = false);
      return;
    }

    // Si ya está sincronizado, continuar
    if (isSyncReady) {
      if (mounted) setState(() => _sincronizando = false);
      return;
    }

    // Escuchar el stream con timeout de 5 segundos
    bool completado = false;
    
    _syncSubscription = syncReadyStream.listen((ready) {
      if (ready && mounted && !completado) {
        completado = true;
        setState(() => _sincronizando = false);
      }
    });

    // Timeout: si en 5s no llega syncQueriesReady, mostrar UI igual
    await Future.delayed(const Duration(seconds: 5));
    if (!completado && mounted) {
      safePrint('⚠️ Timeout de sincronización - mostrando UI con datos disponibles');
      setState(() => _sincronizando = false);
    }
  }

  Color _colorEstadoPlan(EstadoSalida estado) {
    switch (estado) {
      case EstadoSalida.enCurso:
      case EstadoSalida.programada:
        return const Color(0xFFDD6B20);
      case EstadoSalida.completada:
      case EstadoSalida.cancelada:
      case EstadoSalida.caducada:
        return const Color(0xFF718096);
      case EstadoSalida.borrador:
      case EstadoSalida.incompleta:
        return Colors.grey;
    }
  }

  String _tiempoRelativoPlan(SalidaCampo plan) {
    final fecha = plan.actualizadoEn;
    final diff = DateTime.now().difference(fecha);
    if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} min';
    }
    if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} horas';
    }
    if (diff.inDays == 1) {
      return 'Ayer';
    }
    if (diff.inDays < 7) {
      return 'Hace ${diff.inDays} días';
    }

    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar pantalla de carga mientras se sincroniza
    if (_sincronizando) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: primaryColor),
              const SizedBox(height: 24),
              const Text(
                'Sincronizando datos...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Descargando proyectos desde la nube',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (hasRole('operador')) {
      return _buildScaffoldOperador();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: IndexedStack(
        index: _bottomIndex,
        children: _pestanasLider,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  List<Widget> get _pestanasOperador => [
        Scaffold(
          backgroundColor: backgroundColor,
          appBar: _buildAppBarInicio(),
          body: _buildCuerpoInicio(),
        ),
        const TareasScreen(embedded: true),
        const MapaSalidasScreen(embedded: true),
      ];

  List<Widget> get _pestanasLider {
    if (hasRole('lider_proyecto')) {
      return [
        _buildInicioTab(),
        const ProyectosMenuScreen(embedded: true),
        const MapaSalidasScreen(embedded: true),
      ];
    }
    return [
      _buildInicioTab(),
      const ProyectosMenuScreen(embedded: true),
      const TareasScreen(embedded: true),
      const MapaSalidasScreen(embedded: true),
    ];
  }

  Widget _buildScaffoldOperador() {
    // Misma TareasScreen (fechas + registro) que el líder de cuadrilla,
    // embebida en tabs para que el operador no pierda los ajustes al navegar.
    final tabIndex = _bottomIndex.clamp(0, _pestanasOperador.length - 1);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: IndexedStack(
        index: tabIndex,
        children: _pestanasOperador,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBarInicio() {
    return AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: TerrasachaLogo.appBar(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: primaryColor),
            tooltip: 'Caducidad de datos',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AjustesRetencionScreen(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              radius: 18,
              child: Icon(Icons.person_outline, color: primaryColor, size: 20),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red.shade400),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await Amplify.Auth.signOut();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            },
          ),
        ],
    );
  }

  Widget _buildInicioTab() {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBarInicio(),
      body: _buildCuerpoInicio(),
    );
  }

  Widget _buildCuerpoInicio() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Resumen del sistema ──────────────────────────────────────
            Text(
              hasRole('operador') ? 'Resumen' : 'Resumen del sistema',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            if (hasRole('operador'))
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _bottomIndex = 1),
                      child: _buildResumenCard(
                        icono: Icons.assignment_turned_in_outlined,
                        titulo: 'Mis tareas',
                        valor: '$_tareasEnCurso',
                        puntoColor: const Color(0xFFDD6B20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildResumenCard(
                      icono: Icons.sync,
                      titulo: 'Sincronización',
                      subtitulo: 'Completa - $_ultimaSincronizacion',
                      esSincronizacion: true,
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  // Proyectos activos
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _irATab(1),
                      child: _buildResumenCard(
                        icono: Icons.folder_outlined,
                        titulo: 'Proyectos activos',
                        valor: '$_proyectosActivos',
                        puntoColor: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Tareas en curso
                  Expanded(
                    child: _buildResumenCard(
                      icono: Icons.assignment_turned_in_outlined,
                      titulo: 'Tareas en curso',
                      valor: '$_tareasEnCurso',
                      puntoColor: const Color(0xFFDD6B20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Sincronización
                  Expanded(
                    child: _buildResumenCard(
                      icono: Icons.sync,
                      titulo: 'Sincronización',
                      subtitulo: 'Completa - $_ultimaSincronizacion',
                      esSincronizacion: true,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            if (!hasRole('operador')) ...[
              // ── Acciones rápidas ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Acciones rápidas',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActions(),
              const SizedBox(height: 24),

              // ── Planes recientes ─────────────────────────────────────────
              const Text(
                'Planes recientes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),
              if (_planesRecientes.isEmpty)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    'No hay planes creados aún',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                )
              else
                ..._planesRecientes.map(_buildPlanRecienteCard),
            ] else ...[
              const Text(
                'Acceso rápido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => setState(() => _bottomIndex = 1),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.assignment_outlined,
                          color: Colors.white, size: 32),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ver mis tareas',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Por fecha · registro numérico u observación',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Mi checklist',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 10),
              if (_checklistsOperador.isEmpty)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    'Sin checklists pendientes por revisar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                )
              else
                ..._checklistsOperador.map(_buildChecklistOperadorCard),
            ],
            const SizedBox(height: 80),
          ],
        ),
      );
  }

  Widget _buildChecklistOperadorCard(ChecklistSalidaVista vista) {
    final colorEstado = vista.completado
        ? primaryColor
        : (vista.itemsCompletados > 0 ? const Color(0xFFDD6B20) : Colors.grey);
    final estadoTexto = vista.completado
        ? 'Completado por el líder'
        : (vista.itemsCompletados > 0 ? 'En progreso' : 'Pendiente');

    return GestureDetector(
      onTap: () => _abrirChecklistOperador(vista),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(
              vista.completado ? Icons.check_circle : Icons.checklist_rtl_outlined,
              color: colorEstado,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vista.salidaNombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$estadoTexto · ${vista.itemsCompletados} de ${vista.itemsTotal} ítems',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Fecha: ${_formatFecha(vista.fecha)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    return '$d/$m/${fecha.year}';
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          if (hasRole('operador')) {
            // Reportes sigue siendo ruta aparte; el resto son tabs embebidos
            // (Inicio / Tareas con fechas / Mapas).
            if (index == 3) {
              Navigator.pushNamed(context, '/incidencias');
              return;
            }
            setState(() => _bottomIndex = index);
            return;
          }

          _irATab(index);
        },
        items: _navItems,
      );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<BottomNavigationBarItem> get _navItems {
    if (hasRole('operador')) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Tareas'),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map), label: 'Mapas'),
        BottomNavigationBarItem(icon: Icon(Icons.warning_amber_outlined), activeIcon: Icon(Icons.warning_amber), label: 'Reportes'),
      ];
    }
    if (hasRole('lider_proyecto')) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), activeIcon: Icon(Icons.folder), label: 'Proyectos'),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map), label: 'Mapas'),
      ];
    }
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
      BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), activeIcon: Icon(Icons.folder), label: 'Proyectos'),
      BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Tareas'),
      BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map), label: 'Mapas'),
    ];
  }

  Widget _buildQuickActions() {
    final acciones = <Widget>[];

    if (hasRole('lider_proyecto')) {
      acciones.add(Expanded(
        child: GestureDetector(
          onTap: () async {
            final actualizado = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => const CreacionPlanScreen(),
              ),
            );
            if (actualizado == true) _cargarPlanesRecientes();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Icon(Icons.assignment_outlined, color: Colors.white, size: 36),
                    Positioned(
                      right: 0, top: 0,
                      child: Icon(Icons.add_circle, color: Colors.white, size: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Crear nuevo\nplan', textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, height: 1.3)),
              ],
            ),
          ),
        ),
      ));
    }

    if (hasRole('lider_proyecto')) {
      if (acciones.isNotEmpty) acciones.add(const SizedBox(width: 10));
      acciones.add(Expanded(
        child: _buildAccionCard(
          icono: Icons.group_outlined,
          label: 'Gestionar\nusuarios',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GestionUsuariosScreen()),
          ),
        ),
      ));
    }

    final filaSecundaria = <Widget>[];

    if (hasAnyRole(['lider_proyecto', 'lider_cuadrilla'])) {
      filaSecundaria.add(Expanded(
        child: _buildAccionCard(
          icono: Icons.checklist_outlined,
          label: 'Configurar\nchecklist',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GestionListasChequeoScreen(),
            ),
          ),
        ),
      ));
    }

    if (hasAnyRole(['lider_proyecto', 'lider_cuadrilla'])) {
      if (filaSecundaria.isNotEmpty) {
        filaSecundaria.add(const SizedBox(width: 10));
      }
      filaSecundaria.add(Expanded(
        child: _buildAccionCard(
          icono: Icons.library_books_outlined,
          label: 'Gestionar\nplantillas',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GestionPlantillasScreen(),
            ),
          ),
        ),
      ));
    }

    if (acciones.isEmpty && filaSecundaria.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (acciones.isNotEmpty) Row(children: acciones),
        if (acciones.isNotEmpty && filaSecundaria.isNotEmpty)
          const SizedBox(height: 10),
        if (filaSecundaria.isNotEmpty) Row(children: filaSecundaria),
      ],
    );
  }

  Widget _buildResumenCard({
    required IconData icono,
    required String titulo,
    String? valor,
    String? subtitulo,
    Color? puntoColor,
    bool esSincronizacion = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icono, color: primaryColor, size: 28),
          const SizedBox(height: 10),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          if (!esSincronizacion && valor != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: puntoColor, size: 10),
                const SizedBox(width: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            )
          else if (subtitulo != null)
            Text(
              subtitulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccionCard({
    required IconData icono,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icono, color: primaryColor, size: 32),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanRecienteCard(SalidaCampo plan) {
    final colorEstado = _colorEstadoPlan(plan.estado);
    final tiempo = _tiempoRelativoPlan(plan);

    return GestureDetector(
      onTap: () async {
        final actualizado = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleSalidaScreen(salidaId: plan.id),
          ),
        );
        if (actualizado == true) _cargarPlanesRecientes();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (plan.ubicacionRuta != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      plan.ubicacionRuta!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorEstado.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    plan.estado.etiqueta,
                    style: TextStyle(
                      color: colorEstado,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tiempo,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}