class CarritoItem {
  final int? idCarrito;
  final int idPedido;
  final int idComida;
  final int cantidad;
  final double subtotal;

  CarritoItem({
    this.idCarrito,
    required this.idPedido,
    required this.idComida,
    required this.cantidad,
    required this.subtotal,
  });

  factory CarritoItem.fromMap(Map<String, dynamic> map) {
    return CarritoItem(
      idCarrito: map['id_carrito'],
      idPedido: map['id_pedido'],
      idComida: map['id_comida'],
      cantidad: map['cantidad'],
      subtotal: map['subtotal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_pedido': idPedido,
      'id_comida': idComida,
      'cantidad': cantidad,
      'subtotal': subtotal,
    };
  }
}


