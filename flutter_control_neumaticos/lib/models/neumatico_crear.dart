class NeumaticoCrear {
 String codigo;
 DateTime fechaIngreso;
 int estado;
 int kilometrajeTotal;
 int tipo;
 int ubicacion;
 String patente;

  NeumaticoCrear({
    required this.codigo,
    required this.fechaIngreso,
    required this.estado,
    required this.kilometrajeTotal,
    required this.tipo,
    required this.ubicacion,
    required this.patente,
  });

  Map<String, dynamic> toJson() {
    return {
      'CODIGO': this.codigo,
      'UBICACION': this.ubicacion,
      'ID_MOVIL': this.patente.isEmpty ? null : this.patente,  // Si patente está vacía, ID_MOVIL será null
      'ID_BODEGA': 1,  // Según tu lógica, la bodega siempre es 1
      'FECHA_INGRESO': this.fechaIngreso.toIso8601String(),
      'ESTADO': this.estado,
      'KM_TOTAL': this.kilometrajeTotal,
      'TIPO_NEUMATICO': this.tipo,
    };
  }
}
