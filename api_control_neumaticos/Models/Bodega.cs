using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api_control_neumaticos.Models
{
    public class Bodega
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID_BODEGA { get; set; }
        
        [Required]
        [StringLength(100)]
        public string NOMBRE_BODEGA { get; set; }= "";
    }
}
