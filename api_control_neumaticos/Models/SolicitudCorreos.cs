// Modelo de SolicitudCorreos
namespace api_control_neumaticos.Models
{
    public class SolicitudCorreos
    {
        public int Id { get; set; }
        public required int IdSolicitante { get; set; }
        public required DateTime FechaSolicitud { get; set; } = DateTime.UtcNow;
        public required bool Estado { get; set; }

        // Relación con Usuario
        public required Usuario Solicitante { get; set; }
    }
}
