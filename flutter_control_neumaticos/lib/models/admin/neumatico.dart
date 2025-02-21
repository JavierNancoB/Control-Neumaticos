class Neumatico {
  final String? idNeumatico;
  final String codigo;
  final int? ubicacion;
  final int? idMovil;
  final int idBodega;
  final String fechaIngreso;
  final int estado;
  final int kmTotal;
  final int? tipoNeumatico;

  Neumatico({
    this.idNeumatico,
    required this.codigo,
    this.ubicacion,
    this.idMovil,
    required this.idBodega,
    required this.fechaIngreso,
    required this.estado,
    required this.kmTotal,
    this.tipoNeumatico,
  });

  Map<String, dynamic> toJson() => {
        "ID_NEUMATICO": idNeumatico,
        "CODIGO": codigo,
        "UBICACION": ubicacion,
        "ID_MOVIL": idMovil,
        "ID_BODEGA": idBodega,
        "FECHA_INGRESO": fechaIngreso,
        "ESTADO": estado,
        "KM_TOTAL": kmTotal,
        "TIPO_NEUMATICO": tipoNeumatico,
      };
  factory Neumatico.fromJson(Map<String, dynamic> json)
  {
    return Neumatico(
      idNeumatico: json['ID_NEUMATICO'],
      codigo: json['CODIGO'],
      ubicacion: json['UBICACION'],
      idMovil: json['ID_MOVIL'],
      idBodega: json['ID_BODEGA'],
      fechaIngreso: json['FECHA_INGRESO'],
      estado: json['ESTADO'],
      kmTotal: json['KM_TOTAL'],
      tipoNeumatico: json['TIPO_NEUMATICO'],
    );
  }
}
