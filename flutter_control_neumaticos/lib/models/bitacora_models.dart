class Bitacora {
  final int id;
  final int idNeumatico;
  final int idUsuario;
  final int codigo;
  final String fecha;
  final String observacion;
  final int estado;

  Bitacora({
    required this.id,
    required this.idNeumatico,
    required this.idUsuario,
    required this.codigo,
    required this.fecha,
    required this.observacion,
    required this.estado,
  });

  factory Bitacora.fromJson(Map<String, dynamic> json) {
    return Bitacora(
      id: json['id'],
      idNeumatico: json['idNeumatico'],
      idUsuario: json['idUsuario'],
      codigo: json['codigo'],
      fecha: json['fecha'],
      observacion: json['observacion'],
      estado: json['estado'],
    );
  }
}
