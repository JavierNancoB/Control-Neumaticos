class Movil {
  final String patente;
  final String marca;
  final String modelo;
  final int ejes;
  final int cantidadNeumaticos;
  final int tipoMovil;
  final int estado;
  final int bodega;

  Movil({
    required this.patente,
    required this.marca,
    required this.modelo,
    required this.ejes,
    required this.cantidadNeumaticos,
    required this.tipoMovil,
    required this.estado,
    required this.bodega,
  });

  Map<String, dynamic> toJson() {
    return {
      'PATENTE': patente,
      'MARCA': marca,
      'MODELO': modelo,
      'EJES': ejes,
      'TIPO_MOVIL': tipoMovil,
      'ID_BODEGA': bodega,
      'CANTIDAD_NEUMATICOS': cantidadNeumaticos,
      'ESTADO': estado,
    };
  }
  factory Movil.fromJson(Map<String, dynamic> json) {
    return Movil(
      patente: json['PATENTE'],
      marca: json['MARCA'],
      modelo: json['MODELO'],
      ejes: json['EJES'],
      cantidadNeumaticos: json['CANTIDAD_NEUMATICOS'],
      tipoMovil: json['TIPO_MOVIL'],
      estado: json['ESTADO'],
      bodega: json['ID_BODEGA'],
    );
  }
}
