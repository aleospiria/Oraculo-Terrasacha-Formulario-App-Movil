import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'dart:convert';

class ProyectosMenuScreen extends StatefulWidget {
  const ProyectosMenuScreen({super.key});

  @override
  State<ProyectosMenuScreen> createState() => _ProyectosMenuScreenState();
}

class _ProyectosMenuScreenState extends State<ProyectosMenuScreen> {
  List<dynamic> proyectos = [];
  bool cargando = true;

  // Colores del diseño
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);

  @override
  void initState() {
    super.initState();
    _cargarDesdeNube();
  }

  Future<void> _cargarDesdeNube() async {
    if (!mounted) return;
    setState(() => cargando = true);

    try {
      String graphQLDocument = '''
        query ListProjects {
          listProjects {
            items {
              id
              name
              status
            }
          }
        }
      ''';

      final operation = Amplify.API.query(
        request: GraphQLRequest<String>(document: graphQLDocument),
      );

      final response = await operation.response;
      final data = response.data;

      if (data != null) {
        final Map<String, dynamic> jsonMap = json.decode(data);
        if (mounted) {
          setState(() {
            proyectos = jsonMap['listProjects']['items'];
            cargando = false;
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // --- HEADER PERSONALIZADO ---
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 4,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.park, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Terrasacha',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Bienvenido,', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    Text('Usuario_terrasacha2026', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  radius: 18,
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ),
          )
        ],
      ),

      body: Column(
        children: [
          // --- TABS DE NAVEGACIÓN SUPERIOR ---
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildTab("Proyectos", active: true),
                _buildTab("Salidas"),
                _buildTab("Equipos"),
              ],
            ),
          ),

          Expanded(
            child: cargando
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : RefreshIndicator(
              onRefresh: _cargarDesdeNube,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Título de sección
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Proyectos',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Ver todos', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // --- LISTA DE TARJETAS DE PROYECTO ---
                  if (proyectos.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text('No hay proyectos activos'),
                    ))
                  else
                    ...proyectos.map((p) => _buildProjectCard(p)).toList(),

                  const SizedBox(height: 80), // Espacio para el FAB
                ],
              ),
            ),
          ),
        ],
      ),

      // --- BOTÓN FLOTANTE ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // --- BARRA DE NAVEGACIÓN INFERIOR ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: active ? primaryColor : Colors.transparent, width: 2),
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
    );
  }

  Widget _buildProjectCard(dynamic proyecto) {
    // Imagen aleatoria de naturaleza
    String imageUrl = "https://images.unsplash.com/photo-1501004318641-b39e6451bec6?q=80&w=1000&auto=format&fit=crop";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen de cabecera de la tarjeta
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
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
                        proyecto['name'] ?? 'Sin nombre',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (proyecto['status'] ?? 'VIVO').toString().toUpperCase(),
                        style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Meta: ',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                // Barra de progreso
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Progreso', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    Text('65%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: Colors.grey.shade200,
                    color: primaryColor,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 20),
                // Botón de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/trees',
                        arguments: {
                          'proyecto_id': proyecto['id'],
                          'proyecto_nombre': proyecto['name'],
                        },
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ver Detalles', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
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
}