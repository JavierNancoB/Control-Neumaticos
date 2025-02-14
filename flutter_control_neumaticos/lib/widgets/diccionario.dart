class Diccionario {
  static const Map<int, String> perfil = {
    1: "ADMINISTRADOR",
    2: "JEFE DE PLANTA",
    3: "CONDUCTOR",
  };

  static const Map<int, String> estadoUsuarios = {
    1: "HABILITADO",
    2: "DESHABILITADO",
  };

  static const Map<int, String> tipoNeumatico = {
    0: "NO SELECCIONADO",
    1: "TRACCIONAL",
    2: "DIRECCIONAL",
    3: "REPUESTO",
    4: "GUARDADO",
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

  static const Map<int, String> estadoAlerta = {
    1: "PENDIENTE",
    2: "LEÍDO",
    3: "ATENDIDO",
  };

  static const Map<int, String> ubicacionNeumaticos = {
    0: "NO SELECCIONADO",
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
    2: "DESHABILITACIÓN DE NEUMÁTICOS",
    3: "CAMBIO DE MÓVIL ASIGNADO",
    4: "ROTACIÓN NEUMÁTICO",
    5: "TRANSICIÓN A DIRECCIONAL",
    6: "TRANSICIÓN A TRACCIONAL",
    7: "CAMBIO DE FECHA DE INGRESO",
    8: "CAMBIO MANUAL DE KILOMETRAJE TOTAL",
    9: "CAMBIO AUTOMÁTICO DE KILOMETRAJE TOTAL",
    10: "CAMBIO DE PRESIÓN DE AIRE",
    11: "PINCHAZO NEUMÁTICO",
    12: "INGRESO DE USUARIO",
    13: "EDICIÓN DE NOMBRES",
    14: "EDICIÓN DE APELLIDOS",
    15: "EDICIÓN DE PERFIL",
    16: "CAMBIO DE CORREO",
    17: "CAMBIO DE CONTRASEÑA",
    18: "DESHABILITACIÓN DE USUARIOS",
    19: "INGRESO DE MÓVIL",
    20: "MODIFICACIÓN DE PATENTE DE MÓVIL",
    21: "MODIFICACIÓN DE MARCA DE MÓVIL",
    22: "MODIFICACIÓN DE MODELO DE MÓVIL",
    23: "MODIFICACIÓN DE EJES DE MÓVIL",
    24: "MODIFICACIÓN DE CÓDIGO DE MÓVIL",
    25: "MODIFICACIÓN DE CANTIDAD DE RUEDAS",
    26: "DESHABILITACIÓN DE MÓVIL",
    27:	"COMPROBACION DE NEUMATICOS EN MOVIL",
    28:	"NO SE COMPROBÓ ASIGNAMIENTO DE NEUMATICO",
    29:	"TRANSICIÓN A BODEGA",
    30:	"TRANSICIÓN A REPUESTO"
  };

  // Método para consultar los valores
  static String obtenerDescripcion(Map<int, String> diccionario, int key) {
    return diccionario[key] ?? "Desconocido";
  }
}
