import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:async'; // Para el Timer

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
  final List<String?> _tokenHistory = [null];
  int _paginaActual = 0;

  // Buscador
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce; // Para no saturar la API al escribir

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

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

  // ✅ CARGA DESDE LA NUBE CON FILTRO DE BÚSQUEDA
  Future<void> _cargarDatosDeLaNube({String? token}) async {
    if (!mounted) return;
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
      // Construimos el filtro dinámico
      final Map<String, dynamic> filter = {
        'projectTreesId': {'eq': proyectoId}
      };

      // Si hay algo escrito en el buscador, lo agregamos al filtro de la nube
      if (_searchController.text.isNotEmpty) {
        filter['name'] = {'contains': _searchController.text};
      }

      final variables = {
        'filter': filter,
        'limit': _searchController.text.isNotEmpty ? 3000 : _limit,
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

        if (mounted) {
          setState(() {
            items = List<Map<String, dynamic>>.from(list);
            _nextToken = newNextToken;
            cargando = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error cargando Trees: $e');
      if (mounted) setState(() => cargando = false);
    }
  }

  // Lógica de búsqueda con retraso (Debounce) para no matar la base de datos
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Reiniciamos paginación al buscar
      _paginaActual = 0;
      _tokenHistory..clear()..add(null);
      _cargarDatosDeLaNube();
    });
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

      // Limpiar búsqueda y volver a pág 1 para ver el nuevo
      _searchController.clear();
      _paginaActual = 0;
      _tokenHistory..clear()..add(null);
      _cargarDatosDeLaNube();
    } catch (e) {
      debugPrint('Error creando Tree: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trees: $proyectoNombre')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Tree'),
              onPressed: () => _mostrarDialogoNuevo(context),
            ),
          ),

          // 🔍 BUSCADOR QUE SÍ FUNCIONA EN EL BACKEND
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar en todos los registros...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Página ${_paginaActual + 1}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                if (_searchController.text.isNotEmpty)
                  const Text('Filtrando en la nube...', style: TextStyle(fontSize: 12, color: Colors.blue)),
              ],
            ),
          ),

          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                ? const Center(child: Text('No se encontraron resultados'))
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: const Icon(Icons.park),
                  title: Text(item['name']),
                  subtitle: Text('Estado: ${item['status'] ?? 'N/A'}'),
                  onTap: () {
                    Navigator.pushNamed(context, '/captura', arguments: {
                      'tree_id': item['id'],
                      'tree_name': item['name'],
                    });
                  },
                );
              },
            ),
          ),

          // Paginación
          if (!cargando)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _paginaActual > 0 ? _irPaginaAnterior : null,
                    child: const Text('Anterior'),
                  ),
                  ElevatedButton(
                    onPressed: _nextToken != null ? _irSiguientePagina : null,
                    child: const Text('Siguiente'),
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
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Guardar')),
        ],
      ),
    );
    if (nombre != null && nombre.isNotEmpty) _crearItem(nombre);
  }
}