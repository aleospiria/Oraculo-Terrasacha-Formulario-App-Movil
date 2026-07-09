// lib/Screens/ProyectosMenuScreen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:capturador_datos_offline/models/Project.dart';
import 'package:capturador_datos_offline/models/plan_campo_borrador.dart';
import 'package:capturador_datos_offline/utils/inicioTareaOperador.dart';
import 'package:capturador_datos_offline/utils/servicio_salida.dart';
import 'package:capturador_datos_offline/screens/CreacionPlanScreen.dart';
import 'package:capturador_datos_offline/screens/DetalleSalidaScreen.dart';
import 'package:capturador_datos_offline/screens/EquiposScreen.dart';
import 'package:capturador_datos_offline/main.dart';

class ProyectosMenuScreen extends StatefulWidget {
  const ProyectosMenuScreen({super.key});

  @override
  State<ProyectosMenuScreen> createState() => _ProyectosMenuScreenState();
}

class _ProyectosMenuScreenState extends State<ProyectosMenuScreen> {
  List<Project> proyectos = [];
  List<SalidaCampo> salidas = [];
  final Map<String, int> _progresoSalidas = {};
  bool cargando = true;
  bool cargandoSalidas = false;

  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);

  String _selectedTab = 'Proyectos';
  int _bottomIndex = 0;

  static const List<String> _projectImages = [
    'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1425913397330-cf8af2ff40a1?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1511497584788-876760111969?w=800&auto=format&fit=crop',
  ];

  String _imageForProject(Project proyecto) {
    final hash = proyecto.id.codeUnits.fold<int>(0, (sum, c) => sum + c);
    return _projectImages[hash % _projectImages.length];
  }

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _cargarProyectos();
    _cargarSalidas();
  }

  Future<void> _cargarSalidas() async {
    setState(() => cargandoSalidas = true);
    try {
      final lista = await ServicioSalida.listar();
      final progresos = <String, int>{};
      for (final s in lista) {
        progresos[s.id] = await ServicioSalida.progresoSalida(s.id);
      }
      if (!mounted) return;
      setState(() {
        salidas = lista;
        _progresoSalidas
          ..clear()
          ..addAll(progresos);
        cargandoSalidas = false;
      });
    } catch (e) {
      debugPrint('Error cargando salidas: $e');
      if (mounted) setState(() => cargandoSalidas = false);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // observeQuery() es mejor que query() directo porque:
  // 1. Espera a que los datos estén realmente en SQLite
  // 2. Se actualiza automáticamente cuando llegan nuevos datos
  // 3. Evita condiciones de carrera con la sincronización
  Future<void> _cargarProyectos() async {
    try {
      debugPrint('🔍 Cargando proyectos con observeQuery...');
      
      // Cancelar suscripción previa si existe
      _subscription?.cancel();
      
      _subscription = Amplify.DataStore.observeQuery(Project.classType).listen(
        (snapshot) {
          debugPrint('📦 observeQuery snapshot: ${snapshot.items.length} proyectos');
          debugPrint('   Is Synced: ${snapshot.isSynced}');
          for (final p in snapshot.items) {
            debugPrint('  → ${p.id} | ${p.name} | ${p.status}');
          }
          if (!mounted) return;
          setState(() {
            proyectos = List<Project>.from(snapshot.items);
            cargando = false;
          });
        },
        onError: (e) {
          debugPrint('❌ Error en observeQuery: $e');
          if (mounted) setState(() => cargando = false);
        },
      );
    } catch (e) {
      debugPrint('❌ Error configurando observeQuery: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  Future<void> _crearProyecto(BuildContext context) async {
    final TextEditingController ctrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo proyecto'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nombre'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result != true) return;
    final nombre = ctrl.text.trim();
    if (nombre.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre no puede estar vacío')),
        );
      }
      return;
    }

    try {
      final nuevo = Project(name: nombre, status: 'activo');
      await Amplify.DataStore.save(nuevo);
      debugPrint('Proyecto creado: ${nuevo.id} | status: activo');
      // No hace necesario recargar - observeQuery se actualiza solo
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proyecto creado')),
        );
      }
    } catch (e) {
      debugPrint('Error creando proyecto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error creando proyecto')),
        );
      }
    }
  }

  Future<void> _borrarProyecto(Project proyecto) async {
    try {
      await Amplify.DataStore.delete(proyecto);
      await _cargarProyectos(); // refrescar lista
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proyecto borrado')),
        );
      }
    } catch (e) {
      debugPrint('Error borrando proyecto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error borrando proyecto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 4,
        automaticallyImplyLeading: false,
        title: Row(children: [
          const Icon(Icons.park, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          const Text(
            'Terrasacha',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Bienvenido,',
                      style: TextStyle(color: Colors.white70, fontSize: 10)),
                  Text(
                    'Usuario_terrasacha2026',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => InicioTareaOperador.navigate(context),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  radius: 18,
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
            ]),
          )
        ],
      ),
      body: Column(children: [
        Container(
          color: Colors.white,
          child: Row(children: [
            _buildTab("Proyectos", active: _selectedTab == 'Proyectos'),
            _buildTab("Salidas", active: _selectedTab == 'Salidas'),
            _buildTab("Equipos", active: _selectedTab == 'Equipos'),
          ]),
        ),
        Expanded(
          child: _selectedTab == 'Salidas'
              ? _buildContenidoSalidas()
              : cargando
                  ? Center(child: CircularProgressIndicator(color: primaryColor))
                  : RefreshIndicator(
                      onRefresh: _cargarProyectos,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Proyectos',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              TextButton(
                                onPressed: _cargarProyectos,
                                child: Text(
                                  'Ver todos',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (proyectos.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Text('No hay proyectos activos'),
                              ),
                            )
                          else
                            ...proyectos.map((p) => _buildProjectCard(p)),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
        ),
      ]),
      floatingActionButton: _selectedTab == 'Salidas' &&
              hasRole('lider_proyecto')
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () async {
                final creada = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreacionPlanScreen(),
                  ),
                );
                if (creada == true) _cargarSalidas();
              },
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            )
          : _selectedTab == 'Proyectos'
              ? FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () => _crearProyecto(context),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (index) {
          setState(() => _bottomIndex = index);
          if (index == 0) {
            setState(() => _selectedTab = 'Proyectos');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/incidencias');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Botón $index presionado')),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined), label: 'Reportes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
        ],
      ),
    );
  }

  Widget _buildContenidoSalidas() {
    if (cargandoSalidas) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    return RefreshIndicator(
      onRefresh: _cargarSalidas,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Salidas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              TextButton(
                onPressed: _cargarSalidas,
                child: Text(
                  'Actualizar',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (salidas.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.assignment_outlined,
                        size: 48, color: primaryColor.withOpacity(0.4)),
                    const SizedBox(height: 12),
                    const Text('No hay salidas registradas'),
                    const SizedBox(height: 8),
                    Text(
                      'Crea un plan de campo desde el botón +',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else
            ...salidas.map(_buildSalidaCard),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSalidaCard(SalidaCampo salida) {
    final progreso = _progresoSalidas[salida.id] ?? 0;

    return GestureDetector(
      onTap: () async {
        final actualizado = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleSalidaScreen(salidaId: salida.id),
          ),
        );
        if (actualizado == true) _cargarSalidas();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    salida.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    salida.estado.etiqueta,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (salida.ubicacionRuta != null) ...[
              const SizedBox(height: 6),
              Text(
                salida.ubicacionRuta!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progreso / 100,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$progreso% completado',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, {bool active = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTab = label);
          if (label == 'Salidas') {
            _cargarSalidas();
          } else if (label == 'Equipos') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EquiposScreen()),
            ).then((_) {
              if (mounted) setState(() => _selectedTab = 'Proyectos');
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? primaryColor : Colors.grey,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project proyecto) {
    final imageUrl = _imageForProject(proyecto);
    final status = (proyecto.status ?? 'VIVO').toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 140,
                color: primaryColor.withOpacity(0.1),
                child: Icon(Icons.park, color: primaryColor, size: 48),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        proyecto.name ?? 'Sin nombre',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/predios',
                          arguments: {
                            'proyecto_id': proyecto.id,
                            'proyecto_nombre': proyecto.name,
                          },
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ver Predios',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Eliminar proyecto',
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Eliminar proyecto'),
                          content: const Text(
                              '¿Estás seguro que quieres eliminar este proyecto?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c, false),
                              child: const Text('No'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(c, true),
                              child: const Text('Sí, eliminar'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) await _borrarProyecto(proyecto);
                    },
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}