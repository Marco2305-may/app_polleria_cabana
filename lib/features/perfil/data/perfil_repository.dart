import 'package:sqflite/sqflite.dart';
import 'perfil_model.dart';

class UsuarioRepository {
  final Database db;

  UsuarioRepository({required this.db});

  Future<Usuario?> obtenerUsuario(int idUsuario) async {
    try {
      final res = await db.query(
        'Usuario',
        where: 'id_usuario = ?',
        whereArgs: [idUsuario],
      );
      if (res.isNotEmpty) {
        return Usuario.fromMap(res.first);
      }
      return null;
    } catch (e) {
      print("Error al obtener usuario: $e");
      return null;
    }
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    await db.update(
      'Usuario',
      usuario.toMap(),
      where: 'id_usuario = ?',
      whereArgs: [usuario.idUsuario],
    );
  }
}


