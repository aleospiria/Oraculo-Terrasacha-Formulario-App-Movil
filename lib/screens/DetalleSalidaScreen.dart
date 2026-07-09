import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chequeo_vehiculo.dart';
import '../models/plan_campo_borrador.dart';
import '../utils/flujo_asignacion_plantilla.dart';
import '../utils/servicio_salida.dart';
import 'ChequeoVehiculoScreen.dart';
import 'CreacionPlanScreen.dart';

class DetalleSalidaScreen extends StatefulWidget {
  final String salidaId;

  const DetalleSalidaScreen({super.key, required this.salidaId});

  @override
  State<DetalleSalidaScreen> createState() => _DetalleSalidaScreenState();
}

class _DetalleSalidaScreenState extends State<DetalleSalidaScreen> {
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);

  SalidaCampo? _salida;
  EjecucionSalida? _ejecucion;
  int _progreso = 0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);

    final salida = await ServicioSalida.obtener(widget.salidaId);
    final ejecucion = await ServicioSalida.obtenerEjecucion(widget.salidaId);
    final progreso = ServicioSalida.calcularProgreso(ejecucion);

    if (!mounted) return;
    setState(() {
      _salida = salida;
      _ejecucion = ejecucion;
      _progreso = progreso;
      _cargando = false;
    });
  }

  Future<void> _abrirNuevaAsignacionPlantilla() async {
    final salida = _salida;
    if (salida == null) return;

    try {
      final actualizada = await FlujoAsignacionPlantilla.asignarEnSalida(
        context: context,
        primaryColor: primaryColor,
        salida: salida,
      );
      if (!mounted) return;
      if (actualizada != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Plantilla asignada correctamente'),
            backgroundColor: primaryColor,
          ),
        );
        await _cargar();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo asignar: $e')),
      );
    }
  }

  bool get _puedeAsignarPlantillas {
    final salida = _salida;
    if (salida == null) return false;
    if (!hasAnyRole(['lider_cuadrilla', 'lider_proyecto'])) return false;
    if (_chequeoVehiculoPendiente) return false;
    return ServicioSalida.puedeAsignarPlantillas(salida);
  }

  /// El chequeo de transporte bloquea la operación mientras no esté completo.
  /// Si aún no existe registro, se asume que se requiere transporte.
  bool get _chequeoVehiculoPendiente {
    final chequeo = _chequeoVehiculo;
    if (chequeo == null) return true;
    if (!chequeo.aplicaTransporte) return false;
    return !chequeo.completado;
  }

  bool get _puedeGestionarSalida =>
      hasAnyRole(['lider_cuadrilla', 'lider_proyecto']);

  bool get _puedeEditarChequeo => hasRole('lider_cuadrilla');

  ChequeoVehiculoSalida? get _chequeoVehiculo => _ejecucion?.chequeoVehiculo;

  Future<void> _abrirChequeoVehiculo() async {
    final actualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ChequeoVehiculoScreen(
          salidaId: widget.salidaId,
          editable: _puedeEditarChequeo,
        ),
      ),
    );
    if (actualizado == true && mounted) {
      await _cargar();
    }
  }

  Future<void> _confirmarEliminarSalida() async {
    final salida = _salida;
    if (salida == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar salida'),
        content: Text(
          '¿Eliminar "${salida.nombre}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      final eliminada = await ServicioSalida.eliminar(salida.id);
      if (!mounted) return;

      if (!eliminada) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró la salida')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Salida eliminada'),
          backgroundColor: primaryColor,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo eliminar: $e')),
      );
    }
  }

  Future<void> _mostrarDialogoClonar() async {
    final salida = _salida;
    if (salida == null) return;

    if (!ServicioSalida.puedeClonar(salida, _progreso)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta salida no se puede clonar en su estado actual'),
        ),
      );
      return;
    }

    ModoClonacionSalida? modo;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clonar salida'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progreso actual: $_progreso%',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            const SizedBox(height: 16),
            const Text('¿Cómo deseas clonar esta salida?'),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.pending_actions, color: primaryColor),
              title: const Text('Solo pendientes'),
              subtitle: const Text(
                'Copia tareas y checklist no completados',
              ),
              onTap: () {
                modo = ModoClonacionSalida.soloPendientes;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.swap_horiz, color: primaryColor),
              title: const Text('Replanificar completa'),
              subtitle: const Text(
                'Copia todo para cambiar operadores o tareas',
              ),
              onTap: () {
                modo = ModoClonacionSalida.replanificarCompleta;
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );

    if (modo == null || !mounted) return;

    try {
      final clon = await ServicioSalida.prepararClon(
        salidaOrigenId: salida.id,
        modo: modo!,
      );

      final pasoInicial =
          modo == ModoClonacionSalida.replanificarCompleta ? 4 : 1;

      if (!mounted) return;

      final publicada = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => CreacionPlanScreen(
            salidaInicial: clon,
            pasoInicial: pasoInicial,
          ),
        ),
      );

      if (publicada == true && mounted) {
        await _cargar();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo clonar: $e')),
      );
    }
  }

  EstadoAsignacionEjecucion _estadoAsignacion(String asignacionId) {
    final match = _ejecucion?.asignaciones.where(
      (a) => a.asignacionId == asignacionId,
    );
    if (match == null || match.isEmpty) {
      return EstadoAsignacionEjecucion.pendiente;
    }
    return match.first.estado;
  }

  Future<void> _toggleAsignacion(AsignacionPlantillaPlan asignacion) async {
    final actual = _estadoAsignacion(asignacion.id);
    final nuevo = actual == EstadoAsignacionEjecucion.completada
        ? EstadoAsignacionEjecucion.pendiente
        : EstadoAsignacionEjecucion.completada;

    await ServicioSalida.actualizarEstadoAsignacion(
      salidaId: widget.salidaId,
      asignacionId: asignacion.id,
      estado: nuevo,
    );
    await _cargar();
  }

  bool _checklistCompletado(String itemId) {
    final match = _ejecucion?.checklistItems.where((c) => c.itemId == itemId);
    if (match == null || match.isEmpty) return false;
    return match.first.completado;
  }

  Future<void> _toggleChecklistItem(String itemId) async {
    await ServicioSalida.actualizarChecklistItem(
      salidaId: widget.salidaId,
      itemId: itemId,
      completado: !_checklistCompletado(itemId),
    );
    await _cargar();
  }

  String _formatFecha(DateTime? fecha) {
    if (fecha == null) return '—';
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    return '$d/$m/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final salida = _salida;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor, size: 18),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          'Detalle de salida',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          if (hasRole('lider_proyecto') && salida != null)
            IconButton(
              tooltip: 'Clonar salida',
              icon: Icon(Icons.copy_all_outlined, color: primaryColor),
              onPressed: _mostrarDialogoClonar,
            ),
          if (_puedeGestionarSalida && salida != null)
            IconButton(
              tooltip: 'Eliminar salida',
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: _confirmarEliminarSalida,
            ),
        ],
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : salida == null
              ? const Center(child: Text('Salida no encontrada'))
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildCabecera(salida),
                      const SizedBox(height: 16),
                      _buildSeccionChequeoVehiculo(),
                      const SizedBox(height: 12),
                      _buildSeccion(
                        titulo: 'Asignaciones de plantilla',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_chequeoVehiculoPendiente &&
                                hasAnyRole(
                                    ['lider_cuadrilla', 'lider_proyecto'])) ...[
                              _buildAvisoChequeoPendiente(),
                              const SizedBox(height: 12),
                            ],
                            if (_puedeAsignarPlantillas) ...[
                              OutlinedButton.icon(
                                onPressed: _abrirNuevaAsignacionPlantilla,
                                icon: Icon(Icons.add, color: primaryColor),
                                label: Text(
                                  'Asignar plantilla',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: primaryColor),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (salida.asignacionesPlantillas.isEmpty)
                              const Text('Sin asignaciones')
                            else
                              Column(
                                children: salida.asignacionesPlantillas
                                    .map(_buildFilaAsignacion)
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (salida.checklist != null)
                        _buildSeccion(
                          titulo: 'Checklist',
                          child: Column(
                            children: salida.checklist!.items
                                .map(
                                  (item) => CheckboxListTile(
                                    value: _checklistCompletado(item.id),
                                    onChanged: (_) =>
                                        _toggleChecklistItem(item.id),
                                    title: Text(item.titulo),
                                    subtitle: item.descripcion.isNotEmpty
                                        ? Text(item.descripcion)
                                        : null,
                                    activeColor: primaryColor,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      if (salida.salidaOrigenId != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Clonada desde salida anterior',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildCabecera(SalidaCampo salida) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            salida.nombre,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  salida.estado.etiqueta,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_progreso% completado',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progreso / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vigencia: ${_formatFecha(salida.fechaInicio)} — ${_formatFecha(salida.fechaFin)}',
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          if (salida.ubicacionRuta != null) ...[
            const SizedBox(height: 4),
            Text(
              salida.ubicacionRuta!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeccion({required String titulo, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildAvisoChequeoPendiente() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDD6B20).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined,
              color: Color(0xFFDD6B20), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _puedeEditarChequeo
                  ? 'Completa el chequeo de transporte antes de asignar plantillas.'
                  : 'Las asignaciones se habilitan cuando el líder de cuadrilla complete el chequeo de transporte.',
              style: const TextStyle(
                color: Color(0xFF8A4B12),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionChequeoVehiculo() {
    final chequeo = _chequeoVehiculo;
    final noAplica = chequeo != null && !chequeo.aplicaTransporte;
    final completado = chequeo?.completado == true;

    final Color estadoColor = completado
        ? primaryColor
        : (chequeo != null ? const Color(0xFFDD6B20) : Colors.grey);
    final String estadoTexto = noAplica
        ? 'No aplica transporte'
        : completado
            ? 'Completado'
            : (chequeo != null ? 'En progreso' : 'Pendiente');

    return _buildSeccion(
      titulo: 'Chequeo de transporte',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                completado
                    ? Icons.check_circle
                    : Icons.local_shipping_outlined,
                color: estadoColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                estadoTexto,
                style: TextStyle(
                  color: estadoColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          if (chequeo != null && chequeo.aplicaTransporte) ...[
            const SizedBox(height: 8),
            if (chequeo.placa.isNotEmpty)
              Text(
                'Placa: ${chequeo.placa}',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            if (chequeo.conductor.nombre.isNotEmpty)
              Text(
                'Conductor: ${chequeo.conductor.nombre}',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _abrirChequeoVehiculo,
            icon: Icon(
              _puedeEditarChequeo ? Icons.fact_check_outlined : Icons.visibility_outlined,
              color: primaryColor,
            ),
            label: Text(
              _puedeEditarChequeo
                  ? (chequeo == null ? 'Realizar chequeo' : 'Editar chequeo')
                  : 'Ver chequeo',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilaAsignacion(AsignacionPlantillaPlan asignacion) {
    final estado = _estadoAsignacion(asignacion.id);
    final completada = estado == EstadoAsignacionEjecucion.completada;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asignacion.templateNombre,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${asignacion.responsableNombre} · ${asignacion.responsableRol}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: completada ? 'Marcar pendiente' : 'Marcar completada',
            onPressed: () => _toggleAsignacion(asignacion),
            icon: Icon(
              completada ? Icons.check_circle : Icons.radio_button_unchecked,
              color: completada ? primaryColor : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
