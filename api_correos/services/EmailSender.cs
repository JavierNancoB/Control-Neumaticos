using Microsoft.Extensions.Options;
using System;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace api_correos.services
{
    public class EmailSender
    {
        // Configuración de correo electrónico
        private readonly EmailSettings _emailSettings;

        // Constructor que inicializa la configuración de correo electrónico
        public EmailSender(IOptions<EmailSettings> emailSettings)
        {
            _emailSettings = emailSettings.Value;
            Console.WriteLine("EmailSender inicializado con configuración SMTP");
            Console.WriteLine($"Servidor SMTP: {_emailSettings.SmtpServer}");
            Console.WriteLine($"Puerto: {_emailSettings.Port}");
            Console.WriteLine($"Correo del remitente: {_emailSettings.SenderEmail}");
        }

        // Método asincrónico para enviar un correo electrónico
        public async Task SendEmailAsync(string toEmail, string subject, string body, string? attachmentPath = null)
        {
            Console.WriteLine("Iniciando SendEmailAsync...");
            Console.WriteLine($"Para: {toEmail}");
            Console.WriteLine($"Asunto: {subject}");
            Console.WriteLine($"Cuerpo: {body}");
            Console.WriteLine($"Ruta del adjunto: {attachmentPath}");

            try
            {
                // Crear el mensaje de correo
                var mailMessage = new MailMessage
                {
                    From = new MailAddress(_emailSettings.SenderEmail),
                    Subject = subject,
                    Body = body,
                    IsBodyHtml = true // Indica que el cuerpo del correo es HTML
                };

                // Agregar destinatario
                mailMessage.To.Add(toEmail);

                Attachment? attachment = null;

                // Si hay una ruta de adjunto, intentar agregar el archivo adjunto
                if (!string.IsNullOrEmpty(attachmentPath))
                {
                    try
                    {
                        Console.WriteLine("Intentando adjuntar archivo...");
                        attachment = new Attachment(attachmentPath);
                        mailMessage.Attachments.Add(attachment);
                        Console.WriteLine("Archivo adjunto agregado exitosamente.");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error al adjuntar archivo: {ex.Message}");
                    }
                }

                // Configurar el cliente SMTP
                using (var smtpClient = new SmtpClient(_emailSettings.SmtpServer, _emailSettings.Port))
                {
                    smtpClient.Credentials = new NetworkCredential(_emailSettings.SenderEmail, _emailSettings.SenderPassword);
                    smtpClient.EnableSsl = false;  // Deshabilitamos SSL
                    Console.WriteLine("Enviando correo...");
                    await smtpClient.SendMailAsync(mailMessage); // Enviar el correo
                    Console.WriteLine("Correo enviado exitosamente!");
                }

                // Eliminar el archivo después de enviar el correo
                if (attachment != null)
                {
                    attachment.Dispose(); // Liberar el archivo antes de eliminarlo
                    File.Delete(attachmentPath);
                    Console.WriteLine($"Archivo {attachmentPath} ha sido eliminado.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Excepción en SendEmailAsync: {ex.Message}");
                Console.WriteLine($"StackTrace: {ex.StackTrace}");
                throw; // Relanzar la excepción
            }
        }
    }
}
