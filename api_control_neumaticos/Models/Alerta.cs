using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api_control_neumaticos.Models
{
    public class Alerta
{
    [Key]
    public int Id { get; set; }

    [ForeignKey("Neumatico")]
    public int ID_NEUMATICO { get; set; }

    [Required]
    public DateTime FECHA_INGRESO { get; set; }

    public DateTime? FECHA_LEIDO { get; set; }
    public DateTime? FECHA_ATENDIDO { get; set; }

    public int ESTADO_ALERTA { get; set; }
    public int CODIGO_ALERTA { get; set; }

    // Propiedades de navegación
    public virtual Usuario? UsuarioLeido { get; set; } // Relación con el usuario que leyó la alerta
    public virtual Usuario? UsuarioAtendido { get; set; } // Relación con el usuario que atendió la alerta

    [ForeignKey("UsuarioLeido")]
    public int? USUARIO_LEIDO_ID { get; set; }  // Este es el campo de la clave foránea

    [ForeignKey("UsuarioAtendido")]
    public int? USUARIO_ATENDIDO_ID { get; set; }  // Este es el campo de la clave foránea

    public virtual required Neumatico Neumatico { get; set; }  // Relación con el neumático
}

}
