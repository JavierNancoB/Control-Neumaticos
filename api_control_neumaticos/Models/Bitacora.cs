using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api_control_neumaticos.Models
{
    public class Bitacora
    {
        [Key]
        public int ID { get; set; }

        public int CODIGO { get; set; }

        public int ID_OBJETO { get; set; }  // Puede ser ID de Neumático, Movil o Usuario
        
        [Required]
        [MaxLength(50)]
        public string TIPO_OBJETO { get; set; } = "Neumatico";

        [Required]
        public int ID_USUARIO { get; set; }  // Usuario que está creando la bitácora

        public DateTime FECHA { get; set; }

        [MaxLength(500)]
        public string OBSERVACION { get; set; } = "";

        public int ESTADO { get; set; }
    }
}
