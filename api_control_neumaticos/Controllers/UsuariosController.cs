using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Models;
using AutoMapper;
using api_control_neumaticos.Dtos.Usuario;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authorization;
using api_control_neumaticos.Dtos.Bitacora;
using SendingEmails;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuariosController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IMapper _mapper;
        private readonly PasswordHasher<Usuario> _passwordHasher;  // Agregar el PasswordHasher
        private readonly IEmailSender _emailSender;

        public UsuariosController(ControlNeumaticosContext context, IMapper mapper, IEmailSender emailSender)
        {
            _context = context;
            _mapper = mapper;
            _passwordHasher = new PasswordHasher<Usuario>();  // Inicializar el PasswordHasher
            _emailSender = emailSender;
        }
        
        /***************************FUNCIONES CRUD PARA USUARIOS*************************************/
        
        // GET: api/Usuarios
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UsuarioDto>>> GetUsuarios()
        {
            var usuarios = await _context.Usuarios.ToListAsync();
            return _mapper.Map<List<UsuarioDto>>(usuarios);
        }

        // GET: api/Usuarios/5
        [HttpGet("{id}")]
        public async Task<ActionResult<UsuarioDto>> GetUsuario(int id)
        {
            var usuario = await _context.Usuarios.FindAsync(id);

            if (usuario == null)
            {
                return NotFound();
            }

            return _mapper.Map<UsuarioDto>(usuario);
        }

        // POST: api/Usuarios
        [HttpPost]
        public async Task<ActionResult<UsuarioDto>> PostUsuario(UsuarioDto usuarioDto, [FromQuery] int idUsuarioBitacora)
        {
            // Verificar si el correo ya existe
            if (await _context.Usuarios.AnyAsync(u => u.Correo == usuarioDto.CORREO))
            {
            return Conflict(new { message = "El correo ya está en uso." });
            }

            // Hashear la contraseña antes de guardar
            var usuario = _mapper.Map<Usuario>(usuarioDto);
            usuario.Clave = _passwordHasher.HashPassword(usuario, usuarioDto.CLAVE);  // Hashear la contraseña

            _context.Usuarios.Add(usuario);
            await _context.SaveChangesAsync();

            Console.WriteLine($"ID Usuario Bitacora: {idUsuarioBitacora}");
            await RegistrarBitacora(idUsuarioBitacora, 12, usuario.IdUsuario, "Usuario", $"Creación de usuario don(a) {usuario.Nombres} {usuario.Apellidos}");

            return CreatedAtAction("GetUsuario", new { id = usuario.IdUsuario }, usuarioDto);
        }

        // PUT: api/Usuarios/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUsuario(int id, UsuarioDto usuarioDto)
        {
            if (id != usuarioDto.ID_USUARIO)
            {
                return BadRequest();
            }

            var usuario = await _context.Usuarios.FindAsync(id);
            if (usuario == null)
            {
                return NotFound();
            }

            // Verificar si el correo ya está en uso por otro usuario
            if (await _context.Usuarios.AnyAsync(u => u.Correo == usuarioDto.CORREO && u.IdUsuario != id))
            {
                return Conflict(new { message = "El correo ya está en uso por otro usuario." });
            }

            // Actualizar los campos del usuario
            usuario.Nombres = usuarioDto.NOMBRES;
            usuario.Apellidos = usuarioDto.APELLIDOS;
            usuario.Correo = usuarioDto.CORREO;
            // Actualizar los campos adicionales del usuario
            usuario.CodigoPerfil = usuarioDto.CODIGO_PERFIL;
            usuario.CodEstado = usuarioDto.COD_ESTADO;
            usuario.ID_BODEGA = usuarioDto.ID_BODEGA;

            // Si la contraseña ha cambiado, hashearla
            if (!string.IsNullOrEmpty(usuarioDto.CLAVE))
            {
                usuario.Clave = _passwordHasher.HashPassword(usuario, usuarioDto.CLAVE);
            }

            _context.Entry(usuario).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
                catch (DbUpdateConcurrencyException)
            {
            if (!UsuarioExists(id))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
            }

            return NoContent();
        }

        // DELETE: api/Usuarios/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUsuario(int id)
        {
            var usuario = await _context.Usuarios.FindAsync(id);
            if (usuario == null)
            {
                return NotFound();
            }

            _context.Usuarios.Remove(usuario);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        /*************FUNCIONES PARA EL MANEJO DE DATOS A TRAVES DE ATRIBUTOS*********************/

        // GET: api/Usuarios/GetUsuarioByMail?mail=ejemplo@correo.com

        [HttpGet("GetUsuarioByMail")]
        public async Task<ActionResult<UsuarioDto>> GetUsuarioByMail(string mail)
        {
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Correo == mail);

            if (usuario == null)
            {
                return NotFound();
            }

            return _mapper.Map<UsuarioDto>(usuario);
        }

        // GET: api/Usuarios/BuscarUsuariosPorCorreo?query=j
        // Esta función busca usuarios por su correo, devolviendo los primeros 10 correos que coincidan con la búsqueda
        [HttpGet("BuscarUsuariosPorCorreo")]
        public async Task<ActionResult<IEnumerable<string>>> BuscarUsuariosPorCorreo(string query)
        {
            var correos = await _context.Usuarios
                .Where(u => u.Correo.Contains(query))
                .Select(u => u.Correo)
                .Take(4)
                .ToListAsync();

            return correos;
        }


        // PUT: api/Usuarios/ModificarCodEstadoPorCorreo
        // Esta función modifica el campo CodEstado de un usuario por su correo
        [HttpPut("ModificarCodEstadoPorCorreo")]
        public async Task<IActionResult> ModificarCodEstadoPorCorreo(string mail, int codEstado, [FromQuery] int idUsuarioBitacora)
        {
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Correo == mail);

            if (usuario == null)
            {
                return NotFound();
            }

            if(usuario.CodEstado == 2){
                await RegistrarBitacora(idUsuarioBitacora, 17, usuario.IdUsuario, "Usuario", "Modificación de estado de usuario a deshabilitado");
            }

            usuario.CodEstado = codEstado;
            _context.Entry(usuario).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        //API Para modificar nombres, apellidos, correo y codigo perfil
        [HttpPut("ModificarDatosUsuario")]
        public async Task<IActionResult> ModificarDatosUsuario(string mail, string nuevosMail, string nombres, string apellidos, int codigoPerfil, [FromQuery] int idUsuarioBitacora)
        {
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Correo == mail);

            if (usuario == null)
            {
                return NotFound();
            }

            // Si el nuevo correo es diferente al actual, verificar si ya existe otro usuario con ese correo
            if (nuevosMail != mail)
            {
                var existeUsuarioConNuevoCorreo = await _context.Usuarios.AnyAsync(u => u.Correo == nuevosMail);
                if (existeUsuarioConNuevoCorreo)
                {
                    return BadRequest("El correo proporcionado ya está en uso.");
                }
                else{
                    // Actualizar el correo en la tabla de usuarios
                    await RegistrarBitacora(idUsuarioBitacora, 16, usuario.IdUsuario, "Usuario", $"Modificación de correo de usuario a {nuevosMail}");
                }
            }
            // Actualizar los datos del usuario
            if(nombres != usuario.Nombres){
                await RegistrarBitacora(idUsuarioBitacora, 13, usuario.IdUsuario, "Usuario", $"Modificación de nombres de usuario a {nombres}");
            }
            usuario.Nombres = nombres;
            if(apellidos != usuario.Apellidos){
                await RegistrarBitacora(idUsuarioBitacora, 14, usuario.IdUsuario, "Usuario", $"Modificación de apellidos de usuario a {apellidos}");
            }
            usuario.Apellidos = apellidos;
            usuario.Correo = nuevosMail; // Se actualiza el correo con el nuevo valor
            if(codigoPerfil != usuario.CodigoPerfil){
                await RegistrarBitacora(idUsuarioBitacora, 15, usuario.IdUsuario, "Usuario", $"Modificación de perfil de usuario a {codigoPerfil}");
            }
            usuario.CodigoPerfil = codigoPerfil;
            _context.Entry(usuario).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // Comprobamos que usuario esta habilitado
        [HttpGet("ComprobarUsuarioHabilitado")]
        public async Task<ActionResult<bool>> ComprobarUsuarioHabilitado(string mail)
        {
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Correo == mail);

            if (usuario == null)
            {
                return NotFound();
            }

            return usuario.CodEstado == 1;
        }
        
        private async Task RegistrarBitacora(int idUsuario, int codigo, int idObjeto, string tipoObjeto, string observacion)
        {
            var bitacoraDto = new CreateBitacoraRequestDto
            {
                ID_USUARIO = idUsuario,
                CODIGO = codigo,
                ID_OBJETO = idObjeto,
                FECHA = DateTime.Now,
                TIPO_OBJETO = tipoObjeto,
                OBSERVACION = observacion,
                ESTADO = 1,
            };

            var bitacora = _mapper.Map<Bitacora>(bitacoraDto);
            _context.Set<Bitacora>().Add(bitacora);
            await _context.SaveChangesAsync();
        }

        /**************Restablecer contraseña****************/
        // Tu contraseña queda como tu correo hasta antes del @ si es autogenerada
        // Caso contrario el endpoint es http://localhost:5062/api/Usuarios/RestablecerClave?mail=javier.nanco@pentacrom.cl&NuevaClave=hola123
        [HttpPut("RestablecerClave")]
        public async Task<IActionResult> RestablecerClave(string mail, [FromQuery] bool autogenerada = false, [FromQuery] bool administrador = true)
        {
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Correo == mail);

            Console.WriteLine($"Intento de restablecer clave para: {mail}");

            if (usuario == null)
            {
                return NotFound("Usuario no encontrado.");
            }

            // Verificar si la nueva contraseña es igual a la anterior
            if (!autogenerada && _passwordHasher.VerifyHashedPassword(usuario, usuario.Clave, Request.Query["NuevaClave"].ToString()) == PasswordVerificationResult.Success)
            {
                return BadRequest("La nueva contraseña no puede ser la misma que la anterior.");
            }

            if (autogenerada)
            {
                // Contraseña autogenerada
                var nuevaClave = mail.Split('@')[0]; // Usamos el nombre antes del '@' como clave
                usuario.Clave = _passwordHasher.HashPassword(usuario, nuevaClave);
                usuario.ContraseñaTemporal = _passwordHasher.HashPassword(usuario, nuevaClave);

                await EnviarCorreoNotificacion(mail, "Restablecimiento de contraseña", $"Su contraseña ha sido restablecida con éxito. Posee 2 días para cambiarla.\n\nATENCION: No comparta esta información con nadie, su nueva contraseña es: {nuevaClave}. \n\nSe sugiere cambiar la contraseña INMEDIATAMENTE por una más segura.\n\nAtentamente el equipo de Control Neumáticos. Favor no responder a este correo automatizado.");
                // si es administrador la fecha sera hoy menos 78 dias
                if(administrador){
                    usuario.FechaClave = DateTime.Now.AddDays(-78);
                    Console.WriteLine($"Fecha antes de guardar3: {usuario.FechaClave}");
                }
                else{
                    usuario.FechaClave = DateTime.Now;
                    Console.WriteLine($"Fecha antes de guardar4: {usuario.FechaClave}");
                }

            }
            else
            {
                // Contraseña proporcionada por el administrador o usuario
                var nuevaClave = Request.Query["NuevaClave"].ToString();
                usuario.Clave = _passwordHasher.HashPassword(usuario, nuevaClave);

                await EnviarCorreoNotificacion(mail, "Restablecimiento de contraseña", $"Su contraseña ha sido restablecida con éxito. Posee 2 días para cambiarla.\n\nATENCION: No comparta esta información con nadie, su nueva contraseña es: {nuevaClave}. \n\nSe sugiere cambiar INMEDIATAMENTE la contraseña por una más segura.\n\nAtentamente el equipo de Control Neumáticos. Favor no responder a este correo automatizado.");
                if(administrador){
                    // Se crea con clave temporal para que el usuario la cambie
                    usuario.FechaClave = DateTime.Now.AddDays(-78);
                    usuario.ContraseñaTemporal = _passwordHasher.HashPassword(usuario, nuevaClave);
                    Console.WriteLine($"Fecha antes de guardar1: {usuario.FechaClave}");
                }
                else{
                    usuario.FechaClave = DateTime.Now;
                    // La unica forma de que la contraseña temporal sea nula es que el usuario la haya cambiado
                    usuario.ContraseñaTemporal = null;
                    Console.WriteLine($"Fecha antes de guardar2: {usuario.FechaClave}");
                    Console.WriteLine($"Contraseña temporal: {usuario.ContraseñaTemporal}");
                }
            }

        // Reiniciar intentos fallidos y actualizar datos del usuario
        usuario.IntentosFallidos = 0;
        usuario.CodEstado = 1; // Restaurar estado activo

        _context.Entry(usuario).State = EntityState.Modified;
        
        await _context.SaveChangesAsync();

        return NoContent();
    }

        // Enviar correo de notificación de contraseña restablecida
        private async Task EnviarCorreoNotificacion(string to, string subject, string message)
        {
            await _emailSender.SendEmailAsync(to, subject, message);
        }

        private bool UsuarioExists(int id)
        {
            return _context.Usuarios.Any(e => e.IdUsuario == id);
        }
    }
}
