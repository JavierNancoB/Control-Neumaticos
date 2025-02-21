class Bitacora {
  final int id; // Identificador único de la bitácora
  final int idNeumatico; // Identificador del neumático asociado
  final int idUsuario; // Identificador del usuario que realizó la acción
  final int codigo; // Código de la bitácora
  final String fecha; // Fecha de la bitácora
  final String observacion; // Observaciones de la bitácora
  final int estado; // Estado de la bitácora

  // Constructor de la clase Bitacora
  Bitacora({
    required this.id, // Parámetro requerido: id
    required this.idNeumatico, // Parámetro requerido: idNeumatico
    required this.idUsuario, // Parámetro requerido: idUsuario
    required this.codigo, // Parámetro requerido: codigo
    required this.fecha, // Parámetro requerido: fecha
    required this.observacion, // Parámetro requerido: observacion
    required this.estado, // Parámetro requerido: estado
  });

  // Fábrica para crear una instancia de Bitacora a partir de un JSON
  factory Bitacora.fromJson(Map<String, dynamic> json) {
    return Bitacora(
      id: json['id'], // Asigna el campo 'id' del JSON al atributo 'id' de la clase Bitacora
      idNeumatico: json['idNeumatico'], // Asigna el campo 'idNeumatico' del JSON al atributo 'idNeumatico' de la clase Bitacora
      idUsuario: json['idUsuario'], // Asigna el campo 'idUsuario' del JSON al atributo 'idUsuario' de la clase Bitacora
      codigo: json['codigo'], // Asigna el campo 'codigo' del JSON al atributo 'codigo' de la clase Bitacora
      fecha: json['fecha'], // Asigna el campo 'fecha' del JSON al atributo 'fecha' de la clase Bitacora
      observacion: json['observacion'], // Asigna el campo 'observacion' del JSON al atributo 'observacion' de la clase Bitacora
      estado: json['estado'], // Asigna el campo 'estado' del JSON al atributo 'estado' de la clase Bitacora
    );
  }
}
