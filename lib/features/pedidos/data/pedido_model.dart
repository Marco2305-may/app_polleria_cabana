class Pedido {
  final int idPedido;
  final int idUsuario;
  final double total;
  final String direccion;
  final String metodoPago;
  final String estado;

  Pedido({
    required this.idPedido,
    required this.idUsuario,
    required this.total,
    this.direccion = '',
    this.metodoPago = '',
    this.estado = 'Pendiente',
  });

  Map<String, dynamic> toMap() {
    return {
      'id_pedido': idPedido,
      'id_usuario': idUsuario,
      'total': total,
      'direccion': direccion,
      'metodo_pago': metodoPago,
      'estado': estado,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      idPedido: map['id_pedido'],
      idUsuario: map['id_usuario'],
      total: map['total'],
      direccion: map['direccion'] ?? '',
      metodoPago: map['metodo_pago'] ?? '',
      estado: map['estado'] ?? 'Pendiente',
    );
  }
}
