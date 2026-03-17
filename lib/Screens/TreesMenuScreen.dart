import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class TreesMenuScreen extends StatefulWidget {
  const TreesMenuScreen({super.key});

  @override
  State<TreesMenuScreen> createState() => _TreesMenuScreenState();
}

class _TreesMenuScreenState extends State<TreesMenuScreen> {
  List<Map<String, dynamic>> items = [];
  bool cargando = true;
  late String proyectoId;
  late String proyectoNombre;
  bool _isInitialized = false;

  // Paginación
  final int _limit = 100;
  String? _nextToken;
  String? _prevToken;
  final List<String?> _tokenHistory = [null]; // historial de tokens por página
  int _paginaActual = 0;

  // Buscador
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      proyectoId = args['proyecto_id'];
      proyectoNombre = args['proyecto_nombre'];
      _isInitialized = true;
      _cargarDatosDeLaNube();
    }
  }

  Future<void> _cargarDatosDeLaNube({String? token}) async {
    setState(() => cargando = true);

    const query = r'''
      query ListTrees($filter: ModelTreeFilterInput, $limit: Int, $nextToken: String) {
        listTrees(filter: $filter, limit: $limit, nextToken: $nextToken) {
          items {
            id
            name
            status
            projectTreesId
            createdAt
          }
          nextToken
        }
      }
    ''';

    try {
      final variables = {
        'filter': {
          'projectTreesId': {'eq': proyectoId}
        },
        'limit': _limit,
        if (token != null) 'nextToken': token,
      };

      final request = GraphQLRequest<String>(
        document: query,
        variables: variables,
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final list = jsonData['listTrees']['items'] as List<dynamic>;
        final newNextToken = jsonData['listTrees']['nextToken'] as String?;

        setState(() {
          items = List<Map<String, dynamic>>.from(list);
          _nextToken = newNextToken;
          cargando = false;
        });
      }
    } catch (e) {
      safePrint('Error cargando Trees: $e');
      setState(() => cargando = false);
    }
  }

  void _irSiguientePagina() {
    if (_nextToken == null) return;
    _tokenHistory.add(_nextToken);
    _paginaActual++;
    _cargarDatosDeLaNube(token: _nextToken);
  }

  void _irPaginaAnterior() {
    if (_paginaActual == 0) return;
    _paginaActual--;
    _tokenHistory.removeLast();
    final tokenAnterior = _tokenHistory.last;
    _cargarDatosDeLaNube(token: tokenAnterior);
  }

  Future<void> _crearItem(String nombre) async {
    const mutation = r'''
      mutation CreateTree($input: CreateTreeInput!) {
        createTree(input: $input) {
          id
          name
          status
          projectTreesId
          createdAt
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'name': nombre,
            'status': 'Pendiente',
            'projectTreesId': proyectoId,
          }
        },
      );
      await Amplify.API.mutate(request: request).response;
      // Volvemos a la primera página para ver el nuevo árbol
      _paginaActual = 0;
      _tokenHistory
        ..clear()
        ..add(null);
      _cargarDatosDeLaNube();
    } catch (e) {
      safePrint('Error creando Tree: $e');
    }
  }

  List<Map<String, dynamic>> get _itemsFiltrados {
    if (_searchQuery.isEmpty) return items;
    return items
        .where((item) =>
        (item['name'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = _itemsFiltrados;

    return Scaffold(
      appBar: AppBar(title: Text('Trees: $proyectoNombre')),
      body: Column(
        children: [
          // Botón nuevo Tree
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Tree'),
              onPressed: () => _mostrarDialogoNuevo(context),
            ),
          ),

          // Buscador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar Tree por nombre...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // Indicador de página
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Página ${_paginaActual + 1}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  '${filtrados.length} resultados',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          // Lista
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : filtrados.isEmpty
                ? const Center(child: Text('No se encontraron Trees'))
                : ListView.builder(
              itemCount: filtrados.length,
              itemBuilder: (context, index) {
                final item = filtrados[index];
                return ListTile(
                  leading: const Icon(Icons.park),
                  title: Text(item['name']),
                  subtitle: Text(
                    'Estado: ${item['status'] ?? 'Sin estado'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/captura',
                        arguments: {
                          'tree_id': item['id'],
                          'tree_name': item['name'],
                        });
                  },
                );
              },
            ),
          ),

          // Controles de paginación
          if (!cargando)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Anterior'),
                    onPressed: _paginaActual > 0 ? _irPaginaAnterior : null,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Siguiente'),
                    onPressed: _nextToken != null ? _irSiguientePagina : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoNuevo(BuildContext context) async {
    final controller = TextEditingController();
    final nombre = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nombre del Tree'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Guardar')),
        ],
      ),
    );
    if (nombre != null && nombre.isNotEmpty) _crearItem(nombre);
  }
}