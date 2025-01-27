// models/usuario.dart
class Usuario {
  final int id;
  final String nombres;
  final String apellidos;

  Usuario({
    required this.id,
    required this.nombres,
    required this.apellidos,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['iD_USUARIO'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
    );
  }
}
