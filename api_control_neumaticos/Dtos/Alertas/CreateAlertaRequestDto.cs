using System;

namespace api_control_neumaticos.Dtos.Alertas
{
    public class CreateAlertaRequestDto
    {
        public int ID_NEUMATICO { get; set; }
        public DateTime FECHA_ALERTA { get; set; }
        public int CODIGO_ALERTA { get; set; }
    }
}