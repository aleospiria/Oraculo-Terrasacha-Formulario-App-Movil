import 'package:flutter/material.dart';

import '../utils/roles_campo.dart';
import '../utils/servicio_plantillas.dart';

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
  final List<DateTime> fechasSubArea;
  final AsignacionPlantillaSheetDatos? datosIniciales;

  const AsignacionPlantillaSheet({
    super.key,
    required this.primaryColor,
    required this.plantillas,
    required this.responsables,
    required this.fechasSubArea,
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
    required List<DateTime> fechasSubArea,
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
        fechasSubArea: fechasSubArea,
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
    _sincronizarResponsableSeleccionado();
  }

  void _seleccionarPlantilla(PlantillaConFeatures plantilla) {
    setState(() {
      _plantillaSeleccionada = plantilla;
      _featuresSeleccionados.clear();
    });
  }

  void _toggleFeature(String featureId) {
    setState(() {
      if (_featuresSeleccionados.contains(featureId)) {
        _featuresSeleccionados.remove(featureId);
      } else {
        _featuresSeleccionados.add(featureId);
      }
    });
  }

  String _formatFecha(DateTime fecha) {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    return '$d/$m/${fecha.year}';
  }

  void _guardar() {
    final plantilla = _plantillaSeleccionada;
    final indice = _responsableIndice;
    if (plantilla == null) return;
    if (indice == null) return;
    if (_featuresSeleccionados.isEmpty) return;

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

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
                        return CheckboxListTile(
                          value: activo,
                          activeColor: widget.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          title: Text(feature.nombre),
                          subtitle: feature.featureGroup != null
                              ? Text(
                                  feature.featureGroup!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                )
                              : null,
                          onChanged: (_) => _toggleFeature(feature.id),
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
                    if (widget.fechasSubArea.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Día de trabajo (opcional)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdownFecha(),
                    ],
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
                  onPressed: _plantillaSeleccionada != null &&
                          _responsableIndice != null &&
                          _featuresSeleccionados.isNotEmpty
                      ? _guardar
                      : null,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateTime?>(
          isExpanded: true,
          value: _fechaSubArea,
          hint: const Text('Sin día específico'),
          items: [
            const DropdownMenuItem<DateTime?>(
              value: null,
              child: Text('Sin día específico'),
            ),
            ...widget.fechasSubArea.map(
              (fecha) => DropdownMenuItem<DateTime?>(
                value: fecha,
                child: Text(_formatFecha(fecha)),
              ),
            ),
          ],
          onChanged: (v) => setState(() => _fechaSubArea = v),
        ),
      ),
    );
  }
}
