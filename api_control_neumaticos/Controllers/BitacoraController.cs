using Microsoft.AspNetCore.Mvc;
using api_control_neumaticos.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;

namespace api_control_neumaticos.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BitacoraController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;

        public BitacoraController(ControlNeumaticosContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Bitacora>>> GetBitacoras()
        {
            var bitacoras = await _context.Set<Bitacora>().ToListAsync();
            return Ok(bitacoras);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Bitacora>> GetBitacora(int id)
        {
            var bitacora = await _context.Set<Bitacora>().FindAsync(id);
            if (bitacora == null)
            {
                return NotFound();
            }
            return Ok(bitacora);
        }

        [HttpPost]
        public async Task<ActionResult<Bitacora>> CreateBitacora(Bitacora bitacora)
        {
            // Validar que TIPO_OBJETO sea uno de los valores permitidos
            if (bitacora.TIPO_OBJETO != "Neumatico" && bitacora.TIPO_OBJETO != "Movil" && bitacora.TIPO_OBJETO != "Usuario")
            {
                return BadRequest("El tipo de objeto no es válido. Debe ser 'Neumatico', 'Movil' o 'Usuario'.");
            }

            // Validar que el ID_OBJETO sea válido según el tipo de objeto
            if (bitacora.TIPO_OBJETO == "Neumatico" && !await _context.Neumaticos.AnyAsync(n => n.ID_NEUMATICO == bitacora.ID_OBJETO))
            {
                return BadRequest("El Neumático con el ID especificado no existe.");
            }
            if (bitacora.TIPO_OBJETO == "Movil" && !await _context.Movils.AnyAsync(m => m.IdMovil == bitacora.ID_OBJETO))
            {
                return BadRequest("El Móvil con el ID especificado no existe.");
            }
            if (bitacora.TIPO_OBJETO == "Usuario" && !await _context.Usuarios.AnyAsync(u => u.IdUsuario == bitacora.ID_OBJETO))
            {
                return BadRequest("El Usuario con el ID especificado no existe.");
            }

            bitacora.FECHA = DateTime.Now;
            _context.Set<Bitacora>().Add(bitacora);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetBitacora), new { id = bitacora.ID }, bitacora);
        }

    }
}
