// lib/features/auth/data/auth_repository.dart
import '../../../core/database/database_helper.dart';
import 'user_model.dart';

class AuthRepository {
  final dbHelper = DatabaseHelper.instance;

  // Registrar usuario
  Future<bool> registerUser(Usuario user) async {
    final db = await dbHelper.database;
    int id = await db.insert('Usuario', user.toMap());
    return id > 0; // true si se insertó correctamente, false si hubo error
  }

  // Login: retorna Usuario si correo y contraseña son correctos
  Future<Usuario?> login(String correo, String contrasena) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'Usuario',
      where: 'correo = ? AND contrasena = ?',
      whereArgs: [correo, contrasena],
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Verificar si el correo ya está registrado
  Future<bool> isEmailTaken(String correo) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'Usuario',
      where: 'correo = ?',
      whereArgs: [correo],
    );
    return result.isNotEmpty;
  }
}
