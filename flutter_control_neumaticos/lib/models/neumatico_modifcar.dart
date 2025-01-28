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
      ubicacion: json['ubicacion'],
      idMovil: json['iD_MOVIL'], // Verifica si es null
      idBodega: json['iD_BODEGA'],
      fechaIngreso: DateTime.parse(json['fechA_INGRESO']), // Parseo a DateTime
      fechaSalida: json['fechA_SALIDA'] != null
          ? DateTime.parse(json['fechA_SALIDA'])
          : null, // Verifica si es null
      estado: json['estado'],
      kmTotal: json['kM_TOTAL'],
      tipoNeumatico: json['tipO_NEUMATICO'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'ubicacion': ubicacion,
      'iD_MOVIL': idMovil,
      'iD_BODEGA': idBodega,
      'fechA_INGRESO': fechaIngreso.toIso8601String(), // Convertido a String ISO
      'fechA_SALIDA': fechaSalida?.toIso8601String(), // Convertido a String ISO
      'estado': estado,
      'kM_TOTAL': kmTotal,
      'tipO_NEUMATICO': tipoNeumatico,
    };
  }
}
