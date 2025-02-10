using System.Net.Mail;
using System.Net;
using System.IO; // Asegúrate de incluir esta directiva

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

            var mailMessage = new MailMessage(mail, email, subject, message);
            return client.SendMailAsync(mailMessage);
        }

        public Task SendEmailWithAttachmentAsync(string email, string subject, string message, byte[] attachment, string fileName)
        {
            var mail = "prueba@pentacrom.cl";
            var pw = "pentprueba";

            var client = new SmtpClient("190.196.217.50", 25) // Puerto 25
            {
                EnableSsl = false, // Deshabilitar SSL
                Credentials = new NetworkCredential(mail, pw),
                DeliveryMethod = SmtpDeliveryMethod.Network
            };

            var mailMessage = new MailMessage(mail, email, subject, message)
            {
                IsBodyHtml = true
            };

            // Asegúrate de usar el stream correctamente para adjuntar el archivo
            using (var stream = new MemoryStream(attachment))
            {
                mailMessage.Attachments.Add(new Attachment(stream, fileName));
                return client.SendMailAsync(mailMessage);
            }
        }
        
    }
}
