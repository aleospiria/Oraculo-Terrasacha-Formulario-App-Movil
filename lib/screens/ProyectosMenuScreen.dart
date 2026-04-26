// lib/Screens/ProyectosMenuScreen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

import 'package:capturador_datos_offline/models/ModelProvider.dart';
import 'package:capturador_datos_offline/models/Project.dart';
import 'package:capturador_datos_offline/utils/inicioTareaOperador.dart';
import 'package:capturador_datos_offline/screens/EquiposScreen.dart';

class ProyectosMenuScreen extends StatefulWidget {
  const ProyectosMenuScreen({super.key});

  @override
  State<ProyectosMenuScreen> createState() => _ProyectosMenuScreenState();
}

class _ProyectosMenuScreenState extends State<ProyectosMenuScreen> {
  List<Project> proyectos = [];
  bool cargando = true;

  StreamSubscription<dynamic>? _observeSub;
  StreamSubscription<dynamic>? _hubSub;

  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);

  String _selectedTab = 'Proyectos';
  int _bottomIndex = 0;

  // Imágenes de naturaleza/bosque — una por índice derivado del ID del proyecto
  static const List<String> _projectImages = [
    'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1425913397330-cf8af2ff40a1?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1511497584788-876760111969?w=800&auto=format&fit=crop',
  ];

  /// Devuelve siempre la misma imagen para el mismo proyecto (basado en su ID)
  String _imageForProject(Project proyecto) {
    final hash = proyecto.id.codeUnits.fold<int>(0, (sum, c) => sum + c);
    return _projectImages[hash % _projectImages.length];
  }

  @override
  void initState() {
    super.initState();
    _initDataStoreListeners();
    _initialLoad();
  }

  @override
  void dispose() {
    _observeSub?.cancel();
    _hubSub?.cancel();
    super.dispose();
  }

  Future<void> _initialLoad() async {
    try {
      final items = await Amplify.DataStore.query(Project.classType);
      if (!mounted) return;
      setState(() {
        proyectos = List<Project>.from(items);
        cargando = false;
      });
    } catch (e) {
      debugPrint('Error en initialLoad: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  void _initDataStoreListeners() {
    // 1) observeQuery (gen2)
    try {
      final dynamic obsQueryStream =
      Amplify.DataStore.observeQuery(Project.classType);
      if (obsQueryStream is Stream) {
        _observeSub = obsQueryStream.listen((dynamic snapshot) {
          try {
            final dynamic itemsDyn = (snapshot as dynamic).items;
            if (itemsDyn is List) {
              final list = itemsDyn.map((e) => e as Project).toList();
              if (!mounted) return;
              setState(() {
                proyectos = list;
                cargando = false;
              });
              return;
            }
          } catch (_) {}
          _requeryAllProjects();
        }, onError: (err) => debugPrint('observeQuery error: $err'));
        return;
      }
    } catch (e) {
      debugPrint('observeQuery no disponible: $e');
    }

    // 2) Fallback: observe (gen1)
    try {
      final dynamic obsStream = Amplify.DataStore.observe(Project.classType);
      if (obsStream is Stream) {
        _observeSub = obsStream.listen(
              (_) => _requeryAllProjects(),
          onError: (err) => debugPrint('observe error: $err'),
        );
        return;
      }
    } catch (e) {
      debugPrint('DataStore.observe no disponible: $e');
    }

    // 3) Último recurso: Hub
    try {
      _hubSub = Amplify.Hub.listen(
        [HubChannel.DataStore] as HubChannel<dynamic, HubEvent<dynamic>>,
            (HubEvent hubEvent) async => await _requeryAllProjects(),
      );
    } catch (e) {
      debugPrint('No se pudo subscribir a Hub DataStore: $e');
    }
  }

  Future<void> _requeryAllProjects() async {
    try {
      final snaps = await Amplify.DataStore.query(Project.classType);
      if (!mounted) return;
      setState(() {
        proyectos = List<Project>.from(snaps);
        cargando = false;
      });
    } catch (e) {
      debugPrint('Error requeryAllProjects: $e');
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
      final nuevo = Project(name: nombre, status: 'VIVO');
      await Amplify.DataStore.save(nuevo);
      debugPrint('Proyecto creado: ${nuevo.id}');
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
                  child:
                  const Icon(Icons.person, color: Colors.white, size: 20),
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
          child: cargando
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : RefreshIndicator(
            onRefresh: _requeryAllProjects,
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
                      onPressed: () {},
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _crearProyecto(context),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
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
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Botón $index presionado')),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined), label: 'Reportes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
        ],
      ),
    );
  }

  Widget _buildTab(String label, {bool active = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTab = label);
          if (label == 'Equipos') {
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
          // Imagen consistente por proyecto (derivada del ID)
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
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
                // Nombre + badge estado
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

                // Acciones
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
                          '/predios', // pantalla de Predios (Topology nivel 1)
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