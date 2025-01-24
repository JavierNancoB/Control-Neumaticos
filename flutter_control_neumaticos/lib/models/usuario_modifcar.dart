class Usuario {
  int idUsuario; // Cambio a no final
  String nombres; // Cambio a no final
  String apellidos; // Cambio a no final
  String correo; // Cambio a no final
  String clave;
  int codigoPerfil;
  int codEstado;
  int idBodega;

  Usuario({
    required this.idUsuario,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.clave,
    required this.codigoPerfil,
    required this.codEstado,
    required this.idBodega,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['iD_USUARIO'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      correo: json['correo'],
      clave: json['clave'],
      codigoPerfil: json['codigO_PERFIL'],
      codEstado: json['coD_ESTADO'],
      idBodega: json['iD_BODEGA'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'codigoPerfil': codigoPerfil,
    };
  }
}
