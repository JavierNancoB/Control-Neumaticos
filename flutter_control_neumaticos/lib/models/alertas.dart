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
      idNeumatico: json['iD_NEUMATICO'],  // Cambié la clave para que coincida
      fechaIngreso: json['fechA_INGRESO'], // Cambié la clave para que coincida
      fechaLeido: json['fechA_LEIDO'], // Puede ser nulo
      fechaAtendido: json['fechA_ATENDIDO'], // Puede ser nulo
      estadoAlerta: json['estadO_ALERTA'], // Cambié la clave para que coincida
      codigoAlerta: json['codigO_ALERTA'], // Cambié la clave para que coincida
      usuarioLeidoId: json['usuariO_LEIDO_ID'], // Puede ser nulo
      usuarioAtendidoId: json['usuariO_ATENDIDO_ID'], // Puede ser nulo
    );
  }
}
