using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api_control_neumaticos.Models
{
    public class Alerta
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("Neumatico")]
        public int ID_NEUMATICO { get; set; }

        [Required]
        public DateTime FECHA_ALERTA { get; set; }

        public int CODIGO_ALERTA { get; set; }

        public virtual required Neumatico Neumatico { get; set; }
    }
}