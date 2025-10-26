class Reservacion {
  final int? id;
  final int idUsuario;
  final String fecha;
  final String hora;
  final int invitados;
  final String detalle;

  Reservacion({
    this.id,
    required this.idUsuario,
    required this.fecha,
    required this.hora,
    required this.invitados,
    required this.detalle,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_reservacion': id,
      'id_usuario': idUsuario,
      'fecha': fecha,
      'hora': hora,
      'invitados': invitados,
      'detalle': detalle,
    };
  }

  factory Reservacion.fromMap(Map<String, dynamic> map) {
    return Reservacion(
      id: map['id_reservacion'],
      idUsuario: map['id_usuario'],
      fecha: map['fecha'],
      hora: map['hora'],
      invitados: map['invitados'],
      detalle: map['detalle'],
    );
  }
}
