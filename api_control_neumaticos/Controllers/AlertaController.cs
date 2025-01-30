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

        /********************FUNCIONES POR ATRIBUTOS*********************/

        // GET: api/Alerta/GetAlertasByEstadoAlerta1&2
        // esta mostrara todas las alerttas que tengan el estado de alerta 1 o 2
        [HttpGet("GetAlertasByEstadoAlerta1&2")]
        public async Task<ActionResult<IEnumerable<AlertaDto>>> GetAlertasByCodigoAlerta1And2()
        {
            var alertas = await _context.Set<Alerta>()
                .Where(a => a.ESTADO_ALERTA == 1 || a.ESTADO_ALERTA == 2)
                .OrderByDescending(a => a.FECHA_INGRESO)  // Ordenar por fecha de ingreso, descendente
                .ToListAsync();

            return Ok(_mapper.Map<IEnumerable<AlertaDto>>(alertas));
        }


        // GET: api/Alerta/GetAlertasByEstadoAlerta3
        // esta mostrara todas las alerttas que tengan el estado de alerta 3, muestra solo las primeras 50
        [HttpGet("GetAlertasByEstadoAlerta3")]
        public async Task<ActionResult<IEnumerable<AlertaDto>>> GetAlertasByCodigoAlerta3()
        {
            var alertas = await _context.Set<Alerta>().Where(a => a.ESTADO_ALERTA == 3).Take(50).ToListAsync();
            return Ok(_mapper.Map<IEnumerable<AlertaDto>>(alertas));
        }

        // GET: api/Alerta/CambiarEstado
        // esta funcion cambiara el estado de la alerta y ademas la fecha de atencion
        // si cambia a estado 1 es fecha ingreso
        // si cambia a estado 2 es fecha leido
        // si cambia a estado 3 es fecha atendido

        [HttpPut("CambiarEstado")]
        public async Task<IActionResult> CambiarEstado(int id, int estado, int idUsuario)
        {
            var alerta = await _context.Set<Alerta>().FindAsync(id);
            if (alerta == null)
            {
                return NotFound();
            }
            if(estado == 1)
            {
                alerta.ESTADO_ALERTA = 1;
                alerta.FECHA_INGRESO = System.DateTime.Now;
                // FECHA LEIDO NULL
                alerta.FECHA_LEIDO = null;
                alerta.FECHA_ATENDIDO = null;
                alerta.USUARIO_LEIDO_ID = null;
                alerta.USUARIO_ATENDIDO_ID = null;
            }

            if (estado == 2)
            {
                alerta.ESTADO_ALERTA = 2;
                alerta.FECHA_LEIDO = System.DateTime.Now;
                // FECHA ATENDIDO NULL
                alerta.FECHA_ATENDIDO = null;
                alerta.USUARIO_LEIDO_ID = idUsuario;
                alerta.USUARIO_ATENDIDO_ID = null;
            }
            else if (estado == 3)
            {
                alerta.ESTADO_ALERTA = 3;
                alerta.FECHA_ATENDIDO = System.DateTime.Now;
                alerta.USUARIO_ATENDIDO_ID = idUsuario;
            }

            _context.Entry(alerta).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }
        
    }
}