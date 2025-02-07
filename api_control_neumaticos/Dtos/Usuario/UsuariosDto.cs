using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


namespace api_control_neumaticos.Dtos.Usuario
{
    public class UsuarioDto
{
    public int ID_USUARIO { get; set; }
    public string NOMBRES { get; set; } = "";
    public string APELLIDOS { get; set; } = "";
    public string CORREO { get; set; } = "";
    public string CLAVE { get; set; } = "";
    public int CODIGO_PERFIL { get; set; }
    public int COD_ESTADO { get; set; }
    public int ID_BODEGA { get; set; }  // Nueva propiedad
    public string? TOKEN { get; set; }
    public string? CONTRASEÑA_TEMPORAL { get; set; }
    public DateTime? FECHA_CLAVE { get; set; }
    public int INTENTOS_FALLIDOS { get; set; }

}

}