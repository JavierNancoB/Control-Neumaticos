using System;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace SendingEmails
{
    public class EmailSender : IEmailSender
    {
        private readonly string _smtpServer;
        private readonly int _smtpPort;
        private readonly string _smtpUser;
        private readonly string _smtpPassword;

        public EmailSender()
        {
            // Configuración para leer appsettings.json
            var configuration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory()) // Establece el directorio base
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true) // Carga el archivo JSON
                .Build();

            // Obtener valores del archivo appsettings.json
            var mailSettings = configuration.GetRequiredSection("MailSettings");

            _smtpServer = mailSettings["SmtpServer"] ?? throw new InvalidOperationException("SmtpServer is required");
            _smtpPort = int.Parse(mailSettings["SmtpPort"] ?? throw new InvalidOperationException("SmtpPort is required"));
            _smtpUser = mailSettings["SmtpUser"] ?? throw new InvalidOperationException("SmtpUser is required");
            _smtpPassword = mailSettings["SmtpPassword"] ?? throw new InvalidOperationException("SmtpPassword is required");

        }

        public async Task SendEmailAsync(string email, string subject, string message)
        {
            try
            {
                using (var client = new SmtpClient(_smtpServer, _smtpPort))
                {
                    client.EnableSsl = false; // Ajustar según tu servidor SMTP
                    client.Credentials = new NetworkCredential(_smtpUser, _smtpPassword);
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;

                    using (var mailMessage = new MailMessage(_smtpUser, email, subject, message))
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
                using (var client = new SmtpClient(_smtpServer, _smtpPort))
                {
                    client.EnableSsl = false;
                    client.Credentials = new NetworkCredential(_smtpUser, _smtpPassword);
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;

                    using (var mailMessage = new MailMessage(_smtpUser, email, subject, message)
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
