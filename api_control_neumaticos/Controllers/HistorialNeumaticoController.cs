using Microsoft.AspNetCore.Mvc;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.HistorialNeumatico;
using AutoMapper;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Dtos.Alertas;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HistorialNeumaticoController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IMapper _mapper;

        public HistorialNeumaticoController(ControlNeumaticosContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<HistorialNeumaticoDto>>> GetHistorialesNeumaticos()
        {
            var historialesNeumaticos = await _context.HistorialesNeumaticos.ToListAsync();
            return Ok(_mapper.Map<IEnumerable<HistorialNeumaticoDto>>(historialesNeumaticos));
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<HistorialNeumaticoDto>> GetHistorialNeumatico(int id)
        {
            var historialNeumatico = await _context.HistorialesNeumaticos.FindAsync(id);
            if (historialNeumatico == null)
            {
                return NotFound();
            }
            return Ok(_mapper.Map<HistorialNeumaticoDto>(historialNeumatico));
        }

        [HttpPost]
        public async Task<ActionResult<HistorialNeumaticoDto>> CreateHistorialNeumatico(CreateHistorialNeumaticoRequestDto createHistorialNeumaticoDto)
        {
            var historialNeumatico = _mapper.Map<HistorialNeumatico>(createHistorialNeumaticoDto);
            _context.HistorialesNeumaticos.Add(historialNeumatico);
            await _context.SaveChangesAsync();

            // Verificar si ya existen dos bitácoras con el código 5 para el mismo neumático
            var historialNeumaticoConCodigo5 = await _context.HistorialesNeumaticos
                .Where(b => b.CODIGO == 5 && b.IDNeumatico == createHistorialNeumaticoDto.IDNeumatico)
                .ToListAsync();

            if (historialNeumaticoConCodigo5.Count == 2)
            {
                // Crear la alerta
                var alertaDto = new CreateAlertaRequestDto
                {
                    ID_NEUMATICO = createHistorialNeumaticoDto.IDNeumatico,
                    FECHA_INGRESO = DateTime.Now,
                    ESTADO_ALERTA = 1,  // Estado alerta 1
                    CODIGO_ALERTA = 1   // Código de alerta 1 (ajustar según corresponda)
                };

                var alerta = _mapper.Map<Alerta>(alertaDto);
                _context.Set<Alerta>().Add(alerta);
                await _context.SaveChangesAsync();
            }

            var historialNeumaticoDto = _mapper.Map<HistorialNeumaticoDto>(historialNeumatico);
            return CreatedAtAction(nameof(GetHistorialNeumatico), new { id = historialNeumaticoDto.ID }, historialNeumaticoDto);
        }

    private bool DebeCrearAlerta(CreateHistorialNeumaticoRequestDto request)
    {
        // Define aquí las condiciones que deben cumplirse para generar una alerta
        return request.ESTADO == 1 && request.CODIGO == 100; // Ejemplo de condición
    }



        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateHistorialNeumatico(int id, UpdateHistorialNeumaticoRequestDto updateHistorialNeumaticoDto)
        {
            // Ponemos limitantes porque el usuario no puede modificar el ID, el IdUsuario, el IDNeumatico y la fecha
            var historialNeumatico = await _context.HistorialesNeumaticos.FindAsync(id);
            if (historialNeumatico == null)
            {
                return NotFound();
            }

            _mapper.Map(updateHistorialNeumaticoDto, historialNeumatico);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteHistorialNeumatico(int id)
        {
            var historialNeumatico = await _context.HistorialesNeumaticos.FindAsync(id);
            if (historialNeumatico == null)
            {
                return NotFound();
            }

            _context.HistorialesNeumaticos.Remove(historialNeumatico);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        /*******************Hacemos un GET por Id_Neumatico************************/
        [HttpGet("GetHistorialNeumaticoByNeumaticoID")]
        public async Task<ActionResult<IEnumerable<HistorialNeumaticoDto>> > GetHistorialNeumaticoByNeumaticoID(int idNeumatico)
        {
            var historialesNeumaticos = await _context.HistorialesNeumaticos
                                            .Where(b => b.IDNeumatico == idNeumatico)
                                            .ToListAsync();

            var historialNeumaticoDto = _mapper.Map<List<HistorialNeumaticoDto>>(historialesNeumaticos);
            return Ok(historialNeumaticoDto);
        }

        /*******************Hacemos un GET por Id_Neumatico y Estado************************/
        [HttpGet("GetHistorialNeumaticoByNeumaticoIDAndEstado")]
        public async Task<ActionResult<IEnumerable<HistorialNeumaticoDto>> > GetHistorialNeumaticoByNeumaticoIDAndEstado(int idNeumatico, int estado)
        {
            var historialesNeumaticos = await _context.HistorialesNeumaticos
                                            .Where(b => b.IDNeumatico == idNeumatico && b.ESTADO == estado)
                                            .ToListAsync();

            var historialNeumaticoDto = _mapper.Map<List<HistorialNeumaticoDto>>(historialesNeumaticos);
            return Ok(historialNeumaticoDto);
        }

        // un put que cambie solo el estado recibiendo el id de la HistorialNeumatico
        [HttpPut("UpdateEstadoHistorialNeumatico/{id}")]
        public async Task<IActionResult> UpdateEstadoHistorialNeumatico(int id, int estado)
        {
            var historialNeumatico = await _context.HistorialesNeumaticos.FindAsync(id);
            if (historialNeumatico == null)
            {
                return NotFound();
            }

            historialNeumatico.ESTADO = estado;
            await _context.SaveChangesAsync();

            return NoContent();
        }

    }
}