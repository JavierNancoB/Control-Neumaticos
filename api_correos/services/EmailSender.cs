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
        private readonly EmailSettings _emailSettings;

        public EmailSender(IOptions<EmailSettings> emailSettings)
        {
            _emailSettings = emailSettings.Value;
            Console.WriteLine("EmailSender initialized with SMTP settings");
            Console.WriteLine($"SMTP Server: {_emailSettings.SmtpServer}");
            Console.WriteLine($"Port: {_emailSettings.Port}");
            Console.WriteLine($"Sender Email: {_emailSettings.SenderEmail}");
        }

        public async Task SendEmailAsync(string toEmail, string subject, string body, string? attachmentPath = null)
        {
            Console.WriteLine("Starting SendEmailAsync...");
            Console.WriteLine($"To: {toEmail}");
            Console.WriteLine($"Subject: {subject}");
            Console.WriteLine($"Body: {body}");
            Console.WriteLine($"Attachment Path: {attachmentPath}");

            try
            {
                var mailMessage = new MailMessage
                {
                    From = new MailAddress(_emailSettings.SenderEmail),
                    Subject = subject,
                    Body = body,
                    IsBodyHtml = true
                };

                mailMessage.To.Add(toEmail);

                Attachment? attachment = null;

                if (!string.IsNullOrEmpty(attachmentPath))
                {
                    try
                    {
                        Console.WriteLine("Attempting to attach file...");
                        attachment = new Attachment(attachmentPath);
                        mailMessage.Attachments.Add(attachment);
                        Console.WriteLine("Attachment added successfully.");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error attaching file: {ex.Message}");
                    }
                }

                using (var smtpClient = new SmtpClient(_emailSettings.SmtpServer, _emailSettings.Port))
                {
                    smtpClient.Credentials = new NetworkCredential(_emailSettings.SenderEmail, _emailSettings.SenderPassword);
                    smtpClient.EnableSsl = false;  // Deshabilitamos SSL
                    Console.WriteLine("Sending email...");
                    await smtpClient.SendMailAsync(mailMessage); // línea 62
                    Console.WriteLine("Email sent successfully!");
                }

                // Eliminar el archivo después de enviar el correo
                if (attachment != null)
                {
                    attachment.Dispose(); // Liberamos el archivo antes de eliminarlo
                    File.Delete(attachmentPath);
                    Console.WriteLine($"File {attachmentPath} has been deleted.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception in SendEmailAsync: {ex.Message}");
                Console.WriteLine($"StackTrace: {ex.StackTrace}");
                throw;
            }
        }
    }
}
