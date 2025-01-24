class NeumaticoEstado {
  final String codigo;
  final int estado;

  NeumaticoEstado({required this.codigo, required this.estado});

  Map<String, dynamic> toJson() => {
        'CODIGO': codigo,
        'ESTADO': estado,
      };
}
