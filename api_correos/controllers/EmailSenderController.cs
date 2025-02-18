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

        public EmailSenderController(EmailSender emailSender)
        {
            _emailSender = emailSender;
            Console.WriteLine("EmailSenderController initialized");
        }

        [HttpPost("send")]
public async Task<IActionResult> SendEmail([FromForm] EmailWithOptionalFileRequest emailRequest)
{
    Console.WriteLine("Received email request");

    if (emailRequest == null)
    {
        Console.WriteLine("Error: emailRequest is null");
        return BadRequest("Invalid email request.");
    }

    string? attachmentPath = null;

    try
    {
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
        Console.WriteLine($"Error sending email: {ex.Message}");
        return StatusCode(500, $"Internal server error: {ex.Message}");
    }
    finally
    {
        // 🔥 Asegurar que el archivo se elimine solo si no está en uso
        if (attachmentPath != null && System.IO.File.Exists(attachmentPath))
        {
            try
            {
                System.IO.File.Delete(attachmentPath);
                Console.WriteLine("Attachment deleted successfully.");
            }
            catch (IOException ioEx)
            {
                Console.WriteLine($"Could not delete attachment: {ioEx.Message}");
            }
        }
    }
}


    public class EmailWithOptionalFileRequest
    {
        public required string ToEmail { get; set; }
        public required string Subject { get; set; }
        public required string Body { get; set; }
        public IFormFile? Attachment { get; set; } // Ahora es opcional
    }
}
}
