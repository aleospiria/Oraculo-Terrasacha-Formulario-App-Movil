import 'package:flutter/material.dart';

import '../models/plan_campo_borrador.dart';
import '../utils/roles_campo.dart';
import '../utils/servicio_plantillas.dart';
import '../utils/servicio_salida.dart';

/// Tupla de responsable para el sheet de asignación.
typedef ResponsablePlantillaSheet = ({
  String nombre,
  String rol,
  String? userId,
});

class AsignacionPlantillaSheet extends StatefulWidget {
  final Color primaryColor;
  final List<PlantillaConFeatures> plantillas;
  final List<ResponsablePlantillaSheet> responsables;
  final List<DateTime> diasSalida;
  final List<AsignacionPlantillaPlan> asignacionesExistentes;
  final EjecucionSalida? ejecucion;
  final String? excluirAsignacionId;
  final bool requiereDia;
  final DateTime? diaInicial;
  final AsignacionPlantillaSheetDatos? datosIniciales;

  const AsignacionPlantillaSheet({
    super.key,
    required this.primaryColor,
    required this.plantillas,
    required this.responsables,
    this.diasSalida = const [],
    this.asignacionesExistentes = const [],
    this.ejecucion,
    this.excluirAsignacionId,
    this.requiereDia = false,
    this.diaInicial,
    this.datosIniciales,
  });

  /// Normaliza responsables antes de abrir el sheet (nombres/roles legibles).
  static List<ResponsablePlantillaSheet> normalizarResponsables(
    List<ResponsablePlantillaSheet> responsables,
  ) {
    final porDisplay = <String, ResponsablePlantillaSheet>{};

    for (final o in responsables) {
      final nombre = RolesCampo.normalizarNombre(o.nombre, rolCognito: o.rol);
      final rol = RolesCampo.etiquetaParaDropdown(o.rol);
      final clave = '${nombre.toLowerCase()}::${rol.toLowerCase()}';
      final entry = (nombre: nombre, rol: rol, userId: o.userId);
      final existente = porDisplay[clave];

      if (existente == null) {
        porDisplay[clave] = entry;
        continue;
      }

      if (entry.userId?.isNotEmpty == true &&
          (existente.userId == null || existente.userId!.isEmpty)) {
        porDisplay[clave] = entry;
      }
    }

    return porDisplay.values.toList();
  }

  static Future<AsignacionPlantillaSheetDatos?> mostrar(
    BuildContext context, {
    required Color primaryColor,
    required List<PlantillaConFeatures> plantillas,
    required List<ResponsablePlantillaSheet> responsables,
    List<DateTime> diasSalida = const [],
    List<AsignacionPlantillaPlan> asignacionesExistentes = const [],
    EjecucionSalida? ejecucion,
    String? excluirAsignacionId,
    bool requiereDia = false,
    DateTime? diaInicial,
    AsignacionPlantillaSheetDatos? datosIniciales,
  }) {
    return showModalBottomSheet<AsignacionPlantillaSheetDatos>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AsignacionPlantillaSheet(
        primaryColor: primaryColor,
        plantillas: plantillas,
        responsables: normalizarResponsables(responsables),
        diasSalida: diasSalida,
        asignacionesExistentes: asignacionesExistentes,
        ejecucion: ejecucion,
        excluirAsignacionId: excluirAsignacionId,
        requiereDia: requiereDia,
        diaInicial: diaInicial,
        datosIniciales: datosIniciales,
      ),
    );
  }

  @override
  State<AsignacionPlantillaSheet> createState() =>
      _AsignacionPlantillaSheetState();
}

class AsignacionPlantillaSheetDatos {
  final String templateId;
  final String templateNombre;
  final List<String> featureIds;
  final List<String> featureNombres;
  final String operadorNombre;
  final String operadorRol;
  final String? responsableUserId;
  final DateTime? fechaSubArea;

  const AsignacionPlantillaSheetDatos({
    required this.templateId,
    required this.templateNombre,
    required this.featureIds,
    required this.featureNombres,
    required this.operadorNombre,
    required this.operadorRol,
    this.responsableUserId,
    this.fechaSubArea,
  });
}

class _AsignacionPlantillaSheetState extends State<AsignacionPlantillaSheet> {
  PlantillaConFeatures? _plantillaSeleccionada;
  final Set<String> _featuresSeleccionados = {};
  int? _responsableIndice;
  DateTime? _fechaSubArea;

  Map<String, FeatureAsignadaPrevio> get _featuresBloqueadas {
    return ServicioSalida.featuresNoReasignables(
      asignaciones: widget.asignacionesExistentes,
      ejecucion: widget.ejecucion,
      excluirAsignacionId: widget.excluirAsignacionId,
    );
  }

  Map<String, FeatureAsignadaPrevio> get _featuresReasignables {
    return ServicioSalida.featuresYaAsignadas(
      asignaciones: widget.asignacionesExistentes,
      ejecucion: widget.ejecucion,
      excluirAsignacionId: widget.excluirAsignacionId,
      soloCompletadas: false,
    )..removeWhere((_, v) => v.completada);
  }

