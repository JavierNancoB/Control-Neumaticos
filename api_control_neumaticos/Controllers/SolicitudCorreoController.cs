using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using api_control_neumaticos.Dtos.SolicitudCorreos;
using api_control_neumaticos.Models;
using SendingEmails;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SolicitudCorreosController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IEmailSender _emailSender;

        public SolicitudCorreosController(ControlNeumaticosContext context, IEmailSender emailSender)
        {
            _context = context;
            _emailSender = emailSender;
        }

        [HttpPost]
        public async Task<IActionResult> CreateSolicitud([FromBody] CreateSolicitudCorreosRequestDto request)
        {
            if (string.IsNullOrEmpty(request.CorreoSolicitante))
            {
            return BadRequest("El correo del solicitante es obligatorio.");
            }

            // Obtener al solicitante por su correo
            var solicitante = await _context.Usuarios
            .FirstOrDefaultAsync(u => u.Correo == request.CorreoSolicitante);

            if (solicitante == null)
            {
            return BadRequest("Solicitante no encontrado.");
            }

            // Comprobamos si usuario no esta deshabilitado, codigo estado = 2
            if (solicitante.CodEstado == 2)
            {
            return BadRequest("Usuario deshabilitado, no puede solicitar reestablecimiento de contraseña.");
            }

            // Verificar el número de solicitudes en las últimas 24 horas
            var solicitudesUltimas24Horas = await _context.SolicitudesCorreos
            .Where(s => s.IdSolicitante == solicitante.IdUsuario && s.FechaSolicitud > DateTime.UtcNow.AddHours(-24))
            .CountAsync();

            if (solicitudesUltimas24Horas >= 3)
            {
            return BadRequest("Se ha alcanzado el máximo de solicitudes enviadas el día de hoy.");
            }

            // Obtener la última solicitud del solicitante usando el correo
            var ultimaSolicitud = await _context.SolicitudesCorreos
            .Where(s => s.IdSolicitante == solicitante.IdUsuario)
            .OrderByDescending(s => s.FechaSolicitud)
            .FirstOrDefaultAsync();

            if (ultimaSolicitud != null)
            {
            var tiempoRestante = (ultimaSolicitud.FechaSolicitud.AddMinutes(2) - DateTime.UtcNow).TotalSeconds;

            if (tiempoRestante > 0)
            {
                return BadRequest($"Debes esperar {Math.Ceiling(tiempoRestante)} segundos antes de hacer otra solicitud.");
            }
            }

            // Si pasó más de 2 minutos, crear nueva solicitud
            var nuevaSolicitud = new SolicitudCorreos
            {
            IdSolicitante = solicitante.IdUsuario,
            FechaSolicitud = DateTime.UtcNow,
            Estado = 1, // Puedes cambiarlo si el estado inicial debe ser diferente
            Solicitante = solicitante // Asignamos el solicitante correctamente
            };

            _context.SolicitudesCorreos.Add(nuevaSolicitud);
            await _context.SaveChangesAsync();

            // Enviar correo al administrador
            await EnviarCorreoSolicitud("javier.nanco@pentacrom.cl","Nueva Solicitud de Reestablecimiento de Contraseña", $"Don(a) {solicitante.Nombres} {solicitante.Apellidos} ha solicitado reestablecer su contraseña en la aplicación de gestión neumáticos.");

            // Enviar respuesta al solicitante
            await _emailSender.SendEmailAsync(solicitante.Correo, "Solicitud de Reestablecimiento de Contraseña", "Tu solicitud ha sido enviada con éxito, en caso de ser aprobada, recibirás un correo con las instrucciones necesarias.\n\nEn caso de no haber solicitado este cambio, por favor informa al administrador.");
            
            return Ok(new { Message = "Solicitud creada con éxito." });
        }

        private async Task EnviarCorreoSolicitud(string to, string subject, string message)
        {
            // Correo del Administrador al que se le debe informar de la solicitud
            await _emailSender.SendEmailAsync(to, subject, message);
        }
    }
}
