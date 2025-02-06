using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace api_control_neumaticos.Models
{
    public partial class Usuario
    {
        public int IdUsuario { get; set; }

        public string Nombres { get; set; } = "";

        public string Apellidos { get; set; } = "";

        public required string Correo { get; set; }

        public required string Clave { get; set; }

        public int CodigoPerfil { get; set; }

        public int CodEstado { get; set; }

        // Nueva propiedad
        public int ID_BODEGA { get; set; }

        [ForeignKey("ID_BODEGA")]
        public virtual Bodega Bodega { get; set; } = null!;  

        public DateTime? FechaClave { get; set; }

        public int IntentosFallidos { get; set; }

        public virtual ICollection<SolicitudCorreos> SolicitudesEnviadas { get; set; } = new List<SolicitudCorreos>();
    }
}
