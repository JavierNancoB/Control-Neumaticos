namespace api_control_neumaticos.Dtos.Bitacora
{
    public class CreateBitacoraRequestDto
    {
        public int CODIGO { get; set; }
        public int ID_OBJETO { get; set; }  // Puede ser ID de Neumático, Movil o Usuario
        public string TIPO_OBJETO {get; set;} = "Neumatico";

        public int ID_USUARIO { get; set; }
        public string OBSERVACION { get; set; } = "";
        public int ESTADO { get; set; }
    }
}