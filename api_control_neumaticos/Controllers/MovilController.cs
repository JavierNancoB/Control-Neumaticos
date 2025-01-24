using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Models;
using AutoMapper;
using api_control_neumaticos.Dtos.Movil;
using Microsoft.AspNetCore.Authorization;

namespace api_control_neumaticos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class MovilController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;
        private readonly IMapper _mapper;

        public MovilController(ControlNeumaticosContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        /******************************FUNCIONES CRUD PARA MOVIL*************************************/

        // GET: api/Movil
        [HttpGet]
        public async Task<ActionResult<IEnumerable<MovilDto>>> GetMovils()
        {
            var moviles = await _context.Movils.ToListAsync();
            return _mapper.Map<List<MovilDto>>(moviles);
        }

        // GET: api/Movil/5
        [HttpGet("{id}")]
        public async Task<ActionResult<MovilDto>> GetMovil(int id)
        {
            var movil = await _context.Movils.FindAsync(id);

            if (movil == null)
            {
                return NotFound();
            }

            return _mapper.Map<MovilDto>(movil);
        }

        // POST: api/Movil
        [HttpPost]
        public async Task<ActionResult<MovilDto>> PostMovil(CreateMovilRequestDto movilCreateDto)
        {
            // Verificar si ya existe un movil con la misma patente
            if (_context.Movils.Any(m => m.Patente == movilCreateDto.PATENTE))
            {
            return BadRequest("Ya existe un movil con la misma patente.");
            }
            // Si bodega no es nulo, verificar si existe
            if (movilCreateDto.ID_BODEGA != null)
            {
                var bodega = await _context.Bodegas.FindAsync(movilCreateDto.ID_BODEGA);
                if (bodega == null)
                {
                    return BadRequest("La bodega especificada no existe.");
                }
            }

            // Mapear el DTO a la entidad del modelo
            var movil = _mapper.Map<Movil>(movilCreateDto); 

            // Agregar la entidad al contexto
            _context.Movils.Add(movil);

            // Guardar los cambios en la base de datos
            await _context.SaveChangesAsync();

            // Devolver una respuesta Created con el DTO de creación
            return CreatedAtAction("GetMovil", new { id = movil.IdMovil }, movilCreateDto);
        }

        // PUT: api/Movil/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMovil(int id, UpdateMovilRequestDto movilUpdateDto)
        {
            if (id != movilUpdateDto.IdMovil) // llama a idMovil del DTO
            {
                return BadRequest();
            }

            // Verificar si ya existe un movil con la misma patente

            if (_context.Movils.Any(m => m.Patente == movilUpdateDto.Patente && m.IdMovil != id))
            {
                return BadRequest("Ya existe un movil con la misma patente.");
            }

            if (movilUpdateDto.ID_BODEGA != null)
            {
                var bodega = await _context.Bodegas.FindAsync(movilUpdateDto.ID_BODEGA);
                if (bodega == null)
                {
                    return BadRequest("La bodega especificada no existe.");
                }
            }

            // Mapear el DTO a la entidad del modelo
            var movil = _mapper.Map<Movil>(movilUpdateDto);

            // Marcar la entidad como modificada
            _context.Entry(movil).State = EntityState.Modified;

            try
            {
                // Guardar los cambios en la base de datos
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MovilExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            // Devolver una respuesta NoContent
            return NoContent();
        }

        // DELETE: api/Movil/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMovil(int id)
        {
            var movil = await _context.Movils.FindAsync(id);
            if (movil == null)
            {
                return NotFound();
            }

            _context.Movils.Remove(movil);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        /*************FUNCIONES PARA EL MANEJO DE DATOS A TRAVES DE ATRIBUTOS*********************/

        //GET: api/Movil/GetMovilByPatente

        [HttpGet("GetMovilByPatente")]
        public async Task<ActionResult<MovilDto>> GetMovilByPatente(string patente)
        {
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patente);

            if (movil == null)
            {
                return NotFound();
            }

            return _mapper.Map<MovilDto>(movil);
        }

        //PUT: api/Movil/CambiaEstadoMovilPorPatente

        [HttpPut("CambiaEstadoMovilPorPatente")]
        public async Task<IActionResult> CambiaEstadoMovilPorPatente(string patente, int estado)
        {
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patente);

            if (movil == null)
            {
                return NotFound();
            }

            movil.Estado = estado;

            _context.Entry(movil).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return NoContent();
        }


        // PUT: api para modificar movil por patente, solo se modificara patente, marca, modelo, ejes, neumaticos, tipo movil
        // se envia con la url api/Movil/ModificarMovilPorPatente?patente=patente&marca=marca&modelo=modelo&ejes=ejes&cantidadNeumaticos=cantidadNeumaticos&tipoMovil=tipoMovil
        [HttpPut("ModificarMovilPorPatente")]
        public async Task<IActionResult> ModificarMovilPorPatente(string patenteActual, string patenteNueva, string marca, string modelo, int ejes, int cantidadNeumaticos, int tipoMovil)
        {
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patenteActual);

            if (movil == null)
            {
                return NotFound();
            }

            movil.Patente = patenteNueva;
            movil.Marca = marca;
            movil.Modelo = modelo;
            movil.Ejes = ejes;
            movil.CantidadNeumaticos = cantidadNeumaticos;
            movil.TipoMovil = tipoMovil;

            _context.Entry(movil).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        
        // ESTA FUNCION SIRVE PARA VERIFICAR SI EXISTE UN MOVIL CON UN ID DADO

        private bool MovilExists(int id)
        {
            return _context.Movils.Any(e => e.IdMovil == id);
        }
    }
}
