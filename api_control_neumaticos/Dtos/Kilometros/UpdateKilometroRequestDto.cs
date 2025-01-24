using System.Text.Json.Serialization;

namespace api_control_neumaticos.Dtos.Kilometros
{
    public class UpdateKilometrosRequestDto
    {
        [JsonPropertyName("ID_KILOMETRO_DIARIO")]
        public int IdKilometroDiario { get; set; }
        [JsonPropertyName("ID_MOVIL")]
        public int IdMovil { get; set; }
        [JsonPropertyName("FECHA_REGISTRO")]
        public DateTime FechaRegistro { get; set; }
        [JsonPropertyName("KILOMETRO")]
        public int Kilometro { get; set; }
    }
}
