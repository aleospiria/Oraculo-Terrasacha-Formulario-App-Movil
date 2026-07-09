// lib/Screens/PanelControlScreen.dart
import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:capturador_datos_offline/Screens/ProyectosMenuScreen.dart';
import 'package:capturador_datos_offline/screens/CreacionPlanScreen.dart';
import 'package:capturador_datos_offline/screens/DetalleSalidaScreen.dart';
import 'package:capturador_datos_offline/main.dart';

import '../models/Project.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';
import '../utils/roles_campo.dart';
import '../utils/servicio_salida.dart';
import '../utils/servicioAutenticacion.dart';
import 'AjustesRetencionScreen.dart';
import 'GestionListasChequeoScreen.dart';
import 'GestionUsuariosScreen.dart';
import 'TareasScreen.dart';

class PanelControlScreen extends StatefulWidget {
  const PanelControlScreen({super.key});

  @override
  State<PanelControlScreen> createState() => _PanelControlScreenState();
}

class _PanelControlScreenState extends State<PanelControlScreen> {
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);
  final Color cardColor = const Color(0xFFEEF2E6);

  int _bottomIndex = 0;
  bool _sincronizando = true;
  int _proyectosActivos = 0;
  int _tareasEnCurso = 0;
  String _ultimaSincronizacion = '--:--';
  List<SalidaCampo> _planesRecientes = [];
  StreamSubscription? _syncSubscription;

  @override
  void initState() {
    super.initState();
    _esperarSincronizacion();
    _cargarResumen();
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
      });
    } catch (e) {
      debugPrint('❌ Error cargando planes: $e');
    }
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {},
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
        title: Text(
          hasRole('operador') ? 'Inicio' : 'Panel de Control',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
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
      ),
      body: SingleChildScrollView(
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TareasScreen(),
                        ),
                      ),
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProyectosMenuScreen()),
                      ),
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TareasScreen()),
                ),
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
                              'Registros y plantillas asignadas',
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
              if (RolesCampo.puedeReportarIncidencias(currentUserRole)) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/incidencias'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.red.shade400, size: 32),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reportar incidencia',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Accidentes y eventos en campo',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.red.shade300),
                      ],
                    ),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),

      // ── Navbar inferior ───────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          setState(() => _bottomIndex = index);
          if (hasRole('operador')) {
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TareasScreen()));
            } else if (index == 2) {
              Navigator.pushNamed(context, '/incidencias');
            }
          } else {
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProyectosMenuScreen()));
            } else if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TareasScreen()));
            } else if (index != 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sección ${_navLabel(index)} próximamente'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        items: _navItems,
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _navLabel(int index) {
    if (hasRole('operador')) {
      const labels = ['Inicio', 'Tareas', 'Reportes'];
      return labels[index];
    }
    const labels = ['Inicio', 'Proyectos', 'Tareas', 'Mapas', 'Más'];
    return labels[index];
  }

  List<BottomNavigationBarItem> get _navItems {
    if (hasRole('operador')) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Tareas'),
        BottomNavigationBarItem(icon: Icon(Icons.warning_amber_outlined), activeIcon: Icon(Icons.warning_amber), label: 'Reportes'),
      ];
    }
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
      BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), activeIcon: Icon(Icons.folder), label: 'Proyectos'),
      BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Tareas'),
      BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map), label: 'Mapas'),
      BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
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

    if (hasAnyRole(['lider_proyecto', 'lider_cuadrilla'])) {
      if (acciones.isNotEmpty) acciones.add(const SizedBox(width: 10));
      acciones.add(Expanded(
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

    return acciones.isEmpty
        ? const SizedBox.shrink()
        : Row(children: acciones);
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