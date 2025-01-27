using System;

namespace api_control_neumaticos.Dtos.Alertas
{
    public class AlertaDto
    {
        public int Id { get; set; }
        public int ID_NEUMATICO { get; set; }
        public DateTime FECHA_INGRESO { get; set; }
        public DateTime? FECHA_LEIDO { get; set; }
        public DateTime? FECHA_ATENDIDO { get; set; }
        public int ESTADO_ALERTA { get; set; }
        public int CODIGO_ALERTA { get; set; }
        public int? USUARIO_LEIDO_ID { get; set; }
        public int? USUARIO_ATENDIDO_ID { get; set; }
    }
}
