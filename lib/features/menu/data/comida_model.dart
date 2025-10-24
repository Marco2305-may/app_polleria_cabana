class Comida {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String tipo;
  final String imagen;

  Comida({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.tipo,
    required this.imagen,
  });

  factory Comida.fromMap(Map<String, dynamic> map) {
    return Comida(
      id: map['id_comida'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precio: map['precio'],
      tipo: map['tipo'],
      imagen: map['imagen'] ?? '',
    );
  }

  /// Este método convierte el objeto en un Map para usar en la BD
  Map<String, dynamic> toMap() {
    return {
      'id_comida': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'tipo': tipo,
      'imagen': imagen,
    };
  }
}

