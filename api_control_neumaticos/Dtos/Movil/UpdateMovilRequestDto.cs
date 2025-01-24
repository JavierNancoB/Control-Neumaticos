using System.Text.Json.Serialization;

namespace api_control_neumaticos.Dtos.Movil
{
    public class UpdateMovilRequestDto
    {
        [JsonPropertyName("ID_MOVIL")]
        public int IdMovil { get; set; }
        [JsonPropertyName("PATENTE")]
        public string Patente { get; set; } = "";
        [JsonPropertyName("MARCA")]
        public string Marca { get; set; } = "";
        [JsonPropertyName("MODELO")]
        public string Modelo { get; set; } = "";
        [JsonPropertyName("EJES")]
        public int Ejes { get; set; }
        [JsonPropertyName("TIPO_MOVIL")]
        public int TipoMovil { get; set; }
        [JsonPropertyName("ID_BODEGA")]
        public int? ID_BODEGA { get; set; }
        [JsonPropertyName("CANTIDAD_NEUMATICOS")]
        public int? CantidadNeumaticos { get; set; }
        [JsonPropertyName("ESTADO")]
        public int Estado { get; set; }
    }
}
