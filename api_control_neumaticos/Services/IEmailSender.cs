namespace SendingEmails
{
    public interface IEmailSender
    {
        Task SendEmailAsync(string email, string subject, string message);
        // email, quien recibe el email
        // subject el asunto
        // message el mensaje
        Task SendEmailWithAttachmentAsync(string email, string subject, string message, byte[] attachment, string fileName);
        // email, quien recibe el email
        // subject el asunto
        // message el mensaje
        // attachment el archivo adjunto
        // fileName el nombre del archivo adjunto
    }
}