using Microsoft.AspNetCore.Mvc;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Bodega;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;

namespace api_control_neumaticos.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BodegaController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;

        private readonly IMapper _mapper;

        public BodegaController(ControlNeumaticosContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        // GET: api/Bodega
        [HttpGet]
        public async Task<ActionResult<IEnumerable<BodegaDto>>> GetBodegas()
        {
            var bodegas = await _context.Bodegas.ToListAsync();
            return Ok(_mapper.Map<IEnumerable<BodegaDto>>(bodegas));
        }

        // GET: api/Bodega/{id}
        [HttpGet("{id:int}")]
        public async Task<ActionResult<BodegaDto>> GetBodega(int id)
        {
            var bodega = await _context.Bodegas.FindAsync(id);

            if (bodega == null)
                return NotFound(new { message = "Bodega no encontrada." });

            return Ok(_mapper.Map<BodegaDto>(bodega));
        }

        // POST: api/Bodega
        [HttpPost]
        public async Task<ActionResult<BodegaDto>> CreateBodega([FromBody] CreateBodegaRequestDto createDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var bodega = _mapper.Map<Bodega>(createDto);
            _context.Bodegas.Add(bodega);
            await _context.SaveChangesAsync();

            var bodegaDto = _mapper.Map<BodegaDto>(bodega);
            return CreatedAtAction(nameof(GetBodega), new { id = bodega.ID_BODEGA }, bodegaDto);
        }

        // PUT: api/Bodega/{id}
        [HttpPut("{id:int}")]
        public async Task<IActionResult> UpdateBodega(int id, [FromBody] UpdateBodegaRequestDto updateDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var bodega = await _context.Bodegas.FindAsync(id);
            if (bodega == null)
                return NotFound(new { message = "Bodega no encontrada." });

            _mapper.Map(updateDto, bodega);
            _context.Bodegas.Update(bodega);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/Bodega/{id}
        [HttpDelete("{id:int}")]
        public async Task<IActionResult> DeleteBodega(int id)
        {
            var bodega = await _context.Bodegas.FindAsync(id);
            if (bodega == null)
                return NotFound(new { message = "Bodega no encontrada." });

            _context.Bodegas.Remove(bodega);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
