using System;
using System.ComponentModel.DataAnnotations;

namespace api_control_neumaticos.Dtos.BitacoraNeumatico
{
    public class BitacoraNeumaticoDto
    {
        public int ID { get; set; }

        public int IDNeumatico { get; set; }

        public int IDUsuario { get; set; }

        [Required]
        public int CODIGO { get; set; }

        [Required]
        public DateTime FECHA { get; set; }

        [Required]
        public int ESTADO { get; set; }

        [StringLength(250)]
        public string OBSERVACION { get; set; } = "";
    }
}