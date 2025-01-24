using Microsoft.AspNetCore.Mvc;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.Alertas;
using api_control_neumaticos.Mappers;
using AutoMapper;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace api_control_neumaticos.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AlertaController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IMapper _mapper;

        public AlertaController(ControlNeumaticosContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<AlertaDto>>> GetAlertas()
        {
            var alertas = await _context.Set<Alerta>().ToListAsync();
            return Ok(_mapper.Map<IEnumerable<AlertaDto>>(alertas));
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<AlertaDto>> GetAlerta(int id)
        {
            var alerta = await _context.Set<Alerta>().FindAsync(id);
            if (alerta == null)
            {
                return NotFound();
            }
            return Ok(_mapper.Map<AlertaDto>(alerta));
        }

        [HttpPost]
        public async Task<ActionResult<AlertaDto>> CreateAlerta(CreateAlertaRequestDto createAlertaRequestDto)
        {
            var alerta = _mapper.Map<Alerta>(createAlertaRequestDto);
            _context.Set<Alerta>().Add(alerta);
            await _context.SaveChangesAsync();

            var alertaDto = _mapper.Map<AlertaDto>(alerta);
            return CreatedAtAction(nameof(GetAlerta), new { id = alertaDto.Id }, alertaDto);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateAlerta(int id, UpdateAlertaRequestDto updateAlertaRequestDto)
        {
            if (id != updateAlertaRequestDto.Id)
            {
                return BadRequest();
            }

            var alerta = await _context.Set<Alerta>().FindAsync(id);
            if (alerta == null)
            {
                return NotFound();
            }

            _mapper.Map(updateAlertaRequestDto, alerta);
            _context.Entry(alerta).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAlerta(int id)
        {
            var alerta = await _context.Set<Alerta>().FindAsync(id);
            if (alerta == null)
            {
                return NotFound();
            }

            _context.Set<Alerta>().Remove(alerta);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}