  void _sincronizarResponsableSeleccionado() {
    final lista = widget.responsables;
    if (lista.isEmpty) {
      _responsableIndice = null;
      return;
    }

    if (_responsableIndice != null &&
        _responsableIndice! >= 0 &&
        _responsableIndice! < lista.length) {
      return;
    }

    final iniciales = widget.datosIniciales;
    if (iniciales != null) {
      for (var i = 0; i < lista.length; i++) {
        final o = lista[i];
        final matchId = iniciales.responsableUserId != null &&
            iniciales.responsableUserId!.isNotEmpty &&
            o.userId == iniciales.responsableUserId;
        final matchNombre =
            RolesCampo.normalizarNombre(o.nombre) ==
                RolesCampo.normalizarNombre(iniciales.operadorNombre);
        if (matchId || matchNombre) {
          _responsableIndice = i;
          return;
        }
      }
    }

    _responsableIndice = 0;
  }

  void _inicializarDia() {
    if (_fechaSubArea != null) return;

    final dias = widget.diasSalida;
    if (dias.isEmpty) return;

    final diaInicial = widget.diaInicial;
    if (diaInicial != null) {
      final diaNormalizado = ServicioSalida.normalizarFecha(diaInicial);
      if (dias.contains(diaNormalizado)) {
        _fechaSubArea = diaNormalizado;
        return;
      }
    }

    if (dias.length == 1) {
      _fechaSubArea = dias.first;
      return;
    }

    final hoy = ServicioSalida.normalizarFecha(DateTime.now());
    _fechaSubArea = dias.contains(hoy) ? hoy : dias.first;
  }

  @override
  void initState() {
    super.initState();
    final iniciales = widget.datosIniciales;
    if (iniciales != null) {
      for (final p in widget.plantillas) {
        if (p.id == iniciales.templateId) {
          _plantillaSeleccionada = p;
          break;
        }
      }
      _featuresSeleccionados.addAll(iniciales.featureIds);
      _fechaSubArea = iniciales.fechaSubArea;
    } else if (widget.plantillas.isNotEmpty) {
      _plantillaSeleccionada = widget.plantillas.first;
    }
    _inicializarDia();
    _sincronizarResponsableSeleccionado();
  }

  void _seleccionarPlantilla(PlantillaConFeatures plantilla) {
    setState(() {
      _plantillaSeleccionada = plantilla;
      _featuresSeleccionados.clear();
    });
  }

  void _toggleFeature(String featureId) {
    if (_featuresBloqueadas.containsKey(featureId)) return;
    setState(() {
      if (_featuresSeleccionados.contains(featureId)) {
        _featuresSeleccionados.remove(featureId);
      } else {
        _featuresSeleccionados.add(featureId);
      }
    });
  }

  void _cambiarDia(DateTime? fecha) {
    setState(() {
      _fechaSubArea = fecha;
      final bloqueadas = _featuresBloqueadas;
      _featuresSeleccionados.removeWhere(bloqueadas.containsKey);
    });
  }

