using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Models;
using AutoMapper;
using api_control_neumaticos.Dtos.Usuario;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authorization;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuariosController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IMapper _mapper;
        private readonly PasswordHasher<Usuario> _passwordHasher;  // Agregar el PasswordHasher

        public UsuariosController(ControlNeumaticosContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _passwordHasher = new PasswordHasher<Usuario>();  // Inicializar el PasswordHasher
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
        public async Task<ActionResult<UsuarioDto>> PostUsuario(UsuarioDto usuarioDto)
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
        public async Task<IActionResult> ModificarCodEstadoPorCorreo(string mail, int codEstado)
        {
            var usuario = await _context.Usuarios.FirstOrDefaultAsync(u => u.Correo == mail);

            if (usuario == null)
            {
                return NotFound();
            }

            usuario.CodEstado = codEstado;
            _context.Entry(usuario).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        //API Para modificar nombres, apellidos, correo y codigo perfil
        [HttpPut("ModificarDatosUsuario")]
        public async Task<IActionResult> ModificarDatosUsuario(string mail, string nuevosMail, string nombres, string apellidos, int codigoPerfil)
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
            }

            // Actualizar los datos del usuario
            usuario.Nombres = nombres;
            usuario.Apellidos = apellidos;
            usuario.Correo = nuevosMail; // Se actualiza el correo con el nuevo valor
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
        


        private bool UsuarioExists(int id)
        {
            return _context.Usuarios.Any(e => e.IdUsuario == id);
        }
    }
}
