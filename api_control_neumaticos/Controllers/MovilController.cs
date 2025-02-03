using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Models;
using AutoMapper;
using api_control_neumaticos.Dtos.Movil;
using Microsoft.AspNetCore.Authorization;
using api_control_neumaticos.Dtos.Bitacora;

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
        public async Task<ActionResult<MovilDto>> PostMovil(CreateMovilRequestDto movilCreateDto, [FromQuery] int idUsuario)
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

             // Registramos Bitacora
            await RegistrarBitacora(idUsuario, 19, movil.IdMovil, "Movil", $"Creación de movil con patente {movil.Patente} e ID {movil.IdMovil}");

            // imprimimos en consola los id de los moviles
            System.Console.WriteLine(movil.IdMovil);

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
        public async Task<IActionResult> CambiaEstadoMovilPorPatente(string patente, int estado, [FromQuery] int idUsuario)
        {
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patente);

            if (movil == null)
            {
                return NotFound();
            }

            movil.Estado = estado;

            _context.Entry(movil).State = EntityState.Modified;

            // Registramos Bitacora
            await RegistrarBitacora(idUsuario, 26, movil.IdMovil, "Movil", $"Deshabilitación de movil con patente {patente}");

            await _context.SaveChangesAsync();

            return NoContent();
        }


        // PUT: api para modificar movil por patente, solo se modificara patente, marca, modelo, ejes, neumaticos, tipo movil
        // se envia con la url api/Movil/ModificarMovilPorPatente?patente=patente&marca=marca&modelo=modelo&ejes=ejes&cantidadNeumaticos=cantidadNeumaticos&tipoMovil=tipoMovil
        [HttpPut("ModificarMovilPorPatente")]
        public async Task<IActionResult> ModificarMovilPorPatente(string patenteActual, string patenteNueva, string marca, string modelo, int ejes, int cantidadNeumaticos, int tipoMovil, [FromQuery] int idUsuario)
        {
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patenteActual);

            if (movil == null)
            {
                return NotFound();
            }

            if(movil.Patente != patenteNueva)
            {
                // Registramos en bitacora
                await RegistrarBitacora(idUsuario, 20, movil.IdMovil, "Movil", $"Modificación de patente de movil de {patenteActual} a {patenteNueva}");
            }
            movil.Patente = patenteNueva;

            if(movil.Marca != marca)
            {
                // Registramos en bitacora
                await RegistrarBitacora(idUsuario, 21, movil.IdMovil, "Movil", $"Modificación de marca de movil {patenteNueva}");
            }
            movil.Marca = marca;

            if(movil.Modelo != modelo)
            {
                // Registramos en bitacora
                await RegistrarBitacora(idUsuario, 22, movil.IdMovil, "Movil", $"Modificación de modelo de movil {patenteNueva}");
            }
            movil.Modelo = modelo;

            if(movil.Ejes != ejes)
            {
                // Registramos en bitacora
                await RegistrarBitacora(idUsuario, 23, movil.IdMovil, "Movil", $"Modificación de ejes de movil {patenteNueva}");
            }
            movil.Ejes = ejes;

            if(movil.CantidadNeumaticos != cantidadNeumaticos)
            {
                // Registramos en bitacora
                await RegistrarBitacora(idUsuario, 25, movil.IdMovil, "Movil", $"Modificación de cantidad de neumáticos de movil {patenteNueva}");
            }
            movil.CantidadNeumaticos = cantidadNeumaticos;

            if(movil.TipoMovil != tipoMovil)
            {
                // Registramos en bitacora
                await RegistrarBitacora(idUsuario, 24, movil.IdMovil, "Movil", $"Modificación de tipo de movil {patenteNueva}");
            }
            movil.TipoMovil = tipoMovil;

            _context.Entry(movil).State = EntityState.Modified;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // funcion que comprueba si movil esta habilitado (1) o deshabilitado (2), retorna true o false
        // se envia con la url api/Movil/ComprobarEstadoMovil?patente=patente
        [HttpGet("ComprobarEstadoMovil")]
        public async Task<ActionResult<bool>> ComprobarEstadoMovil(string patente)
        {
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patente);

            if (movil == null)
            {
                return NotFound();
            }

            if (movil.Estado == 1)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        // funcion que registra en bitacora la modificacion de un movil
        private async Task RegistrarBitacora(int idUsuario, int codigo, int idObjeto, string tipoObjeto, string observacion)
        {
            var bitacoraDto = new CreateBitacoraRequestDto
            {
                ID_USUARIO = idUsuario,
                CODIGO = codigo,
                ID_OBJETO = idObjeto,
                FECHA = DateTime.Now,
                TIPO_OBJETO = tipoObjeto,
                OBSERVACION = observacion,
                ESTADO = 1,
            };

            var bitacora = _mapper.Map<Bitacora>(bitacoraDto);
            _context.Set<Bitacora>().Add(bitacora);
            await _context.SaveChangesAsync();
        }

        // GET: api/Movil/BuscarUsuariosPorPatente?query=j
        // Esta función busca moviles por su patente, devolviendo las primeras 4 patentes que coincidan con la búsqueda
        [HttpGet("BuscarMovilesPorPatente")]
        public async Task<ActionResult<IEnumerable<string>>> BuscarMovilesPorPatente(string query)
        {
            var patentes = await _context.Movils
                .Where(m => m.Patente.Contains(query))
                .Select(m => m.Patente)
                .Take(4)
                .ToListAsync();

            return patentes;
        }

        private bool MovilExists(int id)
        {
            return _context.Movils.Any(e => e.IdMovil == id);
        }
    }
}
