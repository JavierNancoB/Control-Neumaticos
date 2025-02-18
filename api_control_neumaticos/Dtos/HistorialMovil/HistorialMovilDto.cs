namespace api_control_neumaticos.Dtos.HistorialMovil
{
    public class HistorialMovilDto
    {
        public int ID { get; set; }
        public int IDMovil { get; set; }
        public int IDUsuario { get; set; }
        public int CODIGO { get; set; }
        public DateTime FECHA { get; set; }
        public int ESTADO { get; set; }
        public required string OBSERVACION { get; set; }
    }
    
}