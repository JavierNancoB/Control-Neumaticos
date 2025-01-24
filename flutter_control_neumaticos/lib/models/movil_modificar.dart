class Movil {
  String patente;
  String marca;
  String modelo;
  int ejes;  // Mantén esto como no nulo ya que siempre está presente
  int cantidadNeumaticos;  // Lo mismo para este campo
  int tipoMovil;  // Lo mismo para este campo

  Movil({
    required this.patente,
    required this.marca,
    required this.modelo,
    required this.ejes,
    required this.cantidadNeumaticos,
    required this.tipoMovil,
  });

  factory Movil.fromJson(Map<String, dynamic> json) {
  print("JSON recibido: $json");  // Agregar un print para depurar

  return Movil(
    patente: json['patente']?.trim() ?? '',
    marca: json['marca']?.trim() ?? '',
    modelo: json['modelo']?.trim() ?? '',
    ejes: json['ejes'] != null ? json['ejes'] as int : 0,
    cantidadNeumaticos: json['cantidaD_NEUMATICOS'] != null ? json['cantidaD_NEUMATICOS'] as int : 0,
    tipoMovil: json['tipO_MOVIL'] != null ? json['tipO_MOVIL'] as int : 0,
  );
}

}
