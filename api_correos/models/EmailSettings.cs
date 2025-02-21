// Clase que representa la configuración del correo electrónico
public class EmailSettings
{
    // Dirección del servidor SMTP
    public string SmtpServer { get; set; } = string.Empty;

    // Puerto utilizado para la conexión SMTP
    public int Port { get; set; }

    // Correo electrónico del remitente
    public string SenderEmail { get; set; } = string.Empty;

    // Contraseña del correo electrónico del remitente
    public string SenderPassword { get; set; } = string.Empty;
}
