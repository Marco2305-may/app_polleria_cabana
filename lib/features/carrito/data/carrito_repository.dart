import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../presentation/carrito_item_ui.dart';
import 'carrito_model.dart'; // modelo para BD

class CarritoRepository {
  final dbHelper = DatabaseHelper.instance;

  // 🔹 Obtener carrito con datos de comida (JOIN)
  Future<List<CarritoItemUI>> getCarrito() async {
    final Database db = await dbHelper.database;

    final result = await db.rawQuery('''
      SELECT 
        c.id_carrito, 
        c.id_pedido, 
        c.id_comida, 
        c.cantidad, 
        c.subtotal,
        m.nombre, 
        m.imagen, 
        m.descripcion, 
        m.precio
      FROM Carrito c
      JOIN Comida m ON c.id_comida = m.id_comida
    ''');

    return result.map((map) => CarritoItemUI.fromMap(map)).toList();
  }

  // 🔹 Agregar un item al carrito
  Future<void> addItem(CarritoItem item) async {
    final db = await dbHelper.database;

    // Verificar si ya existe ese producto en el pedido actual
    final existing = await db.query(
      'Carrito',
      where: 'id_pedido = ? AND id_comida = ?',
      whereArgs: [item.idPedido, item.idComida],
    );

    if (existing.isNotEmpty) {
      final current = existing.first;
      final currentCantidad = (current['cantidad'] ?? 0);
      final currentSubtotal = (current['subtotal'] ?? 0);

      final nuevaCantidad = (currentCantidad is int
          ? currentCantidad
          : int.tryParse(currentCantidad.toString()) ?? 0) +
          item.cantidad;

      final nuevoSubtotal = (currentSubtotal is num
          ? currentSubtotal.toDouble()
          : double.tryParse(currentSubtotal.toString()) ?? 0.0) +
          item.subtotal;

      await db.update(
        'Carrito',
        {'cantidad': nuevaCantidad, 'subtotal': nuevoSubtotal},
        where: 'id_pedido = ? AND id_comida = ?',
        whereArgs: [item.idPedido, item.idComida],
      );
    } else {
      await db.insert('Carrito', item.toMap());
    }
  }



  // 🔹 Eliminar un item del carrito
  Future<void> removeItem(int idCarrito) async {
    final Database db = await dbHelper.database;
    await db.delete('Carrito', where: 'id_carrito = ?', whereArgs: [idCarrito]);
  }

  // 🔹 Vaciar el carrito
  Future<void> clearCarrito() async {
    final Database db = await dbHelper.database;
    await db.delete('Carrito');
  }

  // 🔹 Calcular total del carrito
  Future<double> getTotal() async {
    final Database db = await dbHelper.database;
    final result =
    await db.rawQuery('SELECT SUM(subtotal) as total FROM Carrito');
    return result.first['total'] != null
        ? (result.first['total'] as num).toDouble()
        : 0.0;
  }
  Future<int> confirmarPedido(int idUsuario) async {
    final db = await dbHelper.database;

    // 1️⃣ Calcular total
    final result = await db.rawQuery('SELECT SUM(subtotal) as total FROM Carrito');
    final total = (result.first['total'] ?? 0.0) as double;

    // 2️⃣ Crear pedido
    final idPedido = await db.insert('Pedido', {
      'id_usuario': idUsuario,
      'fecha': DateTime.now().toIso8601String(),
      'total': total,
      'direccion': '',       // vacío por ahora
      'metodo_pago': '',     // vacío por ahora
      'estado': 'En camino', // opcional, puedes usar 'En camino' si quieres
    });

    // 3️⃣ Actualizar los ítems del carrito temporal con el nuevo idPedido
    await db.update(
      'Carrito',
      {'id_pedido': idPedido},
      where: 'id_pedido = ?',
      whereArgs: [0], // todos los temporales
    );

    return idPedido;
  }

}

