namespace api_control_neumaticos.Dtos.HistorialMovil
{
    public class UpdateHistorialMovilRequestDto
    {
        public int ID { get; set; }
        public int IDMovil { get; set; }
        public int IDUsuario { get; set; }
        public int CODIGO { get; set; }
        public DateTime Fecha { get; set; }
        public required string Descripcion { get; set; }
        public int Estado { get; set; }
    }
}