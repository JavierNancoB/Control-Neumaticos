using api_control_neumaticos.Models;
using api_control_neumaticos.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MailController : ControllerBase
    {
        private readonly IEmailService _emailService;

        // Constructor donde se inyecta el servicio de correo electrónico
        public MailController(IEmailService emailService)
        {
            _emailService = emailService;
        }

        // POST: api/mail/send-email
        [HttpPost("send-email")]
        [Authorize] // Solo usuarios autenticados pueden enviar correos
        public async Task<ActionResult> SendEmail([FromBody] EmailRequest request)
        {
            // Validación de que todos los campos necesarios estén presentes
            if (string.IsNullOrEmpty(request.To) || string.IsNullOrEmpty(request.Subject) || string.IsNullOrEmpty(request.Body))
            {
                return BadRequest("Faltan datos para enviar el correo.");
            }

            try
            {
                // Llamada al servicio de correo para enviar el correo
                await _emailService.SendEmailAsync(request.To, request.Subject, request.Body);
                return Ok(new { message = "Correo enviado correctamente." });
            }
            catch (Exception ex)
            {
                // Si ocurre un error al enviar el correo, retorna el mensaje de error
                return StatusCode(500, new { message = "Error al enviar el correo.", error = ex.Message });
            }
        }
    }
}
