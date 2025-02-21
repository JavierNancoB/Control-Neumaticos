class Usuario {
  final String nombres;
  final String apellidos;
  final String correo;
  final String clave;
  final int perfil;
  final int estado;
  final int bodega;

  Usuario({
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.clave,
    required this.perfil,
    required this.estado,
    required this.bodega,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'clave': clave,
      'codigO_PERFIL': perfil,
      'coD_ESTADO': estado,
      'iD_BODEGA': bodega,
    };
  }
}
