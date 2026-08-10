import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chequeo_vehiculo.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';
import '../utils/flujo_asignacion_plantilla.dart';
import '../utils/roles_campo.dart';
import '../utils/servicio_plantillas.dart';
import '../utils/servicio_accidentes.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_salida.dart';
import '../widgets/asignacion_plantilla_sheet.dart';
import 'ChequeoVehiculoScreen.dart';
import 'ChecklistSalidaScreen.dart';
import 'CreacionPlanScreen.dart';
import 'RegistroIncidenciaScreen.dart';
import '../theme.dart';

class DetalleSalidaScreen extends StatefulWidget {
  final String salidaId;

  const DetalleSalidaScreen({super.key, required this.salidaId});

  @override
  State<DetalleSalidaScreen> createState() => _DetalleSalidaScreenState();
}

class _DetalleSalidaScreenState extends State<DetalleSalidaScreen> {
  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;

  SalidaCampo? _salida;
  EjecucionSalida? _ejecucion;
  UsuarioCampo? _usuarioActual;
  int _progreso = 0;
  int _incidenciasSalida = 0;
  bool _cargando = true;
  bool _abriendoAsignacion = false;

  /// Día mostrado en la sección de checklist.
  DateTime? _diaChecklist;

  /// Día mostrado en la sección de asignaciones de plantilla.
  DateTime? _diaAsignaciones;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);

    SalidaCampo? salida = await ServicioSalida.obtener(widget.salidaId);
    if (salida != null) {
      salida = await ServicioSalida.normalizarAsignacionesSinDiaEnSalida(
        salida.id,
      );
    }
    final ejecucion = await ServicioSalida.obtenerEjecucion(widget.salidaId);
    final progreso = salida != null
        ? ServicioSalida.calcularProgreso(salida, ejecucion)
        : 0;
    final usuario = await servicioAutenticacion.getUsuarioActual();
    final incidencias = await ServicioAccidentes().listarPorSalida(widget.salidaId);

    final diaChecklistAnterior = _diaChecklist;
    final diaAsignacionesAnterior = _diaAsignaciones;
    DateTime? diaChecklist;
    DateTime? diaAsignaciones;
    if (salida != null) {
      final dias = ServicioSalida.diasSalida(salida);
      diaChecklist = _resolverDiaSalida(dias, diaChecklistAnterior);
      diaAsignaciones = _resolverDiaSalida(dias, diaAsignacionesAnterior);
    }

    if (!mounted) return;
    setState(() {
      _salida = salida;
      _ejecucion = ejecucion;
      _progreso = progreso;
      _usuarioActual = usuario;
      _incidenciasSalida = incidencias.length;
      _diaChecklist = diaChecklist;
      _diaAsignaciones = diaAsignaciones;
      _cargando = false;
    });

    // Precarga plantillas para que "Asignar plantilla" abra al instante.
    // ignore: unawaited_futures
    ServicioPlantillas.cargarPlantillasConFeatures();
  }

  DateTime? _resolverDiaSalida(List<DateTime> dias, DateTime? anterior) {
    if (dias.isEmpty) return null;
    if (anterior != null && dias.contains(anterior)) return anterior;
    final hoy = ServicioSalida.normalizarFecha(DateTime.now());
    return dias.contains(hoy) ? hoy : dias.first;
  }

  Future<void> _abrirNuevaAsignacionPlantilla() async {
    final salida = _salida;
    if (salida == null || _abriendoAsignacion) return;

    setState(() => _abriendoAsignacion = true);
    try {
      final actualizada = await FlujoAsignacionPlantilla.asignarEnSalida(
        context: context,
        primaryColor: primaryColor,
        salida: salida,
        diaInicial: _diaAsignaciones,
        ejecucion: _ejecucion,
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
    } finally {
      if (mounted) setState(() => _abriendoAsignacion = false);
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
  /// Si el plan no lo requiere, no bloquea.
  bool get _chequeoVehiculoPendiente {
    final salida = _salida;
    if (salida == null) return false;
    if (!salida.requiereChequeoVehiculo) return false;
    final chequeo = _chequeoVehiculo;
    if (chequeo == null) return true;
    if (!chequeo.aplicaTransporte) return false;
    return !chequeo.completado;
  }

  bool get _puedeGestionarSalida =>
      hasAnyRole(['lider_cuadrilla', 'lider_proyecto']);

  bool get _puedeGestionarClima {
    final salida = _salida;
    if (salida == null || !_puedeGestionarSalida) return false;
    return salida.estado == EstadoSalida.programada ||
        salida.estado == EstadoSalida.enCurso ||
        salida.estado == EstadoSalida.incompleta;
  }

  DiaSuspendidoSalida? _suspendidoDe(DateTime? dia) {
    final salida = _salida;
    if (salida == null || dia == null) return null;
    return ServicioSalida.diaSuspendidoDe(salida, dia);
  }

  bool get _puedeEditarChequeo => hasRole('lider_cuadrilla');

  /// El líder de cuadrilla es el único que puede marcar ítems, adjuntar
  /// evidencia y cerrar el checklist de cualquier persona del equipo.
  bool get _puedeEditarChecklist => hasRole('lider_cuadrilla');

  ChequeoVehiculoSalida? get _chequeoVehiculo => _ejecucion?.chequeoVehiculo;

  /// Miembros del equipo que tienen checklist individual: operadores y el
  /// líder de cuadrilla (el líder de proyecto no llena checklist propio).
  List<MiembroEquipoPlan> get _miembrosConChecklist {
    final salida = _salida;
    if (salida == null) return [];
    return ServicioSalida.miembrosConChecklist(salida);
  }

  /// Días de la salida (uno por cada jornada de campo), para el selector.
  List<DateTime> get _diasSalida {
    final salida = _salida;
    if (salida == null) return [];
    return ServicioSalida.diasSalida(salida);
  }

  List<AsignacionPlantillaPlan> get _asignacionesDelDiaSeleccionado {
    final salida = _salida;
    final dia = _diaAsignaciones;
    if (salida == null || dia == null) return const [];
    return salida.asignacionesPlantillas
        .where((a) => a.fechaSubArea == dia)
        .toList();
  }

  List<AsignacionPlantillaPlan> get _asignacionesSinDia {
    final salida = _salida;
    if (salida == null) return const [];
    return salida.asignacionesPlantillas
        .where((a) => a.fechaSubArea == null)
        .toList();
  }

  bool get _todosLosChecklistsCompletadosHoy {
    final miembros = _miembrosConChecklist;
    final dia = _diaChecklist;
    final ejecucion = _ejecucion;
    if (miembros.isEmpty || dia == null || ejecucion == null) return false;
    return miembros.every(
      (m) =>
          ServicioSalida.checklistDeMiembroEnFecha(ejecucion, m, dia)
              ?.completado ==
          true,
    );
  }

  bool _esMiembroActual(MiembroEquipoPlan miembro) {
    final usuario = _usuarioActual;
    if (usuario == null) return false;
    final id = miembro.userId;
    if (id != null && id.isNotEmpty && usuario.id.isNotEmpty) {
      return id == usuario.id;
    }
    return miembro.nombre.toLowerCase().trim() ==
        usuario.nombre.toLowerCase().trim();
  }

  Future<void> _abrirChecklistDeMiembro(MiembroEquipoPlan miembro) async {
    final checklist = _salida?.checklist;
    final dia = _diaChecklist;
    if (checklist == null || dia == null) return;

    final actualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ChecklistSalidaScreen(
          salidaId: widget.salidaId,
          checklist: checklist,
          personaId: ServicioSalida.personaIdDeMiembro(miembro),
          personaNombre: miembro.nombre,
          personaRol: miembro.rol,
          fecha: dia,
          puedeEditarItems: _puedeEditarChecklist,
          puedeEditarObservacion: _esMiembroActual(miembro),
        ),
      ),
    );
    if (actualizado == true && mounted) {
      await _cargar();
    }
  }

  String _formatFechaCorta(DateTime fecha) {
    const meses = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]}';
  }

  Future<void> _abrirPosponerDiaPorClima() async {
    final salida = _salida;
    final ejecucion = _ejecucion;
    final dia = _diaAsignaciones ??
        (_diasSalida.length == 1 ? _diasSalida.first : null);
    if (salida == null || dia == null || !_puedeGestionarClima) return;

    if (ServicioSalida.esDiaSuspendido(salida, dia)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este día ya está marcado como suspendido')),
      );
      return;
    }

    var motivo = 'lluvia';
    var destino = ServicioSalida.sugerirDiaReprogramacion(salida, dia);
    final pendientes = ejecucion == null
        ? 0
        : ServicioSalida.contarAsignacionesPendientesDelDia(
            salida,
            ejecucion,
            dia,
          );

    final confirmado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final extiendeFin = salida.fechaFin == null ||
                destino.isAfter(
                  ServicioSalida.normalizarFecha(salida.fechaFin!),
                );
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                20 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Flexibilidad por clima',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Suspende el ${_formatFechaCorta(dia)} y mueve las '
                    'mediciones pendientes a otro día.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: motivo,
                    decoration: const InputDecoration(
                      labelText: 'Motivo',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'lluvia',
                        child: Text('Lluvia / clima'),
                      ),
                      DropdownMenuItem(
                        value: 'acceso',
                        child: Text('Sin acceso al predio'),
                      ),
                      DropdownMenuItem(
                        value: 'otro',
                        child: Text('Otro'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setLocal(() => motivo = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Mover trabajo a'),
                    subtitle: Text(_formatFechaCorta(destino)),
                    trailing: TextButton(
                      onPressed: () async {
                        final elegido = await showDatePicker(
                          context: ctx,
                          initialDate: destino,
                          firstDate: dia.add(const Duration(days: 1)),
                          lastDate: dia.add(const Duration(days: 90)),
                          helpText: 'Nuevo día de campo',
                        );
                        if (elegido != null) {
                          setLocal(
                            () => destino =
                                ServicioSalida.normalizarFecha(elegido),
                          );
                        }
                      },
                      child: const Text('Cambiar'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: terrasachaCardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      pendientes == 0
                          ? 'No hay asignaciones pendientes este día '
                              '(solo se registrará la suspensión).'
                          : 'Se moverán $pendientes asignación(es) pendiente(s). '
                              'Las ya completadas se quedan en el día original.'
                              '${extiendeFin ? ' Se extenderá la fecha fin de la salida.' : ''}',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade800,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Confirmar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (confirmado != true || !mounted) return;

    try {
      final actualizada = await ServicioSalida.suspenderYReprogramarDia(
        salidaId: salida.id,
        diaOrigen: dia,
        diaDestino: destino,
        motivo: motivo,
        autorNombre: _usuarioActual?.nombre,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Día ${_formatFechaCorta(dia)} suspendido · trabajo en '
            '${_formatFechaCorta(destino)}',
          ),
          backgroundColor: primaryColor,
        ),
      );
      setState(() {
        _salida = actualizada;
        _diaAsignaciones = destino;
        _diaChecklist = destino;
      });
      await _cargar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo reprogramar: $e')),
      );
    }
  }

  Widget _buildBannerDiaSuspendido(DateTime dia) {
    final info = _suspendidoDe(dia);
    if (info == null) return const SizedBox.shrink();
    final destino = info.reprogramadoA;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8D79A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.cloud_off_outlined, color: Color(0xFF8D6E00)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Día suspendido · ${info.motivoEtiqueta}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6D5600),
                    fontSize: 13,
                  ),
                ),
                if (destino != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Trabajo pendiente movido a ${_formatFechaCorta(destino)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (destino != null && _puedeGestionarSalida)
            TextButton(
              onPressed: () => setState(() {
                _diaAsignaciones = destino;
                _diaChecklist = destino;
              }),
              child: const Text('Ir al día'),
            ),
        ],
      ),
    );
  }

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

  Future<void> _editarAsignacion(AsignacionPlantillaPlan actual) async {
    final salida = _salida;
    if (salida == null || _abriendoAsignacion) return;

    setState(() => _abriendoAsignacion = true);
    try {
      final cargados = await Future.wait([
        FlujoAsignacionPlantilla.responsablesParaSalida(salida),
        ServicioPlantillas.cargarPlantillasConFeatures(),
      ]);
      if (!mounted) return;
      final responsables = cargados[0] as List<UsuarioCampo>;
      final plantillas = cargados[1] as List<PlantillaConFeatures>;
      final datos = await AsignacionPlantillaSheet.mostrar(
        context,
        primaryColor: primaryColor,
        plantillas: plantillas,
        responsables: responsables.map((u) => u.paraSheet).toList(),
        diasSalida: _diasSalida,
        asignacionesExistentes: salida.asignacionesPlantillas,
        ejecucion: _ejecucion,
        excluirAsignacionId: actual.id,
        requiereDia: _diasSalida.length > 1,
        diaInicial: _diaAsignaciones,
        datosIniciales: AsignacionPlantillaSheetDatos(
          templateId: actual.templateId,
          templateNombre: actual.templateNombre,
          featureIds: List<String>.from(actual.featureIds),
          featureNombres: List<String>.from(actual.featureNombres),
          operadorNombre: actual.operadorNombre,
          operadorRol: actual.operadorRol,
          responsableUserId: actual.responsableUserId,
          fechaSubArea: actual.fechaSubArea,
        ),
      );
      if (!mounted || datos == null) return;

      final actualizada = FlujoAsignacionPlantilla.asignacionDesdeSheet(
        datos,
        id: actual.id,
      );

      await ServicioSalida.actualizarAsignacionPlantilla(
        salidaId: salida.id,
        asignacion: actualizada,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Asignación actualizada'),
          backgroundColor: primaryColor,
        ),
      );
      await _cargar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo editar la asignación: $e')),
      );
    } finally {
      if (mounted) setState(() => _abriendoAsignacion = false);
    }
  }

  ({int completadas, int enCurso, int total}) _progresoAsignacion(
    AsignacionPlantillaPlan asignacion,
  ) {
    final total = asignacion.featureIds.length;
    final ejecucionAsignacion = _ejecucion?.asignaciones
        .where((a) => a.asignacionId == asignacion.id)
        .firstOrNull;
    if (total == 0 || ejecucionAsignacion == null) {
      return (completadas: 0, enCurso: 0, total: total);
    }

    var completadas = 0;
    var enCurso = 0;
    for (final featureId in asignacion.featureIds) {
      final registro = ejecucionAsignacion.registroDeFeature(featureId);
      if (registro == null) continue;
      if (registro.estado == EstadoAsignacionEjecucion.completada) completadas++;
      if (registro.estado == EstadoAsignacionEjecucion.enCurso) enCurso++;
    }
    return (completadas: completadas, enCurso: enCurso, total: total);
  }

  Widget _buildSeccionChecklist(ChecklistPlanAsignado checklist) {
    final miembros = _miembrosConChecklist;
    final ejecucion = _ejecucion;
    final dias = _diasSalida;
    final dia = _diaChecklist;
    final totalCompletados = miembros
        .where(
          (m) =>
              ejecucion != null &&
              dia != null &&
              ServicioSalida.checklistDeMiembroEnFecha(ejecucion, m, dia)
                      ?.completado ==
                  true,
        )
        .length;

    final Color estadoColor = _todosLosChecklistsCompletadosHoy
        ? primaryColor
        : (totalCompletados > 0 ? const Color(0xFFDD6B20) : Colors.grey);
    final String estadoTexto = _todosLosChecklistsCompletadosHoy
        ? 'Completado'
        : (totalCompletados > 0 ? 'En progreso' : 'Pendiente');

    return _buildSeccion(
      titulo: 'Checklist',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (dias.length > 1) ...[
            _buildSelectorDias(
              dias,
              seleccionado: _diaChecklist,
              onSeleccionar: (dia) => setState(() => _diaChecklist = dia),
            ),
            const SizedBox(height: 12),
          ],
          if (_diaChecklist != null) _buildBannerDiaSuspendido(_diaChecklist!),
          Row(
            children: [
              Icon(
                _todosLosChecklistsCompletadosHoy
                    ? Icons.check_circle
                    : Icons.checklist_rtl_outlined,
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
          const SizedBox(height: 6),
          Text(
            '$totalCompletados de ${miembros.length} personas completaron su checklist'
            '${dia != null ? ' del ${_formatFechaCorta(dia)}' : ''}',
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          const SizedBox(height: 12),
          if (miembros.isEmpty)
            Text(
              'No hay operadores ni líder de cuadrilla en el equipo',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            )
          else if (dia == null)
            Text(
              'Define las fechas de la salida para habilitar el checklist',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            )
          else
            ...miembros.map((m) => _buildFilaChecklistMiembro(m, checklist, dia)),
        ],
      ),
    );
  }

  Widget _buildSelectorDias(
    List<DateTime> dias, {
    required DateTime? seleccionado,
    required ValueChanged<DateTime> onSeleccionar,
  }) {
    final salida = _salida;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dias.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final dia = dias[index];
          final esSeleccionado = dia == seleccionado;
          final suspendido =
              salida != null && ServicioSalida.esDiaSuspendido(salida, dia);
          return ChoiceChip(
            avatar: suspendido
                ? Icon(
                    Icons.cloud_off,
                    size: 14,
                    color: esSeleccionado
                        ? const Color(0xFF8D6E00)
                        : Colors.grey.shade600,
                  )
                : null,
            label: Text(
              suspendido
                  ? '${_formatFechaCorta(dia)} · N/A'
                  : _formatFechaCorta(dia),
            ),
            selected: esSeleccionado,
            onSelected: (_) => onSeleccionar(dia),
            selectedColor: suspendido
                ? const Color(0xFFFFF3CD)
                : primaryColor.withValues(alpha: 0.15),
            backgroundColor: suspendido ? const Color(0xFFFFFBF0) : null,
            labelStyle: TextStyle(
              color: suspendido
                  ? const Color(0xFF8D6E00)
                  : (esSeleccionado ? primaryColor : Colors.grey[700]),
              fontWeight: esSeleccionado ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12,
            ),
            side: BorderSide(
              color: suspendido
                  ? const Color(0xFFE8D79A)
                  : (esSeleccionado ? primaryColor : Colors.grey.shade300),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilaChecklistMiembro(
    MiembroEquipoPlan miembro,
    ChecklistPlanAsignado checklist,
    DateTime dia,
  ) {
    final ejecucion = _ejecucion;
    final personal = ejecucion != null
        ? ServicioSalida.checklistDeMiembroEnFecha(ejecucion, miembro, dia)
        : null;
    final completados = personal?.items.where((i) => i.completado).length ?? 0;
    final total = checklist.items.length;
    final completado = personal?.completado == true;
    final esYo = _esMiembroActual(miembro);

    final Color colorEstado = completado
        ? primaryColor
        : (completados > 0 ? const Color(0xFFDD6B20) : Colors.grey);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: terrasachaBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _abrirChecklistDeMiembro(miembro),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  completado ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: colorEstado,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              esYo ? '${miembro.nombre} (yo)' : miembro.nombre,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${miembro.rol} · $completados de $total ítems'
                        '${personal != null && personal.evidencias.isNotEmpty ? ' · ${personal.evidencias.length} evidencia(s)' : ''}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      if (personal != null && personal.observaciones.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        ...personal.observaciones.map(
                          (obs) => Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${obs.etiquetaAutor}: "${obs.texto.trim()}"',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: obs.tipo == 'supervisor'
                                    ? Colors.orange.shade800
                                    : Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
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
                      if (salida.requiereChequeoVehiculo) ...[
                        _buildSeccionChequeoVehiculo(),
                        const SizedBox(height: 12),
                      ],
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
                                onPressed: _abriendoAsignacion
                                    ? null
                                    : _abrirNuevaAsignacionPlantilla,
                                icon: _abriendoAsignacion
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: primaryColor,
                                        ),
                                      )
                                    : Icon(Icons.add, color: primaryColor),
                                label: Text(
                                  _abriendoAsignacion
                                      ? 'Cargando...'
                                      : 'Asignar plantilla',
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
                            if (_diasSalida.length > 1) ...[
                              _buildSelectorDias(
                                _diasSalida,
                                seleccionado: _diaAsignaciones,
                                onSeleccionar: (dia) =>
                                    setState(() => _diaAsignaciones = dia),
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (_diaAsignaciones != null ||
                                _diasSalida.length == 1) ...[
                              _buildBannerDiaSuspendido(
                                _diaAsignaciones ?? _diasSalida.first,
                              ),
                            ],
                            if (_puedeGestionarClima &&
                                (_diaAsignaciones != null ||
                                    _diasSalida.length == 1) &&
                                _suspendidoDe(
                                      _diaAsignaciones ?? _diasSalida.first,
                                    ) ==
                                    null) ...[
                              OutlinedButton.icon(
                                onPressed: _abrirPosponerDiaPorClima,
                                icon: Icon(
                                  Icons.cloud_off_outlined,
                                  color: primaryColor,
                                ),
                                label: Text(
                                  'Día no operable / Posponer por clima',
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
                            else if (_diasSalida.length <= 1)
                              Column(
                                children: salida.asignacionesPlantillas
                                    .map(_buildFilaAsignacion)
                                    .toList(),
                              )
                            else ...[
                              if (_diaAsignaciones != null)
                                Text(
                                  'Mostrando asignaciones del ${_formatFechaCorta(_diaAsignaciones!)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              const SizedBox(height: 8),
                              if (_asignacionesDelDiaSeleccionado.isEmpty)
                                Text(
                                  'Sin asignaciones para este día',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                )
                              else
                                Column(
                                  children: _asignacionesDelDiaSeleccionado
                                      .map(_buildFilaAsignacion)
                                      .toList(),
                                ),
                              if (_asignacionesSinDia.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Asignaciones sin día específico',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  children: _asignacionesSinDia
                                      .map(_buildFilaAsignacion)
                                      .toList(),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (salida.checklist != null)
                        _buildSeccionChecklist(salida.checklist!),
                      if (RolesCampo.puedeReportarIncidencias(currentUserRole)) ...[
                        const SizedBox(height: 12),
                        _buildSeccionIncidencias(salida),
                      ],
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

  Future<void> _abrirIncidenciasSalida(SalidaCampo salida) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistroIncidenciaScreen(
          salidaId: salida.id,
          salidaNombre: salida.nombre,
        ),
      ),
    );
    if (mounted) await _cargar();
  }

  Widget _buildSeccionIncidencias(SalidaCampo salida) {
    return _buildSeccion(
      titulo: 'Incidencias y accidentes',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _incidenciasSalida == 0
                ? 'Sin reportes en esta salida'
                : '$_incidenciasSalida reporte${_incidenciasSalida == 1 ? '' : 's'} registrado${_incidenciasSalida == 1 ? '' : 's'}',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _abrirIncidenciasSalida(salida),
            icon: Icon(Icons.warning_amber_outlined, color: primaryColor),
            label: Text(
              'Ver y reportar incidencias',
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
    final progreso = _progresoAsignacion(asignacion);
    final ratio = progreso.total > 0 ? progreso.completadas / progreso.total : 0.0;
    final colorEstado = progreso.completadas == progreso.total && progreso.total > 0
        ? primaryColor
        : (progreso.enCurso > 0 ? const Color(0xFFDD6B20) : Colors.grey);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: terrasachaBackgroundColor,
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
                  '${asignacion.responsableNombre} · ${asignacion.responsableRol}'
                  '${asignacion.fechaSubArea != null ? ' · Día ${_formatFechaCorta(asignacion.fechaSubArea!)}' : ''}'
                  '${asignacion.featureIds.isNotEmpty ? ' · ${asignacion.featureIds.length} medición(es)' : ''}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 6),
                Text(
                  '${progreso.completadas}/${progreso.total} completadas'
                  '${progreso.enCurso > 0 ? ' · ${progreso.enCurso} en curso' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorEstado,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: ratio,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(4),
                  backgroundColor: Colors.grey.shade300,
                  color: colorEstado,
                ),
              ],
            ),
          ),
          if (_puedeAsignarPlantillas)
            IconButton(
              tooltip: 'Editar asignación',
              onPressed: () => _editarAsignacion(asignacion),
              icon: Icon(Icons.edit_outlined, color: primaryColor),
            ),
        ],
      ),
    );

  }
}
