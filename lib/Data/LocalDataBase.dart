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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Aquí definimos las tablas, por ejemplo tabla registros
    await db.execute('''
    CREATE TABLE registros (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    especie TEXT NOT NULL,
    numArbol INTEGER NOT NULL,
    diametro REAL NOT NULL,
    altura REAL NOT NULL,
    observaciones TEXT,
    coordenadas TEXT,
    estado TEXT NOT NULL
  )
''');
  }

  Future<int> insertRegistro(Map<String, dynamic> registro) async {
    final db = await instance.database;
    return await db.insert('registros', registro);
  }

  Future<List<Map<String, dynamic>>> getRegistros() async {
    final db = await instance.database;
    return await db.query('registros');
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

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}