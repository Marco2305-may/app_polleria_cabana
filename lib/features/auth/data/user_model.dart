// lib/features/auth/data/user_model.dart
class Usuario {
  final int? idUsuario;
  final String nombreCompleto;
  final String correo;
  final String? telefono;
  final String contrasena;

  Usuario({
    this.idUsuario,
    required this.nombreCompleto,
    required this.correo,
    this.telefono,
    required this.contrasena,
  });

  // Convertir a Map para insertar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nombre_completo': nombreCompleto,
      'correo': correo,
      'telefono': telefono,
      'contrasena': contrasena,
    };
  }

  // Crear objeto Usuario desde Map (SQLite)
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
