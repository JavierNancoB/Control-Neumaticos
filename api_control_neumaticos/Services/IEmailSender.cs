namespace SendingEmails
{
    public interface IEmailSender
    {
        Task SendEmailAsync(string email, string subject, string message);
        // email, quien recibe el email
        // subject el asunto
        // message el mensaje
    }
}