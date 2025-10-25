class CarritoItemUI {
  final int idCarrito;
  final int idComida;
  final int cantidad;
  final double subtotal;
  final String nombre;
  final String imagen;
  final double precio;
  final String descripcion;

  CarritoItemUI({
    required this.idCarrito,
    required this.idComida,
    required this.cantidad,
    required this.subtotal,
    required this.nombre,
    required this.imagen,
    required this.precio,
    required this.descripcion,
  });

  factory CarritoItemUI.fromMap(Map<String, dynamic> map) {
    return CarritoItemUI(
      idCarrito: map['id_carrito'],
      idComida: map['id_comida'],
      cantidad: map['cantidad'],
      subtotal: map['subtotal'],
      nombre: map['nombre'] ?? '',
      imagen: map['imagen'] ?? '',
      precio: map['precio'] ?? 0.0,
      descripcion: map['descripcion'] ?? '',
    );
  }
}

