// lib/Screens/ProyectosMenuScreen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

// Ajusta el import según la ruta donde estén tus modelos generados
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

  // Subscriptions (dinámicos para compatibilidad con distintas versiones)
  StreamSubscription<dynamic>? _observeSub;
  StreamSubscription<dynamic>? _hubSub;

  // Colores del diseño
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);

  // Pestaña seleccionada (para marcar visualmente la activa)
  String _selectedTab = 'Proyectos';

  // Estado del bottom nav
  int _bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _initDataStoreListeners();
    _initialLoad(); // carga inicial
  }

  @override
  void dispose() {
    _observeSub?.cancel();
    _hubSub?.cancel();
    super.dispose();
  }

  // Carga inicial simple (query)
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

  // Configura listeners de DataStore de forma que funcione tanto en gen1 como gen2
  void _initDataStoreListeners() {
    // 1) Intento observeQuery (gen2)
    try {
      final dynamic obsQueryStream = Amplify.DataStore.observeQuery(Project.classType);
      if (obsQueryStream is Stream) {
        _observeSub = obsQueryStream.listen((dynamic snapshot) {
          try {
            // snapshot puede tener .items (gen2)
            final dynamic itemsDyn = (snapshot as dynamic).items;
            if (itemsDyn is List) {
              final list = itemsDyn.map((e) => e as Project).toList();
              if (!mounted) return;
              setState(() {
                proyectos = list;
                cargando = false;
              });
              debugPrint('observeQuery → ${list.length} proyectos (isSynced=${(snapshot as dynamic).isSynced ?? '??'})');
              return;
            }
          } catch (_) {
            // si falla, caeremos al fallback (re-query)
          }

          // fallback: re-query completo
          _requeryAllProjects();
        }, onError: (err) {
          debugPrint('observeQuery error: $err');
        });

        debugPrint('Usando observeQuery (gen2) para updates en tiempo real');
        return;
      }
    } catch (e) {
      debugPrint('observeQuery no disponible o falló: $e');
      // continúa a fallback
    }

    // 2) Fallback: intentar observe (gen1) y, si no funciona, suscribir al Hub de DataStore
    try {
      final dynamic obsStream = Amplify.DataStore.observe(Project.classType);
      if (obsStream is Stream) {
        _observeSub = obsStream.listen((dynamic event) {
          // En gen1 el event contiene información de tipo (create/update/delete).
          // Para simplicidad y robustez haremos un re-query completo.
          debugPrint('DataStore.observe event recibido, haciendo re-query');
          _requeryAllProjects();
        }, onError: (err) {
          debugPrint('observe error: $err');
        });

        debugPrint('Usando DataStore.observe (gen1) para updates y re-query');
        return;
      }
    } catch (e) {
      debugPrint('DataStore.observe no disponible: $e');
    }

    // 3) Último recurso: escuchar Hub channel DataStore y re-query cuando haya eventos
    try {
      _hubSub = Amplify.Hub.listen([HubChannel.DataStore] as HubChannel<dynamic, HubEvent<dynamic>>, (HubEvent hubEvent) async {
        debugPrint('Amplify.Hub (DataStore) evento: ${hubEvent.eventName}');
        await _requeryAllProjects();
      });
      debugPrint('Usando Amplify.Hub(DataStore) para updates');
    } catch (e) {
      debugPrint('No se pudo subscribir a Hub DataStore: $e');
    }
  }

  // Re-consulta completa y actualiza estado
  Future<void> _requeryAllProjects() async {
    try {
      final snaps = await Amplify.DataStore.query(Project.classType);
      if (!mounted) return;
      setState(() {
        proyectos = List<Project>.from(snaps);
        cargando = false;
      });
      debugPrint('Requery completado: ${proyectos.length} proyectos');
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
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Crear')),
        ],
      ),
    );

    if (result != true) return;
    final nombre = ctrl.text.trim();
    if (nombre.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El nombre no puede estar vacío')));
      return;
    }

    try {
      final nuevo = Project(name: nombre, status: 'VIVO');
      await Amplify.DataStore.save(nuevo);
      debugPrint('Proyecto creado (DataStore): ${nuevo.id}');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proyecto creado')));
      // observe/Hub/requery se encargará de actualizar la UI
    } catch (e) {
      debugPrint('Error creando proyecto: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error creando proyecto')));
    }
  }

  Future<void> _borrarProyecto(Project proyecto) async {
    try {
      await Amplify.DataStore.delete(proyecto);
      debugPrint('Proyecto borrado: ${proyecto.id}');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proyecto borrado')));
    } catch (e) {
      debugPrint('Error borrando proyecto: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error borrando proyecto')));
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
          const Text('Terrasacha', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(children: [
              const Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('Bienvenido,', style: TextStyle(color: Colors.white70, fontSize: 10)),
                Text('Usuario_terrasacha2026', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ]),
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
        Container(color: Colors.white, child: Row(children: [
          _buildTab("Proyectos", active: _selectedTab == 'Proyectos'),
          _buildTab("Salidas", active: _selectedTab == 'Salidas'),
          _buildTab("Equipos", active: _selectedTab == 'Equipos'),
        ])),
        Expanded(
          child: cargando
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : RefreshIndicator(
            onRefresh: () async {
              await _requeryAllProjects();
            },
            child: ListView(padding: const EdgeInsets.all(16), children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Proyectos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                TextButton(onPressed: () {}, child: Text('Ver todos', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
              ]),
              const SizedBox(height: 12),
              if (proyectos.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.all(40.0), child: Text('No hay proyectos activos')))
              else
                ...proyectos.map((p) => _buildProjectCard(p)).toList(),
              const SizedBox(height: 80),
            ]),
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
            // Al pulsar "Inicio" nos aseguramos que la pestaña superior vuelva a "Proyectos"
            setState(() => _selectedTab = 'Proyectos');
          } else {
            // Aquí puedes navegar a otras pantallas si las tienes registradas
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Botón ${index} presionado')));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Reportes'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
        ],
      ),
    );
  }

  Widget _buildTab(String label, {bool active = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Cambiamos visualmente la pestaña activa
          setState(() => _selectedTab = label);

          // Si pulsaron "Equipos", navegamos a la pantalla EquiposScreen.
          // Cuando el usuario regrese (pop), forzamos que la pestaña vuelva a "Proyectos".
          if (label == 'Equipos') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EquiposScreen()),
            ).then((_) {
              // Cuando regresen desde EquiposScreen, resetear pestaña
              if (mounted) setState(() => _selectedTab = 'Proyectos');
            });
          }

          // Si quieres, aquí puedes añadir lógica para "Salidas" u otras pestañas.
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: active ? primaryColor : Colors.transparent, width: 2))),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: active ? primaryColor : Colors.grey, fontWeight: active ? FontWeight.bold : FontWeight.w500, fontSize: 14)),
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project proyecto) {
    String imageUrl = "https://images.unsplash.com/photo-1501004318641-b39e6451bec6?q=80&w=1000&auto=format&fit=crop";
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover)),
        Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(proyecto.name ?? 'Sin nombre', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text((proyecto.status ?? 'VIVO').toString().toUpperCase(), style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 4),
          const Text('Meta: ', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Progreso', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Text('65%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: 0.65, backgroundColor: Colors.grey.shade200, color: primaryColor, minHeight: 8)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Row(children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                  onPressed: () {
                    Navigator.pushNamed(context, '/trees', arguments: {'proyecto_id': proyecto.id, 'proyecto_nombre': proyecto.name});
                  },
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Ver Detalles', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 16)]),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Eliminar proyecto',
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Eliminar proyecto'),
                      content: const Text('¿Estás seguro que quieres eliminar este proyecto?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('No')),
                        ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Sí, eliminar')),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await _borrarProyecto(proyecto);
                  }
                },
              ),
            ]),
          ),
        ])),
      ]),
    );
  }
}