namespace api_control_neumaticos.Dtos.SolicitudCorreos
{
    public class SolicitudCorreosDto
    {
        public int Id { get; set; }
        public required int IdSolicitante { get; set; }
        public DateTime FechaSolicitud { get; set; } = DateTime.UtcNow;
        // public bool Estado { get; set; } = false;
        public byte Estado { get; set; } = 0;
    }
}