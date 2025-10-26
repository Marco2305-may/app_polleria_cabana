import 'package:polleria_la_cabana_app/features/reservaciones/data/reservasion_model.dart';
import 'package:sqflite/sqflite.dart';


class ReservacionRepository {
  final Database db;

  ReservacionRepository({required this.db});

  Future<int> crearReservacion(Reservacion r) async {
    return await db.insert('Reservacion', r.toMap());
  }

  Future<List<Reservacion>> obtenerReservaciones(int idUsuario) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'Reservacion',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );

    return List.generate(maps.length, (i) {
      return Reservacion.fromMap(maps[i]);
    });
  }

  Future<int> eliminarReservacion(int idReservacion) async {
    return await db.delete(
      'Reservacion',
      where: 'id_reservacion = ?',
      whereArgs: [idReservacion],
    );
  }

  Future<int> actualizarReservacion(Reservacion r) async {
    return await db.update(
      'Reservacion',
      r.toMap(),
      where: 'id_reservacion = ?',
      whereArgs: [r.id],
    );
  }
}
