import '../theme.dart';
// lib/Screens/EquiposScreen.dart
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/usuario_campo.dart';
import '../screens/DetalleSalidaScreen.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_salida.dart';

class EquiposScreen extends StatefulWidget {
  const EquiposScreen({super.key, this.embedded = false});

  /// Cuando es true, se muestra dentro de [ProyectosMenuScreen] sin AppBar propio.
  final bool embedded;

  @override
  State<EquiposScreen> createState() => _EquiposScreenState();
}

class _EquiposScreenState extends State<EquiposScreen> {
  static const Color primaryColor = terrasachaPrimaryColor;
  static const Color backgroundColor = terrasachaBackgroundColor;

  int _tabIndex = 0;
  bool _cargando = true;
  List<TareaEquipoVista> _tareas = [];

  @override
  void initState() {
    super.initState();
    if (!widget.embedded && !hasRole('lider_cuadrilla')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solo el jefe de cuadrilla puede ver tareas del equipo'),
          ),
        );
      });
      return;
    }
    if (hasRole('lider_cuadrilla')) {
      _cargarTareas();
    }
  }

  Future<void> _cargarTareas() async {
    setState(() => _cargando = true);

    final usuario = await servicioAutenticacion.getUsuarioActual();
    if (usuario == null) {
      if (mounted) setState(() => _cargando = false);
      return;
    }

    final tareas =
        await ServicioSalida.listarTareasEquipoParaLiderCuadrilla(usuario);

    if (!mounted) return;
    setState(() {
      _tareas = tareas;
      _cargando = false;
    });
  }

  List<TareaEquipoVista> get _tareasFiltradas {
    switch (_tabIndex) {
      case 0:
        return _tareas
            .where((t) => t.estado == EstadoTareaSalida.pendiente)
            .toList();
      case 1:
        return _tareas
            .where(
              (t) =>
                  t.estado == EstadoTareaSalida.enCurso && !t.pendienteValidacion,
            )
            .toList();
      case 2:
        return _tareas.where((t) => t.pendienteValidacion).toList();
      case 3:
        return _tareas
            .where((t) => t.estado == EstadoTareaSalida.completada)
            .toList();
      default:
        return _tareas;
    }
  }

  void _abrirSalida(TareaEquipoVista tarea) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleSalidaScreen(salidaId: tarea.salidaId),
      ),
    ).then((_) => _cargarTareas());
  }

  @override
  Widget build(BuildContext context) {
    final contenido = _buildContenido();

    if (widget.embedded) return contenido;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tareas del Equipo',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: contenido,
    );
  }

  Widget _buildContenido() {
    return Column(
      children: [
        _buildTopTabs(),
        Expanded(
          child: _cargando
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : RefreshIndicator(
                  onRefresh: _cargarTareas,
                  color: primaryColor,
                  child: _tareasFiltradas.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                child: Text(
                                  _mensajeVacio(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text(
                              _tabTitleForIndex(_tabIndex),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._tareasFiltradas.map(_buildTareaCard),
                            const SizedBox(height: 24),
                          ],
                        ),
                ),
        ),
      ],
    );
  }

  String _mensajeVacio() {
    if (_tareas.isEmpty) {
      return 'No hay tareas de operadores en tus salidas activas.\n'
          'Asigna plantillas desde el detalle de una salida.';
    }
    return 'No hay tareas en este estado.';
  }

  Widget _buildTopTabs() {
    const tabs = ['Pendiente', 'En progreso', 'Validación', 'Completado'];

    return Container(
      color: Colors.white,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final active = index == _tabIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: active ? primaryColor : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: active ? primaryColor : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.grey.shade700,
                    fontWeight: active ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTareaCard(TareaEquipoVista tarea) {
    final accion = tarea.estado == EstadoTareaSalida.completada
        ? null
        : tarea.pendienteValidacion
            ? 'Revisar'
            : 'Ver salida';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    children: [
                      const TextSpan(
                        text: 'Operador: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: tarea.operadorNombre),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    children: [
                      const TextSpan(
                        text: 'Ubicación: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: tarea.ubicacionDisplay),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tarea.templateNombre,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  '${tarea.salidaNombre} · ${tarea.progresoPorcentaje}% completado',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(_iconoEstado(tarea), color: primaryColor, size: 26),
          if (accion != null) ...[
            const SizedBox(width: 8),
            SizedBox(
              height: 38,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _abrirSalida(tarea),
                child: Text(
                  accion,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ] else
            Icon(Icons.check_circle, color: primaryColor, size: 28),
        ],
      ),
    );
  }

  IconData _iconoEstado(TareaEquipoVista tarea) {
    if (tarea.estado == EstadoTareaSalida.completada) {
      return Icons.check_circle_outline;
    }
    if (tarea.pendienteValidacion) return Icons.fact_check_outlined;
    if (tarea.estado == EstadoTareaSalida.enCurso) return Icons.sync;
    return Icons.cloud_outlined;
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
