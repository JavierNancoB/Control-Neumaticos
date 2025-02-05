using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using api_control_neumaticos.Models;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Dtos.Usuario;
using api_control_neumaticos.Services;
using api_control_neumaticos.Dtos.Login;
using SendingEmails; 
using api_control_neumaticos.Dtos.Password;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly PasswordHasher<Usuario> _passwordHasher;
        private readonly TokenGenerator _tokenGenerator;
        private readonly IEmailSender _emailSender;

        public AuthController(ControlNeumaticosContext context, TokenGenerator tokenGenerator, IEmailSender emailSender)
        {
            _context = context;
            _passwordHasher = new PasswordHasher<Usuario>();
            _tokenGenerator = tokenGenerator;
            _emailSender = emailSender;
        }

        // POST: api/Auth/Login
        [HttpPost("Login")]
        public async Task<ActionResult<UsuarioDto>> Login(LoginDto loginDto)
        {
            // Buscar al usuario en la base de datos
            var usuario = await _context.Usuarios
                .FirstOrDefaultAsync(u => u.Correo == loginDto.Correo);

            if (usuario == null)
            {
                return Unauthorized("Correo o contraseña incorrectos.");
            }

            // Verificar si la contraseña es correcta
            var result = _passwordHasher.VerifyHashedPassword(usuario, usuario.Clave, loginDto.Clave);

            if (result == PasswordVerificationResult.Failed)
            {
                return Unauthorized("Correo o contraseña incorrectos.");
            }

            // Generar el token
            var token = _tokenGenerator.GenerateToken(usuario.Correo);

            // Si la contraseña es correcta, retornar el UsuarioDto con el token
            var usuarioDto = new UsuarioDto
            {
                ID_USUARIO = usuario.IdUsuario,
                NOMBRES = usuario.Nombres,
                APELLIDOS = usuario.Apellidos,
                CORREO = usuario.Correo,
                CODIGO_PERFIL = usuario.CodigoPerfil,
                TOKEN = token  // Aquí agregamos el token generado
            };

            return Ok(usuarioDto);  // Devuelve el DTO del usuario autenticado con el token
        }

        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword(ForgotPasswordDto model)
        {
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Correo == model.Correo);
            if (usuario == null)
            {
                return BadRequest("El correo no está registrado.");
            }

            // Generar un token de recuperación (puedes usar un GUID o un JWT con expiración)
            var token = Guid.NewGuid().ToString(); 

            // Guardar el token en la base de datos con una expiración (ejemplo: 30 minutos)
            usuario.ResetToken = token;
            usuario.ResetTokenExpiry = DateTime.UtcNow.AddMinutes(30);
            await _context.SaveChangesAsync();

            // Construir el enlace de restablecimiento
            var resetLink = $"https://tuapp.com/reset-password?token={token}&email={Uri.EscapeDataString(model.Correo)}";

            // Enviar el correo
            string subject = "Recuperación de Contraseña";
            string message = $"Usa este enlace para restablecer tu contraseña: {resetLink}";

            await _emailSender.SendEmailAsync(model.Correo, subject, message);

            return Ok("Se ha enviado un correo con instrucciones para restablecer la contraseña.");
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword(ResetPasswordDto model)
        {
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Correo == model.Correo);
            if (usuario == null || usuario.ResetToken != model.Token || usuario.ResetTokenExpiry < DateTime.UtcNow)
            {
                return BadRequest("El token es inválido o ha expirado.");
            }

            // Hashear la nueva contraseña
            usuario.Clave = _passwordHasher.HashPassword(usuario, model.NewPassword);
            usuario.ResetToken = null;
            usuario.ResetTokenExpiry = null;
            await _context.SaveChangesAsync();

            return Ok("Contraseña restablecida con éxito.");
        }

    }
}
