import 'package:flutter/material.dart';

import '../main.dart';
import '../theme.dart';
import '../utils/roles_campo.dart';
import '../utils/servicio_plantillas.dart';
import 'EditorPlantillaScreen.dart';

/// Gestión de plantillas Amplify (Template + Feature) para líderes.
class GestionPlantillasScreen extends StatefulWidget {
  const GestionPlantillasScreen({super.key});

  @override
  State<GestionPlantillasScreen> createState() =>
      _GestionPlantillasScreenState();
}

class _GestionPlantillasScreenState extends State<GestionPlantillasScreen> {
  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;
  final Color cardColor = terrasachaCardColor;

  List<PlantillaConFeatures> _plantillas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!RolesCampo.puedeGestionarPlantillas(currentUserRole)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No tienes permiso para gestionar plantillas'),
          ),
        );
        return;
      }
      _cargar();
    });
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    try {
      final lista = await ServicioPlantillas.cargarPlantillasConFeatures()
          .timeout(
        const Duration(seconds: 20),
        onTimeout: () => <PlantillaConFeatures>[],
      );
      if (!mounted) return;
      setState(() {
        _plantillas = lista;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      _mostrarError('No se pudieron cargar las plantillas: $e');
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

  Future<void> _crearPlantilla() async {
    final datos = await _dialogoPlantilla();
    if (datos == null || !mounted) return;

    try {
      final creada = await ServicioPlantillas.crearPlantilla(
        nombre: datos.$1,
        descripcion: datos.$2,
      );
      if (!mounted) return;
      await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => EditorPlantillaScreen(plantillaId: creada.id),
        ),
      );
      await _cargar();
    } catch (e) {
      if (!mounted) return;
      _mostrarError('No se pudo crear la plantilla: $e');
    }
  }

  Future<void> _abrirEditor(PlantillaConFeatures plantilla) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditorPlantillaScreen(plantillaId: plantilla.id),
      ),
    );
    if (mounted) await _cargar();
  }

  Future<void> _eliminarPlantilla(PlantillaConFeatures plantilla) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar plantilla'),
        content: Text(
          '¿Eliminar "${plantilla.nombre}" y todos sus features?\n'
          'Esta acción no se puede deshacer.',
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

    try {
      await ServicioPlantillas.eliminarPlantilla(plantilla.id);
      await _cargar();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Plantilla eliminada'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarError('No se pudo eliminar: $e');
    }
  }

  Future<(String, String?)?> _dialogoPlantilla({
    String? nombreInicial,
    String? descripcionInicial,
  }) async {
    final nombreCtrl = TextEditingController(text: nombreInicial ?? '');
    final descCtrl = TextEditingController(text: descripcionInicial ?? '');

    return showDialog<(String, String?)>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          nombreInicial == null ? 'Nueva plantilla' : 'Editar plantilla',
        ),
        content: Column(
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
                hintText: 'Ej. Inventario forestal',
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
          ],
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
              Navigator.pop(ctx, (n, descCtrl.text.trim()));
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'Plantillas',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: primaryColor),
            onPressed: _cargando ? null : _cargar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _crearPlantilla,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Nueva plantilla'),
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _plantillas.isEmpty
              ? _buildVacio()
              : RefreshIndicator(
                  color: primaryColor,
                  onRefresh: _cargar,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                    itemCount: _plantillas.length,
                    itemBuilder: (context, index) {
                      final p = _plantillas[index];
                      return _buildTarjeta(p);
                    },
                  ),
                ),
    );
  }

  Widget _buildVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.library_books_outlined,
                size: 56, color: primaryColor.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(
              'No hay plantillas aún',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Crea una plantilla y agrégale features para usarlas en los planes de campo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _crearPlantilla,
              icon: const Icon(Icons.add),
              label: const Text('Crear plantilla'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjeta(PlantillaConFeatures plantilla) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _abrirEditor(plantilla),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.description_outlined, color: primaryColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plantilla.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    if (plantilla.descripcion != null &&
                        plantilla.descripcion!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        plantilla.descripcion!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      '${plantilla.features.length} feature'
                      '${plantilla.features.length == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                tooltip: 'Eliminar plantilla',
                onPressed: () => _eliminarPlantilla(plantilla),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
