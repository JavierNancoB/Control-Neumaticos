using System;

namespace api_control_neumaticos.Dtos.Kilometros
{
    public class KilometrosDto
    {
        public int ID_KILOMETRO_DIARIO { get; set; }
        public int ID_MOVIL { get; set; }
        public DateTime FECHA_REGISTRO { get; set; }
        public int KILOMETRO { get; set; }
    }
}
