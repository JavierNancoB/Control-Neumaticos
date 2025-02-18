using System;
using System.Collections.Generic;

namespace api_control_neumaticos.Models
{
    public partial class Movil
    {
        public int IdMovil { get; set; }
        public required string Patente { get; set; }
        public required string Marca { get; set; }
        public required string  Modelo { get; set; }
        public int Ejes { get; set; }
        public int TipoMovil { get; set; }
        
        // Nueva propiedad para la relación con Bodega
        public int? ID_BODEGA { get; set; }
        public virtual required Bodega Bodega { get; set; }

        // Nueva propiedad para CantidadNeumaticos
        public int? CantidadNeumaticos { get; set; }

        // Nueva propiedad para Estado
        public int Estado { get; set; }

        public DateTime? FechaUltimaComprobacion { get; set; }
        public ICollection<HistorialMovil> Historiales { get; set; } = new List<HistorialMovil>();
    }
}
