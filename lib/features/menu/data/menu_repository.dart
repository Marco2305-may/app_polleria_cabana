import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import 'comida_model.dart';

class MenuRepository {
  final dbHelper = DatabaseHelper.instance;

  /// Obtiene todas las comidas
  Future<List<Comida>> getComidas() async {
    try {
      final Database db = await dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('Comida');

      // Asignar imagen si está vacía
      return result.map((map) {
        if (map['imagen'] == null || (map['imagen'] as String).isEmpty) {
          map['imagen'] = _imagenPorNombre(map['nombre']);
        }
        return Comida.fromMap(map);
      }).toList();
    } catch (e) {
      print('Error al obtener comidas: $e');
      return [];
    }
  }

  /// Inserta una nueva comida o actualiza si ya existe
  Future<void> insertarComida(Comida comida) async {
    try {
      final Database db = await dbHelper.database;
      await db.insert(
        'Comida',
        comida.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al insertar comida: $e');
    }
  }

  /// Elimina una comida por su id
  Future<void> eliminarComida(int id) async {
    try {
      final Database db = await dbHelper.database;
      await db.delete('Comida', where: 'id_comida = ?', whereArgs: [id]);
    } catch (e) {
      print('Error al eliminar comida: $e');
    }
  }

  /// Función para asignar automáticamente imagen según el nombre de la comida
  String _imagenPorNombre(String nombre) {
    switch (nombre.toLowerCase()) {
      case 'pollo a la brasa':
        return 'assets/images/pollo_brasa.png';
      case '1/2 pollo a la brasa':
        return 'assets/images/medio_pollo.png';
      case '1/4 pollo a la brasa':
        return 'assets/images/cuarto_pollo.png';
      case 'broaster familiar':
        return 'assets/images/broaster.png';
      case 'alitas bbq':
        return 'assets/images/alitas_bbq.png';
      case 'gaseosa inca kola 1l':
        return 'assets/images/inka_kola.png';
      case 'porción de papas adicionales':
        return 'assets/images/papas_extra.png';
      case 'porción de arroz chaufa':
        return 'assets/images/arroz_chaufa.png';
      default:
        return 'assets/images/default_food.jpg';
    }
  }
}

