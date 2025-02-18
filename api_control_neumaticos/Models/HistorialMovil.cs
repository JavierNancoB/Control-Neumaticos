using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api_control_neumaticos.Models
{
    public class HistorialMovil
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }

        [ForeignKey("Movil")]
        public int IDMovil { get; set; }
        public required Movil Movil { get; set; }

        [Required]
        public int CODIGO { get; set; }

        [ForeignKey("Usuario")]
        public int IDUsuario { get; set; }
        public required Usuario Usuario { get; set; }

        [Required]
        public DateTime FECHA { get; set; }

        [Required]
        public int ESTADO { get; set; }

        [StringLength(250)]
        public string OBSERVACION { get; set; } = "";
    }
}