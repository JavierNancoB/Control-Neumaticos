class UsuarioEstado {
  final String correo;
  final int estado;

  UsuarioEstado({required this.correo, required this.estado});

  Map<String, dynamic> toJson() => {
        'CORREO': correo,
        'ESTADO': estado,
      };
}
