class Alerta {
  final int id; // Identificador único de la alerta
  final int idNeumatico; // Identificador del neumático asociado a la alerta
  final String fechaIngreso; // Fecha en la que se ingresó la alerta
  final String? fechaLeido; // Fecha en la que se leyó la alerta (puede ser nulo)
  final String? fechaAtendido; // Fecha en la que se atendió la alerta (puede ser nulo)
  final int estadoAlerta; // Estado actual de la alerta
  final int codigoAlerta; // Código específico de la alerta
  final int? usuarioLeidoId; // Identificador del usuario que leyó la alerta (puede ser nulo)
  final int? usuarioAtendidoId; // Identificador del usuario que atendió la alerta (puede ser nulo)

  // Constructor de la clase Alerta
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

  // Método de fábrica para crear una instancia de Alerta a partir de un JSON
  factory Alerta.fromJson(Map<String, dynamic> json) {
    return Alerta(
      id: json['id'], // Asigna el valor del JSON al campo id
      idNeumatico: json['iD_NEUMATICO'], // Asigna el valor del JSON al campo idNeumatico
      fechaIngreso: json['fechA_INGRESO'], // Asigna el valor del JSON al campo fechaIngreso
      fechaLeido: json['fechA_LEIDO'], // Asigna el valor del JSON al campo fechaLeido (puede ser nulo)
      fechaAtendido: json['fechA_ATENDIDO'], // Asigna el valor del JSON al campo fechaAtendido (puede ser nulo)
      estadoAlerta: json['estadO_ALERTA'], // Asigna el valor del JSON al campo estadoAlerta
      codigoAlerta: json['codigO_ALERTA'], // Asigna el valor del JSON al campo codigoAlerta
      usuarioLeidoId: json['usuariO_LEIDO_ID'], // Asigna el valor del JSON al campo usuarioLeidoId (puede ser nulo)
      usuarioAtendidoId: json['usuariO_ATENDIDO_ID'], // Asigna el valor del JSON al campo usuarioAtendidoId (puede ser nulo)
    );
  }
}
