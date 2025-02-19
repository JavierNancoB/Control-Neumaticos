using Microsoft.AspNetCore.Mvc;
using api_control_neumaticos.Dtos.HistorialMovil;
using api_control_neumaticos.Models;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Dtos.Bitacora;


namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HistorialMovilController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IMapper _mapper;

        // Inyectamos el IMapper en el constructor
        public HistorialMovilController(ControlNeumaticosContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper; // Aquí ya se inyecta automáticamente
        }

        // GET: api/HistorialMovil
        [HttpGet]
        public async Task<ActionResult<IEnumerable<HistorialMovilDto>>> GetHistorialMoviles()
        {
            var historiales = await _context.HistorialesMoviles.ToListAsync();
            var historialDtos = _mapper.Map<List<HistorialMovilDto>>(historiales);
            return Ok(historialDtos);
        }

        // GET: api/HistorialMovil/5
        [HttpGet("{id}")]
        public async Task<ActionResult<HistorialMovilDto>> GetHistorialMovil(int id)
        {
            var historialMovil = await _context.HistorialesMoviles.FindAsync(id);

            if (historialMovil == null)
            {
                return NotFound();
            }

            var historialDto = _mapper.Map<HistorialMovilDto>(historialMovil);
            return Ok(historialDto);
        }

        // POST: api/HistorialMovil
        [HttpPost]
        public async Task<ActionResult<HistorialMovilDto>> PostHistorialMovil(CreateHistorialMovilRequestDto createDto)
        {
            var historialMovil = _mapper.Map<HistorialMovil>(createDto);
            _context.HistorialesMoviles.Add(historialMovil);
            await _context.SaveChangesAsync();

            var historialDto = _mapper.Map<HistorialMovilDto>(historialMovil);

            // Crear una bitácora con código 27
            var bitacora = new Bitacora
            {
            CODIGO = 27,
            OBSERVACION = "Historial Movil creado",
            FECHA = DateTime.Now,
            ID_USUARIO = createDto.IDUsuario,
            ESTADO = 1,
            ID_OBJETO = historialMovil.ID,
            TIPO_OBJETO = "Movil"
            // Agregar otros campos necesarios aquí
            };
            _context.Bitacoras.Add(bitacora);

            // Actualizar la última fecha de revisión del móvil
            var movil = await _context.Movils.FindAsync(createDto.IDMovil);
            if (movil != null)
            {
            movil.FechaUltimaComprobacion = DateTime.Now;
            _context.Entry(movil).State = EntityState.Modified;
            }

            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetHistorialMovil), new { id = historialMovil.ID }, historialDto);
        }

        // GET filtrado por id de movil
        [HttpGet("movil/{movilId}")]
        public async Task<ActionResult<IEnumerable<HistorialMovilDto>>> GetHistorialMovilesByMovil(int movilId)
        {
            var historiales = await _context.HistorialesMoviles
                .Where(h => h.IDMovil == movilId)
                .ToListAsync();
            
            if (!historiales.Any())
            {
                return NotFound("No se encontraron historiales para este móvil.");
            }
            
            var historialDtos = _mapper.Map<List<HistorialMovilDto>>(historiales);
            return Ok(historialDtos);
        }

        // GET filtrado por patente del movil y un rango de fechas
        // GET filtrado por patente y fechas
        [HttpGet("buscarPorPatenteYFechas/{patente}/fechaInicio/{fechaInicio}/fechaFin/{fechaFin}")]
        public async Task<ActionResult<IEnumerable<HistorialMovilDto>>> GetHistorialMovilesByPatenteAndFecha(string patente, DateTime fechaInicio, DateTime fechaFin)
        {
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patente);
            if (movil == null)
            {
                return NotFound("No se encontró un móvil con esa patente.");
            }

            var historiales = await _context.HistorialesMoviles
                .Where(h => h.IDMovil == movil.IdMovil && h.FECHA >= fechaInicio && h.FECHA <= fechaFin + TimeSpan.FromDays(1))
                .OrderByDescending(h => h.FECHA)  // Ordena los registros por fecha descendente
                .ToListAsync();

            if (!historiales.Any())
            {
                return NotFound("No se encontraron historiales para este móvil y rango de fechas.");
            }

            var historialDtos = _mapper.Map<List<HistorialMovilDto>>(historiales);
            return Ok(historialDtos);
        }

        // GET filtrado por patente del movil y un id de usuario
        [HttpGet("buscarPorPatenteUsuarioId/{patente}/usuario/{usuarioId}")]
        public async Task<ActionResult<IEnumerable<HistorialMovilDto>>> GetHistorialMovilesByPatenteAndUsuario(string patente, int usuarioId)
        {
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patente);
            if (movil == null)
            {
                return NotFound("No se encontró un móvil con esa patente.");
            }

            var historiales = await _context.HistorialesMoviles
                .Where(h => h.IDMovil == movil.IdMovil && h.IDUsuario == usuarioId)
                .OrderByDescending(h => h.FECHA) // Ordena los registros por fecha descendente
                .ToListAsync();

            if (!historiales.Any())
            {
                return NotFound("No se encontraron historiales para este móvil y usuario.");
            }

            var historialDtos = _mapper.Map<List<HistorialMovilDto>>(historiales);
            return Ok(historialDtos);
        }


        // Post por patente del movil, hay que buscarlo en el modelo de movil porque no se encuentra en el historial
        // la idea es que se mande la patente por la url pero aun asi haga el match con la id del movil
        [HttpPost("patente/{patente}")]
        public async Task<ActionResult<HistorialMovilDto>> PostHistorialMovilByPatente(string patente, CreateHistorialMovilRequestDto createDto)
        {
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patente);
            if (movil == null)
            {
                return NotFound("No se encontró un móvil con esa patente.");
            }

            createDto.IDMovil = movil.IdMovil;
            return await PostHistorialMovil(createDto);
        }

        // PUT: api/HistorialMovil/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutHistorialMovil(int id, UpdateHistorialMovilRequestDto updateDto)
        {
            if (id != updateDto.ID)
            {
                return BadRequest();
            }

            var historialMovil = await _context.HistorialesMoviles.FindAsync(id);
            if (historialMovil == null)
            {
                return NotFound();
            }

            _mapper.Map(updateDto, historialMovil);
            _context.Entry(historialMovil).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/HistorialMovil/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteHistorialMovil(int id)
        {
            var historialMovil = await _context.HistorialesMoviles.FindAsync(id);
            if (historialMovil == null)
            {
                return NotFound();
            }

            _context.HistorialesMoviles.Remove(historialMovil);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
