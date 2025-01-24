using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace api_control_neumaticos.Dtos.Movil
{
    public class CreateMovilRequestDto
    {
        public string PATENTE { get; set; } = "";
        public string MARCA { get; set; } = "";
        public string MODELO { get; set; } = "";
        public int EJES { get; set; }
        public int TIPO_MOVIL { get; set; }
        public int? ID_BODEGA { get; set; }
        public int? CANTIDAD_NEUMATICOS { get; set; }
        public int ESTADO { get; set; }
    }

}