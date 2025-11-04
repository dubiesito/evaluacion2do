import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tarea.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'evaluacion2do.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tareas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        prioridad TEXT NOT NULL,
        fecha_vencimiento TEXT NOT NULL,
        completada INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // CREATE - Insertar tarea
  Future<int> insertTarea(Tarea tarea) async {
    Database db = await database;
    return await db.insert('tareas', tarea.toMap());
  }

  // READ - Obtener todas las tareas
  Future<List<Tarea>> getTareas() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tareas',
      orderBy: 'prioridad DESC, fecha_vencimiento ASC',
    );
    return List.generate(maps.length, (i) {
      return Tarea.fromMap(maps[i]);
    });
  }

  // UPDATE - Actualizar tarea
  Future<int> updateTarea(Tarea tarea) async {
    Database db = await database;
    return await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  // DELETE - Eliminar tarea
  Future<int> deleteTarea(int id) async {
    Database db = await database;
    return await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}