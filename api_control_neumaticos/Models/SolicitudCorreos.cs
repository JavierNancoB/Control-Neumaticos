// Modelo de SolicitudCorreos
namespace api_control_neumaticos.Models
{
    public class SolicitudCorreos
    {
        public int Id { get; set; }
        public required int IdSolicitante { get; set; }
        public required DateTime FechaSolicitud { get; set; } = DateTime.UtcNow;
        // public required bool Estado { get; set; } // Cambio de byte a bool para sqlserver
        public required byte Estado { get; set; } // Cambio de bool a byte para mariadb
        // Relación con Usuario
        public required Usuario Solicitante { get; set; }
    }
}
