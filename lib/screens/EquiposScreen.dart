// lib/Screens/EquiposScreen.dart
import 'package:flutter/material.dart';

class EquiposScreen extends StatefulWidget {
  const EquiposScreen({super.key});

  @override
  State<EquiposScreen> createState() => _EquiposScreenState();
}

class _EquiposScreenState extends State<EquiposScreen> {
  static const Color primaryColor = Color(0xFF8A8F4A);
  static const Color backgroundColor = Color(0xFFF8F7F1);

  int _tabIndex = 0;
  int _bottomIndex = 1; // "Mis Tareas" o "Equipo", ajusta si quieres

  final List<_EquipoTarea> _tareas = [
    _EquipoTarea(
      operador: 'Juan Pérez',
      ubicacion: 'Sector A, Parcela 12',
      estado: 'Pendiente',
      tipoIcono: Icons.cloud_outlined,
      accion: 'Continuar',
    ),
    _EquipoTarea(
      operador: 'María Rodríguez',
      ubicacion: 'Campo Norte, Zona 4',
      estado: 'Pendiente',
      tipoIcono: Icons.cloud_upload_outlined,
      accion: 'Continuar',
    ),
    _EquipoTarea(
      operador: 'Carlos Gómez',
      ubicacion: 'Finca Santa Rosa',
      estado: 'En progreso',
      tipoIcono: Icons.sync,
      accion: 'Continuar',
    ),
    _EquipoTarea(
      operador: 'Ana López',
      ubicacion: 'Lote 7, Área Experimental',
      estado: 'Validación',
      tipoIcono: Icons.help_outline,
      accion: 'Revisar',
    ),
    _EquipoTarea(
      operador: 'Pedro Díaz',
      ubicacion: 'Almacén Central',
      estado: 'Completado',
      tipoIcono: Icons.check_circle_outline,
      accion: '',
    ),
  ];

  List<_EquipoTarea> get _tareasFiltradas {
    switch (_tabIndex) {
      case 0:
        return _tareas.where((e) => e.estado == 'Pendiente').toList();
      case 1:
        return _tareas.where((e) => e.estado == 'En progreso').toList();
      case 2:
        return _tareas.where((e) => e.estado == 'Validación').toList();
      case 3:
        return _tareas.where((e) => e.estado == 'Completado').toList();
      default:
        return _tareas;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tareas del Equipo',
          style: TextStyle(
            color: Color(0xFF5B5B2E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined, color: Colors.black87),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopTabs(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(_tabTitleForIndex(_tabIndex)),
                  const SizedBox(height: 12),
                  ..._tareasFiltradas.map((tarea) => _buildTareaCard(tarea)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (index) {
          setState(() => _bottomIndex = index);

          if (index == 0) {
            // Volver a Proyectos: hacemos pop para regresar a la pantalla anterior (ProyectosMenuScreen).
            // Esa pantalla (ProyectosMenuScreen) tiene un `.then(...)` en el push que forzará
            // la pestaña superior a volver a "Proyectos" cuando se haga pop.
            Navigator.pop(context);
            return;
          }

          // Por ahora solo visual para el resto
          if (index == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ya estás en Equipo')),
            );
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ir a Mapa')),
            );
          } else if (index == 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ir a Perfil')),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Mis Tareas'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildTopTabs() {
    final tabs = ['Pendiente', 'En progreso', 'Validación', 'Completado'];

    return Container(
      color: Colors.white,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final active = index == _tabIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _tabIndex = index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: active ? primaryColor.withOpacity(0.85) : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: active ? primaryColor : Colors.grey.shade300,
                      width: 2,
                    ),
                    top: BorderSide(color: Colors.grey.shade300, width: 1),
                    left: BorderSide(color: Colors.grey.shade300, width: 1),
                    right: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? Colors.white : const Color(0xFF4D4D4D),
                    fontWeight: active ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3E3E1F),
      ),
    );
  }

  Widget _buildTareaCard(_EquipoTarea tarea) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5EA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB8B27A), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF303030),
                    ),
                    children: [
                      const TextSpan(
                        text: 'Operador: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: tarea.operador,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF303030),
                    ),
                    children: [
                      const TextSpan(
                        text: 'Ubicación: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: tarea.ubicacion,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            tarea.tipoIcono,
            color: primaryColor,
            size: 28,
          ),
          const SizedBox(width: 10),
          if (tarea.estado != 'Completado')
            SizedBox(
              height: 38,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${tarea.accion} tarea de ${tarea.operador}'),
                    ),
                  );
                },
                child: Text(
                  tarea.accion,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            const Icon(
              Icons.check,
              color: primaryColor,
              size: 30,
            ),
        ],
      ),
    );
  }

  String _tabTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Pendiente';
      case 1:
        return 'En progreso';
      case 2:
        return 'Pendiente de validación';
      case 3:
        return 'Completado';
      default:
        return 'Tareas del Equipo';
    }
  }
}

class _EquipoTarea {
  final String operador;
  final String ubicacion;
  final String estado;
  final IconData tipoIcono;
  final String accion;

  _EquipoTarea({
    required this.operador,
    required this.ubicacion,
    required this.estado,
    required this.tipoIcono,
    required this.accion,
  });
}