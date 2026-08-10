import 'package:flutter/material.dart';

import '../main.dart';
import '../theme.dart';
import '../utils/roles_campo.dart';
import '../utils/servicio_plantillas.dart';

/// Edita una plantilla: nombre, descripción y CRUD de features.
class EditorPlantillaScreen extends StatefulWidget {
  final String plantillaId;

  const EditorPlantillaScreen({super.key, required this.plantillaId});

  @override
  State<EditorPlantillaScreen> createState() => _EditorPlantillaScreenState();
}

class _EditorPlantillaScreenState extends State<EditorPlantillaScreen> {
  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;
  final Color cardColor = terrasachaCardColor;

  PlantillaConFeatures? _plantilla;
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!RolesCampo.puedeGestionarPlantillas(currentUserRole)) {
        Navigator.pop(context);
        return;
      }
      _cargar();
    });
  }

  Future<void> _cargar() async {
    if (!mounted) return;
    setState(() => _cargando = true);
    try {
      final p = await ServicioPlantillas.obtenerPlantilla(widget.plantillaId)
          .timeout(
        const Duration(seconds: 20),
        onTimeout: () => null,
      );
      if (!mounted) return;
      if (p == null) {
        setState(() => _cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo cargar la plantilla. Revisa la conexión e intenta de nuevo.',
            ),
          ),
        );
        Navigator.pop(context);
        return;
      }
      setState(() {
        _plantilla = p;
        _cargando = false;
        _guardando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _guardando = false;
      });
      _mostrarError('Error al cargar: $e');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _editarDatosPlantilla() async {
    final p = _plantilla;
    if (p == null) return;

    final nombreCtrl = TextEditingController(text: p.nombre);
    final descCtrl = TextEditingController(text: p.descripcion ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar plantilla'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              textCapitalization: terrasachaCapitalizacionTexto,
              inputFormatters: terrasachaFormattersTexto(),
              controller: nombreCtrl,
              autofocus: true,
              style: terrasachaInputTextStyle,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              textCapitalization: terrasachaCapitalizacionTexto,
              inputFormatters: terrasachaFormattersTexto(),
              controller: descCtrl,
              style: terrasachaInputTextStyle,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx, true);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    setState(() => _guardando = true);
    try {
      final actualizada = await ServicioPlantillas.actualizarPlantilla(
        plantillaId: p.id,
        nombre: nombreCtrl.text,
        descripcion: descCtrl.text,
      );
      if (!mounted) return;
      setState(() {
        _plantilla = actualizada;
        _guardando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      _mostrarError('No se pudo guardar: $e');
    }
  }

  Future<void> _agregarFeature() async {
    final datos = await _dialogoFeature();
    if (datos == null || !mounted) return;

    setState(() => _guardando = true);
    try {
      await ServicioPlantillas.crearFeatureEnPlantilla(
        plantillaId: widget.plantillaId,
        nombre: datos.nombre,
        descripcion: datos.descripcion,
        featureType: datos.featureType,
        featureGroup: datos.featureGroup,
        requiereValorNumerico: datos.requiereValorNumerico,
      );
      await _cargar();
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      _mostrarError('No se pudo crear el feature: $e');
    }
  }

  Future<void> _editarFeature(FeaturePlantillaResumen feature) async {
    final datos = await _dialogoFeature(
      nombre: feature.nombre,
      descripcion: feature.description,
      featureType: feature.featureType,
      featureGroup: feature.featureGroup,
      requiereValorNumerico: feature.requiereValorNumerico,
    );
    if (datos == null || !mounted) return;

    setState(() => _guardando = true);
    try {
      await ServicioPlantillas.actualizarFeature(
        featureId: feature.id,
        nombre: datos.nombre,
        descripcion: datos.descripcion,
        featureType: datos.featureType,
        featureGroup: datos.featureGroup,
        requiereValorNumerico: datos.requiereValorNumerico,
      );
      await _cargar();
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      _mostrarError('No se pudo actualizar: $e');
    }
  }

  Future<void> _eliminarFeature(FeaturePlantillaResumen feature) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar feature'),
        content: Text(
          '¿Eliminar "${feature.nombre}" de esta plantilla?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _guardando = true);
    try {
      await ServicioPlantillas.eliminarFeatureDePlantilla(
        plantillaId: widget.plantillaId,
        featureId: feature.id,
        templateFeatureId: feature.templateFeatureId,
      );
      await _cargar();
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      _mostrarError('No se pudo eliminar: $e');
    }
  }

  Future<_DatosFeature?> _dialogoFeature({
    String? nombre,
    String? descripcion,
    String? featureType,
    String? featureGroup,
    bool requiereValorNumerico = true,
  }) async {
    final nombreCtrl = TextEditingController(text: nombre ?? '');
    final descCtrl = TextEditingController(text: descripcion ?? '');
    final grupoCtrl = TextEditingController(text: featureGroup ?? '');
    var tipo = featureType ?? 'variable';
    var pideNumero = requiereValorNumerico;

    return showDialog<_DatosFeature>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(nombre == null ? 'Nuevo feature' : 'Editar feature'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  textCapitalization: terrasachaCapitalizacionTexto,
                  inputFormatters: terrasachaFormattersTexto(),
                  controller: nombreCtrl,
                  autofocus: true,
                  style: terrasachaInputTextStyle,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ej. DAP, Altura, Especie',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  textCapitalization: terrasachaCapitalizacionTexto,
                  inputFormatters: terrasachaFormattersTexto(),
                  controller: descCtrl,
                  style: terrasachaInputTextStyle,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: tipo,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: const [
                    DropdownMenuItem(
                      value: 'variable',
                      child: Text('Variable'),
                    ),
                    DropdownMenuItem(
                      value: 'constant',
                      child: Text('Constante'),
                    ),
                    DropdownMenuItem(
                      value: 'KPI',
                      child: Text('KPI'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setLocal(() => tipo = v);
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Requiere valor numérico'),
                  subtitle: Text(
                    pideNumero
                        ? 'En campo se pedirá un número exacto'
                        : 'En campo bastará la observación',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  value: pideNumero,
                  activeColor: primaryColor,
                  onChanged: (v) => setLocal(() => pideNumero = v),
                ),
                const SizedBox(height: 8),
                TextField(
                  textCapitalization: terrasachaCapitalizacionTexto,
                  inputFormatters: terrasachaFormattersTexto(),
                  controller: grupoCtrl,
                  style: terrasachaInputTextStyle,
                  decoration: const InputDecoration(
                    labelText: 'Grupo (opcional)',
                    hintText: 'Ej. dendrometría',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final n = nombreCtrl.text.trim();
                if (n.isEmpty) return;
                Navigator.pop(
                  ctx,
                  _DatosFeature(
                    nombre: n,
                    descripcion: descCtrl.text.trim(),
                    featureType: tipo,
                    featureGroup: grupoCtrl.text.trim(),
                    requiereValorNumerico: pideNumero,
                  ),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _plantilla;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          p?.nombre ?? 'Plantilla',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (p != null)
            IconButton(
              icon: Icon(Icons.edit_outlined, color: primaryColor),
              tooltip: 'Editar plantilla',
              onPressed: _guardando ? null : _editarDatosPlantilla,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _guardando || _cargando ? null : _agregarFeature,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo feature'),
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : p == null
              ? const SizedBox.shrink()
              : Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      children: [
                        if (p.descripcion != null &&
                            p.descripcion!.isNotEmpty) ...[
                          Text(
                            p.descripcion!,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 16),
                        ],
                        Row(
                          children: [
                            Text(
                              'Features',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${p.features.length}',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (p.features.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Text(
                              'Esta plantilla aún no tiene features.\n'
                              'Agrega variables de medición (DAP, altura, etc.).',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        else
                          ...p.features.map(_buildFeatureTile),
                      ],
                    ),
                    if (_guardando)
                      const Positioned.fill(
                        child: ColoredBox(
                          color: Color(0x66FFFFFF),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _buildFeatureTile(FeaturePlantillaResumen feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: cardColor,
          child: Icon(Icons.science_outlined, color: primaryColor, size: 20),
        ),
        title: Text(
          feature.nombre,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          [
            if (feature.featureType != null) feature.featureType!,
            feature.requiereValorNumerico ? 'numérico' : 'texto/obs',
            if (feature.featureGroup != null && feature.featureGroup!.isNotEmpty)
              feature.featureGroup!,
            if (feature.description != null && feature.description!.isNotEmpty)
              feature.description!,
          ].join(' · '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: primaryColor),
              onPressed: () => _editarFeature(feature),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: () => _eliminarFeature(feature),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatosFeature {
  final String nombre;
  final String descripcion;
  final String featureType;
  final String featureGroup;
  final bool requiereValorNumerico;

  const _DatosFeature({
    required this.nombre,
    required this.descripcion,
    required this.featureType,
    required this.featureGroup,
    required this.requiereValorNumerico,
  });
}
