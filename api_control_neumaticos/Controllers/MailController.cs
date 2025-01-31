using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace SendingEmails.Controllers
{
    [Route("api/mail")]
    [ApiController]
    public class MailController : ControllerBase
    {
        private readonly IEmailSender _emailSender;

        public MailController(IEmailSender emailSender)
        {
            _emailSender = emailSender;
        }

        [HttpPost("send")]
        public async Task<IActionResult> SendEmail([FromBody] EmailRequest emailRequest)
        {
            if (string.IsNullOrEmpty(emailRequest.To) || string.IsNullOrEmpty(emailRequest.Subject) || string.IsNullOrEmpty(emailRequest.Message))
            {
                return BadRequest("Todos los campos son obligatorios.");
            }

            try
            {
                await _emailSender.SendEmailAsync(emailRequest.To, emailRequest.Subject, emailRequest.Message);
                return Ok("Correo enviado exitosamente.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al enviar el correo: {ex.Message}");
            }
        }
    }

    public class EmailRequest
    {
        public string To { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
    }
}
