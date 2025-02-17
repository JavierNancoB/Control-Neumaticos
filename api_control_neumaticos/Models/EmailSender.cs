using System;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Threading.Tasks;
using DotNetEnv;

namespace SendingEmails
{
    public class EmailSender : IEmailSender
    {
        // Constructor para cargar el archivo .env
        public EmailSender()
        {
            // Carga las variables de entorno desde el archivo .env
            Env.Load();
        }

        public async Task SendEmailAsync(string email, string subject, string message)
        {
            try
            {
                // Obtener las variables de entorno del archivo .env
                
                var mail = Env.GetString("SMTP_EMAIL");
                var pw = Env.GetString("SMTP_PASSWORD");
                var smtpServer = Env.GetString("SMTP_SERVER");
                var smtpPort = int.Parse(Env.GetString("SMTP_PORT") ?? "25");
                


                // RECORDAR BORRAR ANTES DE SUBIR A GITHUB








                using (var client = new SmtpClient(smtpServer, smtpPort))
                {
                    client.EnableSsl = false;  // Cambia esto según tu servidor
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
                // Obtener las variables de entorno del archivo .env
                
                var mail = Env.GetString("SMTP_EMAIL");
                var pw = Env.GetString("SMTP_PASSWORD");
                var smtpServer = Env.GetString("SMTP_SERVER");
                var smtpPort = int.Parse(Env.GetString("SMTP_PORT") ?? "25");
                




                using (var client = new SmtpClient(smtpServer, smtpPort))
                {
                    client.EnableSsl = false;  // Cambia esto según tu servidor
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
