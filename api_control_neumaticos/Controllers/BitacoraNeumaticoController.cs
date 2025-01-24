using Microsoft.AspNetCore.Mvc;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.BitacoraNeumatico;
using AutoMapper;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BitacoraNeumaticoController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IMapper _mapper;

        public BitacoraNeumaticoController(ControlNeumaticosContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<BitacoraNeumaticoDto>>> GetBitacoras()
        {
            var bitacoras = await _context.BitacoraNeumaticos.ToListAsync();
            return Ok(_mapper.Map<IEnumerable<BitacoraNeumaticoDto>>(bitacoras));
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<BitacoraNeumaticoDto>> GetBitacora(int id)
        {
            var bitacora = await _context.BitacoraNeumaticos.FindAsync(id);
            if (bitacora == null)
            {
                return NotFound();
            }
            return Ok(_mapper.Map<BitacoraNeumaticoDto>(bitacora));
        }

        [HttpPost]
        public async Task<ActionResult<BitacoraNeumaticoDto>> CreateBitacora(CreateBitacoraNeumaticoRequestDto createBitacoraDto)
        {
            var bitacora = _mapper.Map<BitacoraNeumatico>(createBitacoraDto);
            _context.BitacoraNeumaticos.Add(bitacora);
            await _context.SaveChangesAsync();

            var bitacoraDto = _mapper.Map<BitacoraNeumaticoDto>(bitacora);
            return CreatedAtAction(nameof(GetBitacora), new { id = bitacoraDto.ID }, bitacoraDto);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateBitacora(int id, UpdateBitacoraNeumaticoRequestDto updateBitacoraDto)
        {
            // Ponemos limitantes porque el usuario no puede modificar el ID, el IdUsuario, el IDNeumatico y la fecha
            var bitacora = await _context.BitacoraNeumaticos.FindAsync(id);
            if (bitacora == null)
            {
                return NotFound();
            }

            _mapper.Map(updateBitacoraDto, bitacora);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteBitacora(int id)
        {
            var bitacora = await _context.BitacoraNeumaticos.FindAsync(id);
            if (bitacora == null)
            {
                return NotFound();
            }

            _context.BitacoraNeumaticos.Remove(bitacora);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        /*******************Hacemos un GET por Id_Neumatico************************/
        [HttpGet("GetBitacoraByNeumaticoID")]
        public async Task<ActionResult<IEnumerable<BitacoraNeumaticoDto>> > GetBitacoraByNeumaticoID(int idNeumatico)
        {
            var bitacoras = await _context.BitacoraNeumaticos
                                            .Where(b => b.IDNeumatico == idNeumatico)
                                            .ToListAsync();

            var bitacorasDto = _mapper.Map<List<BitacoraNeumaticoDto>>(bitacoras);
            return Ok(bitacorasDto);
        }
    }
}