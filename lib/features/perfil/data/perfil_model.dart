class Usuario {
  int idUsuario;
  String nombreCompleto;
  String correo;
  String? telefono;
  String contrasena;

  Usuario({
    required this.idUsuario,
    required this.nombreCompleto,
    required this.correo,
    this.telefono,
    required this.contrasena,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nombre_completo': nombreCompleto,
      'correo': correo,
      'telefono': telefono,
      'contrasena': contrasena,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['id_usuario'],
      nombreCompleto: map['nombre_completo'],
      correo: map['correo'],
      telefono: map['telefono'],
      contrasena: map['contrasena'],
    );
  }
}


