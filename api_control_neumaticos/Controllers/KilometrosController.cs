using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Kilometros;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class KilometrosController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IMapper _mapper;

        public KilometrosController(ControlNeumaticosContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<KilometrosDto>>> GetKilometros()
        {
            var kilometros = await _context.Kilometros.ToListAsync();
            return _mapper.Map<List<KilometrosDto>>(kilometros);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<KilometrosDto>> GetKilometros(int id)
        {
            var kilometro = await _context.Kilometros.FindAsync(id);

            if (kilometro == null)
            {
                return NotFound();
            }

            return _mapper.Map<KilometrosDto>(kilometro);
        }

        [HttpPost]
        public async Task<ActionResult<KilometrosDto>> PostKilometros(CreateKilometrosRequestDto kilometrosCreateDto)
        {
            var kilometro = _mapper.Map<Kilometros>(kilometrosCreateDto);
            _context.Kilometros.Add(kilometro);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetKilometros), new { id = kilometro.ID_KILOMETRO_DIARIO }, _mapper.Map<KilometrosDto>(kilometro));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutKilometros(int id, KilometrosDto kilometrosDto)
        {
            if (id != kilometrosDto.ID_KILOMETRO_DIARIO)
            {
                return BadRequest();
            }

            var kilometro = _mapper.Map<Kilometros>(kilometrosDto);
            _context.Entry(kilometro).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!KilometrosExists(id))
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

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteKilometros(int id)
        {
            var kilometro = await _context.Kilometros.FindAsync(id);
            if (kilometro == null)
            {
                return NotFound();
            }

            _context.Kilometros.Remove(kilometro);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool KilometrosExists(int id)
        {
            return _context.Kilometros.Any(e => e.ID_KILOMETRO_DIARIO == id);
        }
    }
}
