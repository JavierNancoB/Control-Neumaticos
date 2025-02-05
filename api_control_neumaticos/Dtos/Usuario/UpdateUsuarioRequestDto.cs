using System.Text.Json.Serialization;

public class UpdateUsuarioRequestDto
{
    [JsonPropertyName("NOMBRES")]
    public string Nombres { get; set; } = "";

    [JsonPropertyName("APELLIDOS")]
    public string Apellidos { get; set; } = "";

    [JsonPropertyName("CORREO")]
    public string Correo { get; set; } = "";

    [JsonPropertyName("CLAVE")]
    public string Clave { get; set; } = "";

    [JsonPropertyName("CODIGO_PERFIL")]
    public int CodigoPerfil { get; set; }

    [JsonPropertyName("COD_ESTADO")]
    public int CodEstado { get; set; }

    [JsonPropertyName("ID_BODEGA")]
    public int ID_BODEGA { get; set; }  // Nueva propiedad

    [JsonPropertyName("FECHA_CLAVE")]
    public required DateTime FechaClave { get; set; }

    [JsonPropertyName("INTENTOS_FALLIDOS")]
    public int IntentosFallidos { get; set; }


}

