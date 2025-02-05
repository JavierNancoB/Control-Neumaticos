using Microsoft.AspNetCore.Mvc;
using api_control_neumaticos.Models;
using api_control_neumaticos.Dtos.HistorialNeumatico;
using AutoMapper;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Dtos.Alertas;
using api_control_neumaticos.Dtos.Bitacora;
using SendingEmails;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HistorialNeumaticoController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IMapper _mapper;
        private readonly IEmailSender _emailSender;

        public HistorialNeumaticoController(ControlNeumaticosContext context, IMapper mapper, IEmailSender emailSender)
        {
            _context = context;
            _mapper = mapper;
            _emailSender = emailSender;
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
            var historialNeumaticoConCodigo11 = await _context.HistorialesNeumaticos
                .Where(b => b.CODIGO == 11 && b.IDNeumatico == createHistorialNeumaticoDto.IDNeumatico)
                .ToListAsync();

            if (historialNeumaticoConCodigo11.Count == 2)
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
                await EnviarCorreoNotificacion("Se ha creado una nueva alerta.", $"Detalles de la alerta: Pinchazo de neumático");
                await _context.SaveChangesAsync();
            }

            // Crear la bitácora en caso de que el codigo sea 10 o 11
            // donde el código 11 es para el pinchazo de neumático y el 10 para el cambio de presion de aire
            if (createHistorialNeumaticoDto.CODIGO == 10 || createHistorialNeumaticoDto.CODIGO == 11)
            {
                var bitacoraDto = new CreateBitacoraRequestDto
                {
                    CODIGO = createHistorialNeumaticoDto.CODIGO,
                    ID_OBJETO = createHistorialNeumaticoDto.IDNeumatico,
                    ID_USUARIO = createHistorialNeumaticoDto.IDUsuario,
                    FECHA = createHistorialNeumaticoDto.FECHA,
                    OBSERVACION = createHistorialNeumaticoDto.OBSERVACION,
                    ESTADO = createHistorialNeumaticoDto.ESTADO
                };

                var bitacora = _mapper.Map<Bitacora>(bitacoraDto);
                _context.Set<Bitacora>().Add(bitacora);
                await _context.SaveChangesAsync();
            }


            var historialNeumaticoDto = _mapper.Map<HistorialNeumaticoDto>(historialNeumatico);
            return CreatedAtAction(nameof(GetHistorialNeumatico), new { id = historialNeumaticoDto.ID }, historialNeumaticoDto);
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
        // lo ideal es que gracias a un id que mandemos nos devuelva un listado de historialesNeumaticos con el estado que le mandemos
        [HttpGet("GetHistorialNeumaticoByNeumaticoIDAndEstado")]
        public async Task<ActionResult<IEnumerable<HistorialNeumaticoDto>> > GetHistorialNeumaticoByNeumaticoIDAndEstado(int idNeumatico, int estado)
        {
            Console.WriteLine($"Buscando historial para Neumático: {idNeumatico} con estado: {estado}");

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
        /***********************Correo por defecto al crear una alerta**************************/
        private async Task EnviarCorreoNotificacion(string subject, string message)
        {
            await _emailSender.SendEmailAsync("javier.nanco@pentacrom.cl", subject, message);
        }
    }
}