using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using api_control_neumaticos.Models;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Dtos.Usuario;
using api_control_neumaticos.Services;
using api_control_neumaticos.Dtos.Login;
using SendingEmails; 

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
                return Unauthorized("Correo incorrecto.");
            }

            // Verificar si la contraseña es correcta
            var result = _passwordHasher.VerifyHashedPassword(usuario, usuario.Clave, loginDto.Clave);

            if (usuario.CodEstado == 3)
            {
                return Unauthorized("Usuario bloqueado. Muchos intentos fallidos, Contactar al administrador.");
            }
            if (usuario.CodEstado == 2)
            {
                return Unauthorized("Usuario deshabilitado.");
            }
            
            if (result == PasswordVerificationResult.Failed)
            {
                usuario.IntentosFallidos += 1;

                if (usuario.IntentosFallidos >= 4)
                {
                    usuario.CodEstado = 3; // Cambia el estado del usuario a bloqueado
                    await _context.SaveChangesAsync();
                    return Unauthorized("Usuario bloqueado. favor contactar al administrador.");
                }
                else
                {
                    await _context.SaveChangesAsync();
                    return Unauthorized("Contraseña incorrecta, quedan " + (4 - usuario.IntentosFallidos) + " intentos.");
                }
            }
            else
            {
                usuario.IntentosFallidos = 0;
                // si la fecha desde que se creo la clave es mas de 80 días se bloquea el usuario, su codEstado cambia a 3
                if (usuario.FechaClave != null)
                {
                    if (DateTime.Now.Subtract(usuario.FechaClave.Value).TotalDays > 80)
                    {
                        usuario.CodEstado = 3;
                        await _context.SaveChangesAsync();
                        return Unauthorized("Usuario bloqueado, por contraseña expirada.");
                    }
                
                    // en caso de que la fecha de creacion de la clave sea menor a 80 días, se ingresa normalmente
                    else
                    {
                        await _context.SaveChangesAsync();
                    }
                }
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
                COD_ESTADO = usuario.CodEstado,
                FECHA_CLAVE = usuario.FechaClave,
                CONTRASEÑA_TEMPORAL = usuario.ContraseñaTemporal,
                TOKEN = token  // Aquí agregamos el token generado
            };

            return Ok(usuarioDto);  // Devuelve el DTO del usuario autenticado con el token
        }

    }
}
