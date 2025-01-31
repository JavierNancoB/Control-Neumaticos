using System.Net.Mail;
using System.Net;

namespace SendingEmails
{
    public class EmailSender : IEmailSender
    {
        public Task SendEmailAsync(string email, string subject, string message)
        {
            var mail = "prueba@pentacrom.cl";
            var pw = "pentprueba";

            var client = new SmtpClient("190.196.217.50", 25) // Puerto 25
            {
                EnableSsl = false, // Deshabilitar SSL
                Credentials = new NetworkCredential(mail, pw),
                DeliveryMethod = SmtpDeliveryMethod.Network
            };

            return client.SendMailAsync(
                new MailMessage(
                    from: mail,
                    to: email, 
                    subject, 
                    message
                )
            );
        }
    }
}
