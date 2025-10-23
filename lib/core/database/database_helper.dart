import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Obtén el path del directorio actual del proyecto
    final directory = await getDatabasesPath();
    final path = join(directory, 'polleria.db');

    print('📁 Ruta de la base de datos: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  // 🧱 Crear las tablas (solo se ejecuta la primera vez)
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Usuario (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre_completo TEXT NOT NULL,
        correo TEXT UNIQUE NOT NULL,
        telefono TEXT,
        contrasena TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Comida (
        id_comida INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        precio REAL NOT NULL,
        tipo TEXT CHECK(tipo IN ('comida', 'complemento')) NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Pedido (
        id_pedido INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        total REAL NOT NULL,
        salsas TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
          ON DELETE CASCADE ON UPDATE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Carrito (
        id_carrito INTEGER PRIMARY KEY AUTOINCREMENT,
        id_pedido INTEGER NOT NULL,
        id_comida INTEGER NOT NULL,
        cantidad INTEGER NOT NULL,
        subtotal REAL NOT NULL,
        FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
          ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (id_comida) REFERENCES Comida(id_comida)
          ON DELETE CASCADE ON UPDATE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Reservacion (
        id_reservacion INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        hora TEXT NOT NULL,
        invitados INTEGER,
        detalle TEXT,
        FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
          ON DELETE CASCADE ON UPDATE CASCADE
      );
    ''');

    print('✅ Base de datos creada con todas las tablas correctamente.');
  }
}



