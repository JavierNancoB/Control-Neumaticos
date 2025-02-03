using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using api_control_neumaticos.Models;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Dtos.Usuario;
using api_control_neumaticos.Services;
using api_control_neumaticos.Dtos.Login;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly PasswordHasher<Usuario> _passwordHasher;
        private readonly TokenGenerator _tokenGenerator;

        public AuthController(ControlNeumaticosContext context, TokenGenerator tokenGenerator)
        {
            _context = context;
            _passwordHasher = new PasswordHasher<Usuario>();
            _tokenGenerator = tokenGenerator;
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
    }
}