  String _formatFecha(DateTime fecha) {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    return '$d/$m/${fecha.year}';
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _guardar() {
    final plantilla = _plantillaSeleccionada;
    final indice = _responsableIndice;
    if (plantilla == null) return;
    if (indice == null) return;
    if (_featuresSeleccionados.isEmpty) return;

    if (widget.requiereDia && _fechaSubArea == null) {
      _mostrarError('Selecciona el día de trabajo para esta asignación.');
      return;
    }

    final bloqueadas = _featuresBloqueadas;
    final conflictos = _featuresSeleccionados
        .where(bloqueadas.containsKey)
        .map((id) => bloqueadas[id]!.featureNombre)
        .toList();
    if (conflictos.isNotEmpty) {
      _mostrarError(
        'Estas mediciones ya están completadas y no se pueden reasignar: '
        '${conflictos.join(', ')}.',
      );
      return;
    }

    final responsable = widget.responsables[indice];

    final features = plantilla.features
        .where((f) => _featuresSeleccionados.contains(f.id))
        .toList();

    Navigator.pop(
      context,
      AsignacionPlantillaSheetDatos(
        templateId: plantilla.id,
        templateNombre: plantilla.nombre,
        featureIds: features.map((f) => f.id).toList(),
        featureNombres: features.map((f) => f.nombre).toList(),
        operadorNombre: responsable.nombre,
        operadorRol: responsable.rol,
        responsableUserId: responsable.userId,
        fechaSubArea: _fechaSubArea,
      ),
    );
  }

  bool get _puedeGuardar {
    if (_plantillaSeleccionada == null) return false;
    if (_responsableIndice == null) return false;
    if (_featuresSeleccionados.isEmpty) return false;
    if (widget.requiereDia && _fechaSubArea == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bloqueadas = _featuresBloqueadas;
    final reasignables = _featuresReasignables;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.datosIniciales == null
                          ? 'Nueva asignación'
                          : 'Editar asignación',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.diasSalida.length > 1) ...[
                      const Text(
                        'Día de trabajo',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.requiereDia
                            ? 'Cada asignación corresponde a un día de la salida.'
                            : 'Opcional: vincula la asignación a un día concreto.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdownFecha(),
                      const SizedBox(height: 20),
                    ],
                    const Text(
                      'Plantilla',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    _buildDropdownPlantilla(),
                    const SizedBox(height: 20),
                    const Text(
                      'Mediciones / features',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (bloqueadas.isNotEmpty || reasignables.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        bloqueadas.isNotEmpty
                            ? 'Las mediciones completadas no se pueden reasignar. '
                                'Las pendientes sí: al guardar se mueven al nuevo responsable.'
                            : 'Si eliges una medición ya asignada y pendiente, '
                                'se reasignará al nuevo responsable.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                    const SizedBox(height: 8),
                    if (_plantillaSeleccionada == null ||
                        _plantillaSeleccionada!.features.isEmpty)
                      Text(
                        'Esta plantilla no tiene mediciones asociadas.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      )
                    else
                      ..._plantillaSeleccionada!.features.map((feature) {
                        final activo =
                            _featuresSeleccionados.contains(feature.id);
                        final previoBloqueado = bloqueadas[feature.id];
                        final previoReasignable = reasignables[feature.id];
                        final bloqueada = previoBloqueado != null;

                        return CheckboxListTile(
                          value: activo,
                          activeColor: widget.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            feature.nombre,
                            style: bloqueada
                                ? TextStyle(color: Colors.grey[500])
                                : null,
                          ),
                          subtitle: bloqueada
                              ? Text(
                                  'Completada'
                                  '${previoBloqueado.operadorNombre.isNotEmpty ? ' por ${previoBloqueado.operadorNombre}' : ''}'
                                  ' · no se puede reasignar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : previoReasignable != null
                                  ? Text(
                                      'Asignada a ${previoReasignable.operadorNombre.isNotEmpty ? previoReasignable.operadorNombre : 'otro usuario'}'
                                      '${previoReasignable.fecha != null ? ' · ${_formatFecha(previoReasignable.fecha!)}' : ''}'
                                      ' · se reasignará al guardar',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueGrey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : feature.featureGroup != null
                                      ? Text(
                                          feature.featureGroup!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        )
                                      : null,
                          onChanged: bloqueada
                              ? null
                              : (_) => _toggleFeature(feature.id),
                        );
                      }),
                    const SizedBox(height: 20),
                    const Text(
                      'Asignar a',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Puedes asignarte la plantilla a ti mismo o a un operador del equipo.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    _buildDropdownResponsable(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _puedeGuardar ? _guardar : null,
                  child: const Text(
                    'Guardar asignación',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownPlantilla() {
    final plantillaId = _plantillaSeleccionada?.id;
    final idValido = plantillaId != null &&
        widget.plantillas.any((p) => p.id == plantillaId);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: idValido ? plantillaId : null,
          hint: const Text('Seleccionar plantilla'),
          items: widget.plantillas
              .map(
                (p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.nombre),
                ),
              )
              .toList(),
          onChanged: (id) {
            if (id == null) return;
            final plantilla =
                widget.plantillas.firstWhere((p) => p.id == id);
            _seleccionarPlantilla(plantilla);
          },
        ),
      ),
    );
  }

  Widget _buildDropdownResponsable() {
    final responsables = widget.responsables;
    if (responsables.isEmpty) {
      return Text(
        'No hay responsables en el equipo.',
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      );
    }

    final indiceValido = _responsableIndice != null &&
        _responsableIndice! >= 0 &&
        _responsableIndice! < responsables.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: indiceValido ? _responsableIndice : null,
          hint: const Text('Seleccionar responsable'),
          items: List.generate(
            responsables.length,
            (i) {
              final o = responsables[i];
              return DropdownMenuItem<int>(
                value: i,
                child: Text('${o.nombre} (${o.rol})'),
              );
            },
          ),
          onChanged: (v) => setState(() => _responsableIndice = v),
        ),
      ),
    );
  }

  Widget _buildDropdownFecha() {
    final dias = widget.diasSalida;
    final fechaValida =
        _fechaSubArea != null && dias.contains(_fechaSubArea);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateTime>(
          isExpanded: true,
          value: fechaValida ? _fechaSubArea : null,
          hint: Text(
            widget.requiereDia
                ? 'Seleccionar día'
                : 'Sin día específico',
          ),
          items: dias
              .map(
                (fecha) => DropdownMenuItem<DateTime>(
                  value: fecha,
                  child: Text(_formatFecha(fecha)),
                ),
              )
              .toList(),
          onChanged: (v) => _cambiarDia(v),
        ),
      ),
    );
  }
}
