using System;

namespace api_control_neumaticos.Dtos.Neumaticos
{
    public class NeumaticosDto
    {
        public int ID_NEUMATICO { get; set; }
        public int CODIGO { get; set; }
        public int? UBICACION { get; set; }
        public int? ID_MOVIL { get; set; }
        public int ID_BODEGA { get; set; }
        public DateTime FECHA_INGRESO { get; set; }
        public DateTime? FECHA_SALIDA { get; set; }
        public int ESTADO { get; set; }
        public int KM_TOTAL { get; set; }
        public int TIPO_NEUMATICO { get; set; }
    }
}