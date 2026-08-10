import 'package:flutter/material.dart';

import '../models/lista_chequeo.dart';
import '../theme.dart';

class EditorListaChequeoScreen extends StatefulWidget {
  final Color primaryColor;
  final ListaChequeo? listaInicial;

  const EditorListaChequeoScreen({
    super.key,
    required this.primaryColor,
    this.listaInicial,
  });

  @override
  State<EditorListaChequeoScreen> createState() =>
      _EditorListaChequeoScreenState();
}

class _EditorListaChequeoScreenState extends State<EditorListaChequeoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _descripcionCtrl;
  final List<_ItemEditor> _items = [];

  bool get _esEdicion => widget.listaInicial != null;

  @override
  void initState() {
    super.initState();
    final inicial = widget.listaInicial;
    _nombreCtrl = TextEditingController(text: inicial?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: inicial?.descripcion ?? '');

    if (inicial != null) {
      for (final item in inicial.items) {
        _items.add(
          _ItemEditor(
            id: item.id,
            tituloCtrl: TextEditingController(text: item.titulo),
            descripcionCtrl: TextEditingController(text: item.descripcion),
            icono: item.icono,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _agregarItem() {
    setState(() {
      _items.add(
        _ItemEditor(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          tituloCtrl: TextEditingController(),
          descripcionCtrl: TextEditingController(),
        ),
      );
    });
  }

  void _eliminarItem(int index) {
    setState(() {
      _items[index].dispose();
      _items.removeAt(index);
    });
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ítem a la lista')),
      );
      return;
    }

    for (final item in _items) {
      if (item.tituloCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todos los ítems deben tener título')),
        );
        return;
      }
    }

    final items = _items
        .map(
          (i) => ItemListaChequeo(
            id: i.id,
            titulo: i.tituloCtrl.text.trim(),
            descripcion: i.descripcionCtrl.text.trim(),
            icono: i.icono,
          ),
        )
        .toList();

    final inicial = widget.listaInicial;
    if (inicial != null) {
      Navigator.pop(
        context,
        inicial.copyWith(
          nombre: _nombreCtrl.text.trim(),
          descripcion: _descripcionCtrl.text.trim(),
          items: items,
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      (
        nombre: _nombreCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim(),
        items: items,
      ),
    );
  }

  IconData _iconoDe(String clave) {
    switch (clave) {
      case 'casco':
        return Icons.safety_check_outlined;
      case 'sensor':
        return Icons.build_outlined;
      case 'gps':
        return Icons.location_on_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: terrasachaBackgroundColor,
      appBar: AppBar(
        backgroundColor: terrasachaBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: widget.primaryColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _esEdicion ? 'Editar lista de chequeo' : 'Nueva lista de chequeo',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            TextFormField(
              textCapitalization: terrasachaCapitalizacionTexto,
              inputFormatters: terrasachaFormattersTexto(),
              controller: _nombreCtrl,
              decoration: _inputDecoration('Nombre de la lista'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Ingresa un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              textCapitalization: terrasachaCapitalizacionTexto,
              inputFormatters: terrasachaFormattersTexto(),
              controller: _descripcionCtrl,
              maxLines: 2,
              decoration: _inputDecoration('Descripción (opcional)'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ítems de chequeo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton.icon(
                  onPressed: _agregarItem,
                  icon: Icon(Icons.add, color: widget.primaryColor, size: 20),
                  label: Text(
                    'Agregar ítem',
                    style: TextStyle(color: widget.primaryColor),
                  ),
                ),
              ],
            ),
            if (_items.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  'Sin ítems. Agrega requerimientos que el jefe de cuadrilla deberá verificar en preoperacional.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              )
            else
              ..._items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _iconoDe(item.icono),
                            color: widget.primaryColor,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ítem ${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _eliminarItem(index),
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            tooltip: 'Eliminar ítem',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        textCapitalization: terrasachaCapitalizacionTexto,
                        inputFormatters: terrasachaFormattersTexto(),
                        controller: item.tituloCtrl,
                        decoration: _inputDecoration('Título del ítem'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: terrasachaCapitalizacionTexto,
                        inputFormatters: terrasachaFormattersTexto(),
                        controller: item.descripcionCtrl,
                        maxLines: 2,
                        decoration: _inputDecoration('Descripción'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: item.icono,
                        decoration: _inputDecoration('Icono'),
                        items: const [
                          DropdownMenuItem(
                            value: 'check',
                            child: Text('General'),
                          ),
                          DropdownMenuItem(
                            value: 'casco',
                            child: Text('Seguridad / EPP'),
                          ),
                          DropdownMenuItem(
                            value: 'sensor',
                            child: Text('Equipo / sensor'),
                          ),
                          DropdownMenuItem(
                            value: 'gps',
                            child: Text('Ubicación / GPS'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => item.icono = v);
                        },
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: _guardar,
            child: Text(
              _esEdicion ? 'Guardar cambios' : 'Crear lista',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: widget.primaryColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

class _ItemEditor {
  final String id;
  final TextEditingController tituloCtrl;
  final TextEditingController descripcionCtrl;
  String icono;

  _ItemEditor({
    required this.id,
    required this.tituloCtrl,
    required this.descripcionCtrl,
    this.icono = 'check',
  });

  void dispose() {
    tituloCtrl.dispose();
    descripcionCtrl.dispose();
  }
}

typedef NuevaListaChequeoDatos = ({
  String nombre,
  String descripcion,
  List<ItemListaChequeo> items,
});
