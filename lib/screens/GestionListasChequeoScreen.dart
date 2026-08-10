import 'package:flutter/material.dart';

import '../models/lista_chequeo.dart';
import '../utils/servicio_lista_chequeo.dart';
import 'EditorListaChequeoScreen.dart';
import '../theme.dart';

class GestionListasChequeoScreen extends StatefulWidget {
  const GestionListasChequeoScreen({super.key});

  @override
  State<GestionListasChequeoScreen> createState() =>
      _GestionListasChequeoScreenState();
}

class _GestionListasChequeoScreenState extends State<GestionListasChequeoScreen> {
  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;
  final Color cardColor = terrasachaCardColor;

  List<ListaChequeo> _listas = [];
  bool _cargando = true;
  String? _listaExpandidaId;

  @override
  void initState() {
    super.initState();
    _cargarListas();
  }

  Future<void> _cargarListas() async {
    setState(() => _cargando = true);
    try {
      final listas = await ServicioListaChequeo.cargarDisponibles();
      if (!mounted) return;
      setState(() {
        _listas = listas;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      _mostrarError('No se pudieron cargar las listas: $e');
    }
  }

  List<ListaChequeo> get _listasPropias =>
      _listas.where((l) => !l.esDelAdministrador).toList();

  List<ListaChequeo> get _listasAdmin =>
      _listas.where((l) => l.esDelAdministrador).toList();

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _abrirCrearLista() async {
    final resultado = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (_) => EditorListaChequeoScreen(primaryColor: primaryColor),
      ),
    );

    if (!mounted || resultado == null) return;

    if (resultado is NuevaListaChequeoDatos) {
      try {
        await ServicioListaChequeo.crear(
          nombre: resultado.nombre,
          descripcion: resultado.descripcion,
          items: resultado.items,
        );
        await _cargarListas();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lista creada correctamente'),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        _mostrarError('No se pudo crear la lista: $e');
      }
    }
  }

  Future<void> _abrirEditarLista(ListaChequeo lista) async {
    final resultado = await Navigator.push<ListaChequeo?>(
      context,
      MaterialPageRoute(
        builder: (_) => EditorListaChequeoScreen(
          primaryColor: primaryColor,
          listaInicial: lista,
        ),
      ),
    );

    if (!mounted || resultado == null) return;

    try {
      await ServicioListaChequeo.actualizar(resultado);
      await _cargarListas();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lista actualizada'),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      _mostrarError('No se pudo actualizar: $e');
    }
  }

  Future<void> _confirmarEliminar(ListaChequeo lista) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar lista'),
        content: Text(
          '¿Eliminar "${lista.nombre}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await ServicioListaChequeo.eliminar(lista.id);
      await _cargarListas();
    } catch (e) {
      _mostrarError('No se pudo eliminar: $e');
    }
  }

  IconData _iconoItem(String icono) {
    switch (icono) {
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Listas de chequeo',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _cargarListas,
            icon: Icon(Icons.refresh, color: primaryColor),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCrearLista,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nueva lista',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarListas,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 88),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Configurar checklist',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Crea listas personalizadas con los ítems que tu equipo debe verificar en campo.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSeccionTitulo('Mis listas personalizadas'),
                  const SizedBox(height: 8),
                  if (_listasPropias.isEmpty)
                    _buildMensajeVacio(
                      'Aún no tienes listas propias. Pulsa "Nueva lista" para crear una.',
                    )
                  else
                    ..._listasPropias.map(
                      (l) => _buildTarjetaLista(l, editable: true),
                    ),
                  const SizedBox(height: 24),
                  _buildSeccionTitulo('Listas del administrador'),
                  const SizedBox(height: 8),
                  if (_listasAdmin.isEmpty)
                    _buildMensajeVacio(
                      'No hay listas del administrador disponibles.',
                    )
                  else
                    ..._listasAdmin.map(
                      (l) => _buildTarjetaLista(l, editable: false),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildMensajeVacio(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        texto,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildTarjetaLista(ListaChequeo lista, {required bool editable}) {
    final expandida = _listaExpandidaId == lista.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                _listaExpandidaId = expandida ? null : lista.id;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    expandida ? Icons.expand_less : Icons.expand_more,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lista.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        if (lista.descripcion != null &&
                            lista.descripcion!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            lista.descripcion!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                lista.origen.etiqueta,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${lista.items.length} ítem(s)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (editable)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                      onSelected: (accion) {
                        if (accion == 'editar') {
                          _abrirEditarLista(lista);
                        } else if (accion == 'eliminar') {
                          _confirmarEliminar(lista);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'editar', child: Text('Editar')),
                        PopupMenuItem(
                          value: 'eliminar',
                          child: Text('Eliminar'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (expandida && lista.items.isNotEmpty)
            Column(
              children: lista.items.map((item) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(48, 8, 14, 8),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[100]!)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(_iconoItem(item.icono),
                          size: 18, color: primaryColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            if (item.descripcion.isNotEmpty)
                              Text(
                                item.descripcion,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );

  }
}
