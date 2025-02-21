class Neumatico {
  String codigo;
  int ubicacion;
  int? idMovil;
  int idBodega;
  DateTime fechaIngreso; // Cambiado a DateTime
  DateTime? fechaSalida; // Nullable y también tipo DateTime
  int estado;
  int kmTotal;
  int tipoNeumatico;

  Neumatico({
    required this.codigo,
    required this.ubicacion,
    this.idMovil,
    required this.idBodega,
    required this.fechaIngreso,
    this.fechaSalida,
    required this.estado,
    required this.kmTotal,
    required this.tipoNeumatico,
  });

  factory Neumatico.fromJson(Map<String, dynamic> json) {
    return Neumatico(
      codigo: json['codigo'].toString(),
      ubicacion: 0, // Valor por defecto o puedes asignar otro valor adecuado
      idMovil: json['iD_MOVIL'],
      idBodega: json['iD_BODEGA'],
      fechaIngreso: DateTime.parse(json['fechA_INGRESO']),
      fechaSalida: json['fechA_SALIDA'] != null ? DateTime.parse(json['fechA_SALIDA']) : null,
      estado: json['estado'],
      kmTotal: json['kM_TOTAL'], // Asegúrate de que esto se recibe correctamente
      tipoNeumatico: json['tipO_NEUMATICO'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'ubicacion': ubicacion,
      'iD_MOVIL': idMovil,
      'iD_BODEGA': idBodega,
      'fechA_INGRESO': fechaIngreso.toIso8601String(),
      'fechA_SALIDA': fechaSalida?.toIso8601String(),
      'estado': estado,
      'kM_TOTAL': kmTotal,
      'tipO_NEUMATICO': tipoNeumatico,
    };
  }
}