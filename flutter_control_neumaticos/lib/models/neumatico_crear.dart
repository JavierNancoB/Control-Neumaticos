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
      'CODIGO': codigo,
      'UBICACION': ubicacion,
      'ID_MOVIL': patente.isEmpty ? null : patente,  // Si patente está vacía, ID_MOVIL será null
      'ID_BODEGA': 1,  // Según tu lógica, la bodega siempre es 1
      'FECHA_INGRESO': fechaIngreso.toIso8601String(),
      'ESTADO': estado,
      'KM_TOTAL': kilometrajeTotal,
      'TIPO_NEUMATICO': tipo,
    };
  }
}
