namespace api_control_neumaticos.Dtos.SolicitudCorreos
{
    public class SolicitudCorreosDto
    {
        public int Id { get; set; }
        public int IdSolicitante { get; set; }
        public DateTime FechaSolicitud { get; set; }
        public bool Estado { get; set; }
    }
}