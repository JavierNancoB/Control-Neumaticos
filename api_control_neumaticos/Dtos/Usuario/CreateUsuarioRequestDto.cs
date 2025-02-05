using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace api_control_neumaticos.Dtos.Usuario
{
    public class CreateUsuarioRequestDto
    {
        public string NOMBRES { get; set; } = "";
        public string APELLIDOS { get; set; } = "";
        public string CORREO { get; set; } = "";
        public string CLAVE { get; set; } = "";
        public int CODIGO_PERFIL { get; set; }
        public int COD_ESTADO { get; set; }
        public int ID_BODEGA { get; set; }  // Nueva propiedad
        public DateTime FECHA_CLAVE { get; set; }
        public int INTENTOS_FALLIDOS { get; set; }

        public CreateUsuarioRequestDto()
        {
            FECHA_CLAVE = DateTime.Now;
            INTENTOS_FALLIDOS = 0;
        }
    }
}