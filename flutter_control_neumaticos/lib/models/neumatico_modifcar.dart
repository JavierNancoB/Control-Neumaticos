class Neumatico {
  final int id;
  final int codigo;
  final int ubicacion;
  final int? idMovil;
  final String fechaIngreso;
  final String? fechaSalida;
  final int estado;
  final int kmTotal;
  final int tipoNeumatico;
  final String? patente;

  Neumatico({
    required this.id,
    required this.codigo,
    required this.ubicacion,
    this.idMovil,
    required this.fechaIngreso,
    this.fechaSalida,
    required this.estado,
    required this.kmTotal,
    required this.tipoNeumatico,
    this.patente,
  });

  factory Neumatico.fromJson(Map<String, dynamic> json) {
    try {
      return Neumatico(
        id: json['iD_NEUMATICO'] as int,
        codigo: json['codigo'] as int,
        ubicacion: json['ubicacion'] as int,
        idMovil: json['iD_MOVIL'] as int?,
        fechaIngreso: json['fechA_INGRESO'] as String,
        fechaSalida: json['fechA_SALIDA']?.toString(),
        estado: json['estado'] as int,
        kmTotal: json['kM_TOTAL'] as int,
        tipoNeumatico: json['tipO_NEUMATICO'] as int,
      );
    } catch (e) {
      print('Error al parsear el JSON: $e');
      print('JSON recibido: $json');
      rethrow;
    }
  }
}

class Movil {
  final int idMovil;
  final String patente;

  Movil({required this.idMovil, required this.patente});

  factory Movil.fromJson(Map<String, dynamic> json) {
    return Movil(
      idMovil: json['iD_MOVIL'] as int,
      patente: json['patente'] as String,
    );
  }
}