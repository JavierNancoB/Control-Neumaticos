using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Threading.Tasks;
using api_correos.services;
using System;

namespace api_correos.controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmailSenderController : ControllerBase
    {
        private readonly EmailSender _emailSender;

        // Constructor que inicializa el controlador con una instancia de EmailSender
        public EmailSenderController(EmailSender emailSender)
        {
            _emailSender = emailSender;
            Console.WriteLine("EmailSenderController initialized");
        }

        // Método HTTP POST para enviar un correo electrónico
        [HttpPost("send")]
        public async Task<IActionResult> SendEmail([FromForm] EmailWithOptionalFileRequest emailRequest)
        {
            Console.WriteLine("Received email request");

            // Verificar si la solicitud de correo electrónico es nula
            if (emailRequest == null)
            {
                Console.WriteLine("Error: emailRequest is null");
                return BadRequest("Invalid email request.");
            }

            string? attachmentPath = null;

            try
            {
                // Si hay un archivo adjunto, guardarlo en el servidor
                if (emailRequest.Attachment != null)
                {
                    var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
                    if (!Directory.Exists(uploadsFolder))
                        Directory.CreateDirectory(uploadsFolder);

                    attachmentPath = Path.Combine(uploadsFolder, emailRequest.Attachment.FileName);

                    using (var stream = new FileStream(attachmentPath, FileMode.Create))
                    {
                        await emailRequest.Attachment.CopyToAsync(stream);
                    }
                }

                Console.WriteLine("Attempting to send email...");
                // Enviar el correo electrónico utilizando el servicio EmailSender
                await _emailSender.SendEmailAsync(
                    emailRequest.ToEmail,
                    emailRequest.Subject,
                    emailRequest.Body,
                    attachmentPath
                );

                Console.WriteLine("Email sent successfully.");
                return Ok("Email sent successfully.");
            }
            catch (Exception ex)
            {
                // Manejar cualquier excepción que ocurra durante el envío del correo
                Console.WriteLine($"Error sending email: {ex.Message}");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
            finally
            {
                // Asegurarse de que el archivo adjunto se elimine después de enviarlo
                if (attachmentPath != null && System.IO.File.Exists(attachmentPath))
                {
                    try
                    {
                        System.IO.File.Delete(attachmentPath);
                        Console.WriteLine("Attachment deleted successfully.");
                    }
                    catch (IOException ioEx)
                    {
                        // Manejar cualquier excepción que ocurra al eliminar el archivo
                        Console.WriteLine($"Could not delete attachment: {ioEx.Message}");
                    }
                }
            }
        }

        // Clase que representa la solicitud de correo electrónico con un archivo adjunto opcional
        public class EmailWithOptionalFileRequest
        {
            public required string ToEmail { get; set; } // Dirección de correo del destinatario
            public required string Subject { get; set; } // Asunto del correo
            public required string Body { get; set; } // Cuerpo del correo
            public IFormFile? Attachment { get; set; } // Archivo adjunto (opcional)
        }
    }
}
