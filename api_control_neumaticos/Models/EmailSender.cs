using System;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Threading.Tasks;

namespace SendingEmails
{
    public class EmailSender : IEmailSender
    {
        public async Task SendEmailAsync(string email, string subject, string message)
        {
            try
            {
                var mail = "prueba@pentacrom.cl";
                var pw = "pentprueba";

                using (var client = new SmtpClient("190.196.217.50", 25))
                {
                    client.EnableSsl = false;
                    client.Credentials = new NetworkCredential(mail, pw);
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;

                    using (var mailMessage = new MailMessage(mail, email, subject, message))
                    {
                        await client.SendMailAsync(mailMessage);
                    }
                }

                Console.WriteLine("Correo enviado correctamente.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al enviar correo: {ex.Message}");
                throw;
            }
        }

        public async Task SendEmailWithAttachmentAsync(string email, string subject, string message, byte[] attachment, string fileName)
        {
            try
            {
                var mail = "prueba@pentacrom.cl";
                var pw = "pentprueba";

                using (var client = new SmtpClient("190.196.217.50", 25))
                {
                    client.EnableSsl = false;
                    client.Credentials = new NetworkCredential(mail, pw);
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;

                    using (var mailMessage = new MailMessage(mail, email, subject, message)
                    {
                        IsBodyHtml = true
                    })
                    {
                        var stream = new MemoryStream(attachment);
                        mailMessage.Attachments.Add(new Attachment(stream, fileName));

                        await client.SendMailAsync(mailMessage);
                    }
                }

                Console.WriteLine("Correo con adjunto enviado correctamente.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al enviar correo con adjunto: {ex.Message}");
                throw;
            }
        }
    }
}
