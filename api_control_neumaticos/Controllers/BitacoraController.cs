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
            bitacora.FECHA = DateTime.Now;
            _context.Set<Bitacora>().Add(bitacora);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetBitacora), new { id = bitacora.ID }, bitacora);
        }
    }
}
