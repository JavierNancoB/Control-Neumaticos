namespace api_control_neumaticos.Models
{
    public class EmailRequest
    {
        public required string To { get; set; }
        public string Subject { get; set; } = "Sin asunto";
        public string Body { get; set; } = "";
    }
}
