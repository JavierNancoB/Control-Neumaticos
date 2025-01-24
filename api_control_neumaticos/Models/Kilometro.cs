using System;
using System.ComponentModel.DataAnnotations;

namespace api_control_neumaticos.Models
{
    public class Kilometros
    {
        [Key]
        public int ID_KILOMETRO_DIARIO { get; set; }
        
        public int ID_MOVIL { get; set; }
        public required Movil Movil { get; set; }

        public DateTime FECHA_REGISTRO { get; set; }

        public int KILOMETRO { get; set; }
    }
}
