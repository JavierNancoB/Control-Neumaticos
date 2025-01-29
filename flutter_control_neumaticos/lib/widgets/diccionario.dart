class Diccionario {
  static const Map<int, String> perfil = {
    1: "ADMINISTRADOR",
    2: "JEFE DE PLANTA",
    3: "CONDUCTOR",
    4: "ESTADO USUARIOS",
  };

  static const Map<int, String> estadoUsuarios = {
    1: "HABILITADO",
    2: "DESHABILITADO",
  };

  static const Map<int, String> tipoNeumatico = {
    1: "Neumático de Tracción",
    2: "Neumático de Dirección",
  };

  static const Map<int, String> tipoMovil = {
    1: "4X2",
    2: "6X4",
    3: "RAMPLA",
  };

  static const Map<int, String> estadoNeumaticos = {
    1: "HABILITADO",
    2: "DESHABILITADO",
  };

  static const Map<int, String> estadoMovil = {
    1: "HABILITADO",
    2: "DESHABILITADO",
  };

  static const Map<int, String> codigoAlerta = {
    1: "MÁS DE 2 VULCANIZACIONES",
    2: "MÁS DE 100.000 KM",
    3: "DESHABILITAR POR DESGASTE",
  };

  static const Map<int, String> ubicacionNeumaticos = {
    1: "BODEGA",
    2: "DIRECCIONAL IZQUIERDA",
    3: "DIRECCIONAL DERECHO",
    4: "PRIMER TRACCIONAL IZQUIERDO INTERNO",
    5: "PRIMER TRACCIONAL IZQUIERDO EXTERNO",
    6: "PRIMER TRACCIONAL DERECHO INTERNO",
    7: "PRIMER TRACCIONAL DERECHO EXTERNO",
    8: "SEGUNDO TRACCIONAL IZQUIERDO INTERNO",
    9: "SEGUNDO TRACCIONAL IZQUIERDO EXTERNO",
    10: "SEGUNDO TRACCIONAL DERECHO INTERNO",
    11: "SEGUNDO TRACCIONAL DERECHO EXTERNO",
    12: "TERCER TRACCIONAL IZQUIERDO INTERNO",
    13: "TERCER TRACCIONAL IZQUIERDO EXTERNO",
    14: "TERCER TRACCIONAL DERECHO INTERNO",
    15: "TERCER TRACCIONAL DERECHO EXTERNO",
    16: "REPUESTO",
  };

  static const Map<int, String> bitacora = {
    1: "INGRESO DE NEUMÁTICOS",
    2: "CAMBIO UBICACIÓN",
    3: "CAMBIO DE MOVIL ASIGNADO",
    4: "DESHABILITAR NEUMATICOS",
    5: "PINCHAZO",
    6: "ROTACIÓN",
    7: "INSTALACIÓN",
    8: "PRESION DE AIRE",
    9: "INGRESO USUARIO",
    10: "EDICIÓN DE NOMBRE",
    11: "EDICIÓN DE APELLIDO",
    12: "EDICION DE PERFIL",
    13: "CAMBIO DE ESTADO",
    14: "CAMBIO DE CORREO",
    15: "CAMBIO DE CONTRASEÑA",
    16: "DESHABILITAR DE USUARIOS",
    17: "INGRESO DE MOVIL",
    18: "MODIFICACION PATENTE MOVIL",
    19: "MODIFICACION MARCA MOVIL",
    20: "MODIFICACION MODELO MOVIL",
    21: "MODIFICACION EJES MOVIL",
    22: "MODIFICACION CODIGO MOVIL",
    23: "DESHABILITAR DE MOVIL",
  };

  // Método para consultar los valores
  static String obtenerDescripcion(Map<int, String> diccionario, int key) {
    return diccionario[key] ?? "Desconocido";
  }
}
