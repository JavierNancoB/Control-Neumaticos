using System;
using System.ComponentModel.DataAnnotations;

namespace api_control_neumaticos.Dtos.BitacoraNeumatico
{
    public class UpdateBitacoraNeumaticoRequestDto
    {
        [Required]
        public int IDNeumatico { get; set; }

        [Required]
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