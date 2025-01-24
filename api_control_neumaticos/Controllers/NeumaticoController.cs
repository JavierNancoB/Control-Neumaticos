using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Models;  // Asegúrate de que esta sea la referencia correcta
using api_control_neumaticos.Dtos.Neumaticos;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;


namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]  // Agregar el atributo de autorización
    public class NeumaticosController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;  // Cambié ApplicationDBContext por ControlNeumaticosContext
        private readonly IMapper _mapper;

        public NeumaticosController(ControlNeumaticosContext context, IMapper mapper)  // Cambié el tipo aquí también
        {
            _context = context;
            _mapper = mapper;
        }

        /******************************FUNCIONES CRUD PARA NEUMÁTICOS*************************************/

        // GET: api/Neumaticos
        [HttpGet]
        public async Task<ActionResult<IEnumerable<NeumaticosDto>>> GetNeumaticos()
        {
            var neumaticos = await _context.Neumaticos
                                            .Include(n => n.MOVIL_ASIGNADO)  // Incluir el móvil asignado si es necesario
                                            .ToListAsync();
            var neumaticosDto = _mapper.Map<List<NeumaticosDto>>(neumaticos);
            return Ok(neumaticosDto);
        }

        // GET: api/Neumaticos/5
        [HttpGet("{id}")]
        public async Task<ActionResult<NeumaticosDto>> GetNeumatico(int id)
        {
            var neumatico = await _context.Neumaticos
                                          .Include(n => n.MOVIL_ASIGNADO)  // Incluir el móvil asignado si es necesario
                                          .FirstOrDefaultAsync(n => n.ID_NEUMATICO == id);

            if (neumatico == null)
            {
                return NotFound();
            }

            var neumaticoDto = _mapper.Map<NeumaticosDto>(neumatico);
            return Ok(neumaticoDto);
        }

        // POST: api/Neumaticos
        [HttpPost]
        public async Task<ActionResult<NeumaticosDto>> PostNeumatico(CreateNeumaticoRequestDto createNeumaticoDto)
        {
            // Verificar si el código ya existe
            var existingNeumatico = await _context.Neumaticos.FirstOrDefaultAsync(n => n.CODIGO == createNeumaticoDto.CODIGO);
            if (existingNeumatico != null)
            {
                return BadRequest("El código del neumático ya está registrado.");
            }

            // Verificar si la bodega existe
            var bodega = await _context.Bodegas.FindAsync(createNeumaticoDto.ID_BODEGA);
            if (bodega == null)
            {
                return BadRequest("La bodega no existe.");
            }

            // Verificar si el móvil existe
            if (createNeumaticoDto.ID_MOVIL != null)
            {
                var movil = await _context.Movils.FindAsync(createNeumaticoDto.ID_MOVIL);
            }

            // Mapear los datos del DTO al modelo de Neumático
            var neumatico = _mapper.Map<Neumatico>(createNeumaticoDto);

            // Agregar el neumático a la base de datos
            _context.Neumaticos.Add(neumatico);
            await _context.SaveChangesAsync();

            // Mapear el modelo de Neumático al DTO
            var neumaticoDto = _mapper.Map<NeumaticosDto>(neumatico);

            // Devolver el DTO creado con un CreatedAtAction
            return CreatedAtAction(nameof(GetNeumatico), new { id = neumaticoDto.ID_NEUMATICO }, neumaticoDto);
        }


        // PUT: api/Neumaticos/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutNeumatico(int id, UpdateNeumaticoRequestDto neumaticoUpdateDto)
        {
            // Verificar si el neumático existe
            var neumatico = await _context.Neumaticos.FindAsync(id);
            if (neumatico == null)
            {
                return NotFound("El neumático no existe.");
            }

            // Verificar si el código ya existe
            var existingNeumatico = await _context.Neumaticos.FirstOrDefaultAsync(n => n.CODIGO == neumaticoUpdateDto.CODIGO);
            if (existingNeumatico != null && existingNeumatico.ID_NEUMATICO != id)
            {
                return BadRequest("El código del neumático ya está registrado.");
            }

            // Mapear los datos del DTO al modelo de Neumático
            neumatico.CODIGO = neumaticoUpdateDto.CODIGO;
            neumatico.UBICACION = neumaticoUpdateDto.UBICACION;
            neumatico.ID_MOVIL = neumaticoUpdateDto.ID_MOVIL; // Asignar el ID del móvil

            // Guardar los cambios en la base de datos
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                return Conflict("Hubo un problema al intentar actualizar el neumático. Puede haber un conflicto de concurrencia.");
            }

            // Devolver el DTO actualizado
            var neumaticoDto = _mapper.Map<NeumaticosDto>(neumatico);
            return Ok(neumaticoDto); // Devolver con un OK y el objeto actualizado
        }


        // DELETE: api/Neumaticos/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteNeumatico(int id)
        {
            var neumatico = await _context.Neumaticos.FindAsync(id);
            if (neumatico == null)
            {
                return NotFound();
            }

            _context.Neumaticos.Remove(neumatico);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        /**************FUNCIONES PARA EL MANEJO DE DATOS POR ATRIBUTOS****************/

        // GET: api/Neumaticos/GetNeumaticoByCodigo?codigo=1234

        [HttpGet("GetNeumaticoByCodigo")]
        public async Task<ActionResult<NeumaticosDto>> GetNeumaticoByCodigo(int codigo)
        {
            var neumatico = await _context.Neumaticos.FirstOrDefaultAsync(n => n.CODIGO == codigo);

            if (neumatico == null)
            {
                return NotFound();
            }

            var neumaticoDto = _mapper.Map<NeumaticosDto>(neumatico);
            return Ok(neumaticoDto);
        }

        // GET api/Neumaticos/GetNeumaticoByMovilNULL

        [HttpGet("GetNeumaticoByMovilNULL")]
        public async Task<ActionResult<IEnumerable<NeumaticosDto>> > GetNeumaticoByMovilNULL()
        {
            var neumaticos = await _context.Neumaticos
                                            .Include(n => n.MOVIL_ASIGNADO)
                                            .Where(n => n.MOVIL_ASIGNADO == null)
                                            .ToListAsync();

            var neumaticosDto = _mapper.Map<List<NeumaticosDto>>(neumaticos);
            return Ok(neumaticosDto);
        }

        // GET api/Neumaticos/GetNeumaticoByMovilID
        [HttpGet("GetNeumaticoByMovilID")]
        public async Task<ActionResult<IEnumerable<NeumaticosDto>> > GetNeumaticoByMovilID(int idMovil)
        {
            var neumaticos = await _context.Neumaticos
                                            .Include(n => n.MOVIL_ASIGNADO)
                                            .Where(n => n.ID_MOVIL == idMovil)
                                            .ToListAsync();

            var neumaticosDto = _mapper.Map<List<NeumaticosDto>>(neumaticos);
            return Ok(neumaticosDto);
        }

        // PUT: api/Neumaticos/ModificarEstadoPorCodigo
        // Esta función modifica el campo Estado de un neumático por su código
        [HttpPut("ModificarEstadoPorCodigo")]
        public async Task<IActionResult> ModificarEstadoPorCodigo(int codigo, int estado)
        {
            var neumatico = await _context.Neumaticos.FirstOrDefaultAsync(n => n.CODIGO == codigo);

            if (neumatico == null)
            {
                return NotFound();
            }

            neumatico.ESTADO = estado;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                return Conflict("Hubo un problema al intentar actualizar el neumático. Puede haber un conflicto de concurrencia.");
            }

            return NoContent();
        }

        private bool NeumaticoExists(int id)
        {
            return _context.Neumaticos.Any(e => e.ID_NEUMATICO == id);
        }
    }
}
