import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import 'pedido_model.dart';
import '../../carrito/data/carrito_model.dart';

class PedidoRepository {
  final dbHelper = DatabaseHelper.instance;

  // Crear pedido desde carrito
  Future<int> crearPedido(int idUsuario, double total) async {
    final db = await dbHelper.database;
    final idPedido = await db.insert('Pedido', {
      'id_usuario': idUsuario,
      'total': total,
      'estado': 'Pendiente',
      'direccion': '',
      'metodo_pago': '',
    });

    return idPedido;
  }

  // Actualizar pedido con dirección y método de pago
  Future<void> actualizarPedido(int idPedido, String direccion, String metodoPago) async {
    final db = await dbHelper.database;
    await db.update(
      'Pedido',
      {
        'direccion': direccion,
        'metodo_pago': metodoPago,
        'estado': 'En camino',
      },
      where: 'id_pedido = ?',
      whereArgs: [idPedido],
    );
  }

  // Obtener pedidos de un usuario
  Future<List<Pedido>> getPedidosByUsuario(int idUsuario) async {
    final db = await dbHelper.database;
    final result = await db.query('Pedido', where: 'id_usuario = ?', whereArgs: [idUsuario]);
    return result.map((map) => Pedido.fromMap(map)).toList();
  }

  // Opcional: cancelar pedido
  Future<void> cancelarPedido(int idPedido) async {
    final db = await dbHelper.database;
    await db.update(
      'Pedido',
      {'estado': 'Cancelado'},
      where: 'id_pedido = ?',
      whereArgs: [idPedido],
    );
  }
}
