using System;

namespace api_control_neumaticos.Dtos.Kilometros
{
    public class CreateKilometrosRequestDto
    {
        public int ID_MOVIL { get; set; }
        public DateTime FECHA_REGISTRO { get; set; }
        public int KILOMETRO { get; set; }
    }
}
