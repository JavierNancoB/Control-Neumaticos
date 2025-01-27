class Alerta {
  final int id;
  final int idNeumatico;
  final String fechaIngreso;
  final String? fechaLeido;
  final String? fechaAtendido;
  final int estadoAlerta;
  final int codigoAlerta;
  final int? usuarioLeidoId;
  final int? usuarioAtendidoId;

  Alerta({
    required this.id,
    required this.idNeumatico,
    required this.fechaIngreso,
    this.fechaLeido,
    this.fechaAtendido,
    required this.estadoAlerta,
    required this.codigoAlerta,
    this.usuarioLeidoId,
    this.usuarioAtendidoId,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) {
    return Alerta(
      id: json['id'],
      idNeumatico: json['iD_NEUMATICO'],
      fechaIngreso: json['fechA_INGRESO'],
      fechaLeido: json['fechA_LEIDO'],
      fechaAtendido: json['fechA_ATENDIDO'],
      estadoAlerta: json['estadO_ALERTA'],
      codigoAlerta: json['codigO_ALERTA'],
      usuarioLeidoId: json['usuariO_LEIDO_ID'],
      usuarioAtendidoId: json['usuariO_ATENDIDO_ID'],
    );
  }
}
