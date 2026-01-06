import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();

  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('capturador.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    // Tabla 1: Proyectos
    await db.execute('''
      CREATE TABLE proyectos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        proyecto_id TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL
      )
    ''');

    // Tabla 2: Predios
    await db.execute('''
      CREATE TABLE predios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        predio_id TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        poligono_geojson TEXT,
        proyecto_id TEXT NOT NULL,
        proyecto_local_id INTEGER NOT NULL,
        FOREIGN KEY (proyecto_local_id) REFERENCES proyectos(id) ON DELETE CASCADE
      )
    ''');

    // Tabla 3: Parcelas
    await db.execute('''
      CREATE TABLE parcelas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parcela_id TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        especie TEXT NOT NULL,
        poligono_geojson TEXT,
        predio_id TEXT NOT NULL,
        predio_local_id INTEGER NOT NULL,
        FOREIGN KEY (predio_local_id) REFERENCES predios(id) ON DELETE CASCADE
      )
    ''');

    // Tabla 4: Registros (actualizada con relación a Parcelas)
    await db.execute('''
      CREATE TABLE registros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        registro_id TEXT,
        parcela_id TEXT NOT NULL,
        parcela_local_id INTEGER NOT NULL,
        numArbol INTEGER NOT NULL,
        diametro REAL NOT NULL,
        altura REAL NOT NULL,
        observaciones TEXT,
        coordenadas TEXT,
        estado TEXT NOT NULL DEFAULT 'pendiente',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (parcela_local_id) REFERENCES parcelas(id) ON DELETE CASCADE
      )
    ''');
  }

  // Manejo de actualizaciones de versión de base de datos
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Si actualizas desde version 1 a 2, crea las nuevas tablas
      await db.execute('''
        CREATE TABLE IF NOT EXISTS proyectos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          proyecto_id TEXT NOT NULL UNIQUE,
          nombre TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS predios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          predio_id TEXT NOT NULL UNIQUE,
          nombre TEXT NOT NULL,
          poligono_geojson TEXT,
          proyecto_id TEXT NOT NULL,
          proyecto_local_id INTEGER NOT NULL,
          FOREIGN KEY (proyecto_local_id) REFERENCES proyectos(id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS parcelas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          parcela_id TEXT NOT NULL UNIQUE,
          nombre TEXT NOT NULL,
          poligono_geojson TEXT,
          predio_id TEXT NOT NULL,
          predio_local_id INTEGER NOT NULL,
          FOREIGN KEY (predio_local_id) REFERENCES predios(id) ON DELETE CASCADE
        )
      ''');

      // Actualizar tabla registros para añadir campos nuevos
      // Nota: SQLite no permite ALTER TABLE para añadir FOREIGN KEY,
      // así que si ya tienes datos, necesitarías migración manual
    }
  }

  // ========== MÉTODOS PARA PROYECTOS ==========

  Future<int> insertProyecto(Map<String, dynamic> proyecto) async {
    final db = await instance.database;
    return await db.insert('proyectos', proyecto);
  }

  Future<List<Map<String, dynamic>>> getProyectos() async {
    final db = await instance.database;
    return await db.query('proyectos');
  }

  Future<Map<String, dynamic>?> getProyectoById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'proyectos',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // ========== MÉTODOS PARA PREDIOS ==========

  Future<int> insertPredio(Map<String, dynamic> predio) async {
    final db = await instance.database;
    return await db.insert('predios', predio);
  }

  Future<List<Map<String, dynamic>>> getPrediosByProyecto(int proyectoLocalId) async {
    final db = await instance.database;
    return await db.query(
      'predios',
      where: 'proyecto_local_id = ?',
      whereArgs: [proyectoLocalId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllPredios() async {
    final db = await instance.database;
    return await db.query('predios');
  }

  // ========== MÉTODOS PARA PARCELAS ==========

  Future<int> insertParcela(Map<String, dynamic> parcela) async {
    final db = await instance.database;
    return await db.insert('parcelas', parcela);
  }

  Future<List<Map<String, dynamic>>> getParcelasByPredio(int predioLocalId) async {
    final db = await instance.database;
    return await db.query(
      'parcelas',
      where: 'predio_local_id = ?',
      whereArgs: [predioLocalId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllParcelas() async {
    final db = await instance.database;
    return await db.query('parcelas');
  }

  Future<Map<String, dynamic>?> getParcelaById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'parcelas',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // ========== MÉTODOS PARA REGISTROS ==========

  Future<int> insertRegistro(Map<String, dynamic> registro) async {
    final db = await instance.database;
    return await db.insert('registros', registro);
  }

  Future<List<Map<String, dynamic>>> getRegistros() async {
    final db = await instance.database;
    return await db.query('registros');
  }

  Future<List<Map<String, dynamic>>> getRegistrosByParcela(int parcelaLocalId) async {
    final db = await instance.database;
    return await db.query(
      'registros',
      where: 'parcela_local_id = ?',
      whereArgs: [parcelaLocalId],
    );
  }

  Future<List<Map<String, dynamic>>> getRegistrosPendientes() async {
    final db = await instance.database;
    return await db.query(
      'registros',
      where: 'estado = ?',
      whereArgs: ['pendiente'],
    );
  }

  Future<int> updateRegistro(int id, Map<String, dynamic> registro) async {
    final db = await instance.database;
    return await db.update(
      'registros',
      registro,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteRegistro(int id) async {
    final db = await instance.database;
    return await db.delete(
      'registros',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== MÉTODOS ÚTILES ==========

  // Obtener registros con información completa (JOIN)
  Future<List<Map<String, dynamic>>> getRegistrosConContexto() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT 
        r.*,
        pa.nombre as parcela_nombre,
        pr.nombre as predio_nombre,
        py.nombre as proyecto_nombre
      FROM registros r
      INNER JOIN parcelas pa ON r.parcela_local_id = pa.id
      INNER JOIN predios pr ON pa.predio_local_id = pr.id
      INNER JOIN proyectos py ON pr.proyecto_local_id = py.id
      ORDER BY r.created_at DESC
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}