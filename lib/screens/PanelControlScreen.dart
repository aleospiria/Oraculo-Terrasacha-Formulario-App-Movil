// lib/Screens/PanelControlScreen.dart
import 'package:flutter/material.dart';
import 'package:capturador_datos_offline/Screens/ProyectosMenuScreen.dart';

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

  // Datos de prueba — se reemplazarán con queries a DataStore
  final int _proyectosActivos = 12;
  final int _tareasEnCurso = 84;
  final String _ultimaSincronizacion = '10:30 AM';

  final List<Map<String, dynamic>> _proyectosRecientes = [
    {
      'nombre': 'Plan de Reforestación Zona Norte',
      'estado': 'Activo',
      'tiempo': 'Hace 2 horas',
      'colorEstado': Color(0xFF4A5C24),
    },
    {
      'nombre': 'Levantamiento de parcelas',
      'estado': 'En progreso',
      'tiempo': 'Ayer',
      'colorEstado': Color(0xFFDD6B20),
    },
    {
      'nombre': 'Monitoreo de Suelos - Finca 3',
      'estado': 'Finalizado',
      'tiempo': '22/08/2023',
      'colorEstado': Color(0xFF718096),
    },
  ];

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Panel de Control',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              radius: 18,
              child: Icon(Icons.person_outline, color: primaryColor, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Resumen del sistema ──────────────────────────────────────
            const Text(
              'Resumen del sistema',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
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
            Row(
              children: [
                // Crear nuevo plan — destacado
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Crear nuevo plan')),
                      );
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
                              Icon(Icons.assignment_outlined,
                                  color: Colors.white, size: 36),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Icon(Icons.add_circle,
                                    color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Crear nuevo\nplan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Gestionar usuarios
                Expanded(
                  child: _buildAccionCard(
                    icono: Icons.group_outlined,
                    label: 'Gestionar\nusuarios',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gestionar usuarios')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Configurar checklist
                Expanded(
                  child: _buildAccionCard(
                    icono: Icons.checklist_outlined,
                    label: 'Configurar\nchecklist',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Configurar checklist')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Proyectos recientes ──────────────────────────────────────
            const Text(
              'Proyectos recientes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            ..._proyectosRecientes.map((p) => _buildProyectoRecienteCard(p)),
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
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Proyectos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Mapas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Más',
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _navLabel(int index) {
    const labels = ['Inicio', 'Proyectos', 'Tareas', 'Mapas', 'Más'];
    return labels[index];
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

  Widget _buildProyectoRecienteCard(Map<String, dynamic> proyecto) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProyectosMenuScreen()),
      ),
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
                    proyecto['nombre'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
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
                    color: (proyecto['colorEstado'] as Color).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    proyecto['estado'],
                    style: TextStyle(
                      color: proyecto['colorEstado'] as Color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  proyecto['tiempo'],
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