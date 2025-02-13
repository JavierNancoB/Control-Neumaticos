using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using api_control_neumaticos.Models;  // Asegúrate de que esta sea la referencia correcta
using api_control_neumaticos.Dtos.Neumaticos;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using api_control_neumaticos.Dtos.HistorialNeumatico;
using api_control_neumaticos.Dtos.Bitacora;


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

        [HttpPost]
        public async Task<ActionResult<NeumaticosDto>> PostNeumaticoConHistorial(
            [FromBody] CreateNeumaticoRequestDto createNeumaticoDto,
            [FromQuery] int idUsuario)
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

            // Verificar si el móvil existe, en caso de que sea null, ubicación será 1
            if (createNeumaticoDto.ID_MOVIL != null)
            {
                var movil = await _context.Movils.FindAsync(createNeumaticoDto.ID_MOVIL);
            }
            else
            {
                // en caso de que no haya movil se asigna a la bodega
                createNeumaticoDto.UBICACION = 1;
                createNeumaticoDto.TIPO_NEUMATICO = 4;
            }

            // Tipo de neumático solo puede ser 1,2,3,4.
            if (createNeumaticoDto.TIPO_NEUMATICO < 1 || createNeumaticoDto.TIPO_NEUMATICO > 4)
            {
                return BadRequest("El tipo de neumático no es válido.");
            }

            // En caso de que haya móvil y se envíe la ubicación 1, se cambia a 2
            if (createNeumaticoDto.UBICACION == 1 && createNeumaticoDto.ID_MOVIL != null)
            {
                createNeumaticoDto.UBICACION = 2; // Cambiar ubicación si es necesario
            }

            // Verificar si ya existe un neumático en la misma ubicación para el mismo vehículo
            if (createNeumaticoDto.ID_MOVIL != null)
            {
                var existeNeumatico = await _context.Neumaticos
                    .AnyAsync(n => n.ID_MOVIL == createNeumaticoDto.ID_MOVIL && n.UBICACION == createNeumaticoDto.UBICACION);
                if (existeNeumatico)
                {
                    return Conflict("Ya existe un neumático en esta ubicación para el mismo vehículo.");
                }
            }

            // Mapear y crear el neumático
            var neumatico = _mapper.Map<Neumatico>(createNeumaticoDto);
            _context.Neumaticos.Add(neumatico);
            await _context.SaveChangesAsync();

            // Crear historial de neumático
            var historialDto = new CreateHistorialNeumaticoRequestDto
            {
                IDNeumatico = neumatico.ID_NEUMATICO,
                IDUsuario = idUsuario,
                CODIGO = 1,
                FECHA = DateTime.Now,
                ESTADO = 1,
                OBSERVACION = $"Creación del neumático en el sistema con código: {neumatico.CODIGO}",
            };

            var historial = _mapper.Map<HistorialNeumatico>(historialDto);
            _context.Set<HistorialNeumatico>().Add(historial);

            var bitacoraDto = new CreateBitacoraRequestDto
            {
                ID_USUARIO = idUsuario,
                CODIGO = 1,
                ID_OBJETO = neumatico.ID_NEUMATICO,
                FECHA = DateTime.Now,
                TIPO_OBJETO = "Neumatico",
                OBSERVACION = $"Creación del neumático en el sistema con código: {neumatico.CODIGO}",
                ESTADO = 1,
            };

            var bitacora = _mapper.Map<Bitacora>(bitacoraDto);
            _context.Set<Bitacora>().Add(bitacora);

            await _context.SaveChangesAsync();
            // Mapear el modelo de neumático al DTO y retornar
            var neumaticoDto = _mapper.Map<NeumaticosDto>(neumatico);
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
        // fecha salida se cambia a hoy si estado es 2, en caso de ser 1 se pone null
        [HttpPut("ModificarEstadoPorCodigo")]
        public async Task<IActionResult> ModificarEstadoPorCodigo(
            [FromQuery] int idUsuario, 
            [FromQuery] int codigo, 
            [FromQuery] int estado,
            [FromQuery] int confirmacionMovil) // Parámetro para confirmar si se debe dejar como null la ID_MOVIL
        {
            var neumatico = await _context.Neumaticos.FirstOrDefaultAsync(n => n.CODIGO == codigo);

            if (neumatico == null)
            {
                return NotFound("Neumático no encontrado.");
            }

            // Actualizar estado
            neumatico.ESTADO = estado;
            if (estado == 2)
            {
                neumatico.FECHA_SALIDA = DateTime.Now;

                // Verifica la confirmación antes de dejar como null la ID_MOVIL
                if (confirmacionMovil == 1) // 1 para confirmar que la ID_MOVIL se debe dejar como null
                {
                    neumatico.ID_MOVIL = null;
                    neumatico.UBICACION = 1;
                }
            }
            else if (estado == 1)
            {
                neumatico.FECHA_SALIDA = null;
            }

            try
            {
                await _context.SaveChangesAsync();
                
                // Crear historial solo si el estado es 2 (deshabilitado)
                if (estado == 2)
                {
                    var historialDto = new CreateHistorialNeumaticoRequestDto
                    {
                        IDNeumatico = neumatico.ID_NEUMATICO,
                        IDUsuario = idUsuario,
                        CODIGO = 2, // Código 2 para indicar deshabilitación
                        FECHA = DateTime.Now,
                        ESTADO = 1,
                        OBSERVACION = $"Neumático con código {neumatico.CODIGO} deshabilitado por el usuario {idUsuario}",
                    };

                    var historial = _mapper.Map<HistorialNeumatico>(historialDto);
                    _context.Set<HistorialNeumatico>().Add(historial);

                    var bitacoraDto = new CreateBitacoraRequestDto
                    {
                        ID_USUARIO = idUsuario,
                        CODIGO = 2,
                        ID_OBJETO = neumatico.ID_NEUMATICO,
                        FECHA = DateTime.Now,
                        TIPO_OBJETO = "Neumatico",
                        OBSERVACION = $"Neumático con código {neumatico.CODIGO} deshabilitado por el usuario {idUsuario}",
                        ESTADO = 1,
                    };

                    var bitacora = _mapper.Map<Bitacora>(bitacoraDto);
                    _context.Set<Bitacora>().Add(bitacora);

                    await _context.SaveChangesAsync();
                }

            }
            catch (DbUpdateConcurrencyException)
            {
                return Conflict("Hubo un problema al actualizar el neumático.");
            }

            return NoContent();
        }

        [HttpPut("ModificarNeumaticoPorCodigo")]
        public async Task<IActionResult> ModificarNeumaticoPorCodigo(
            int codigo, 
            int ubicacion, 
            string? patente, 
            DateTime fechaIngreso, 
            int kmTotal, 
            int tipoNeumatico,
            [FromQuery] int idUsuario) 
        {
            Console.WriteLine($"Iniciando ModificarNeumaticoPorCodigo con código: {codigo}, patente: {patente}, ubicacion: {ubicacion}, fechaIngreso: {fechaIngreso}, kmTotal: {kmTotal}, tipoNeumatico: {tipoNeumatico}, idUsuario: {idUsuario}");

            var neumatico = await _context.Neumaticos.FirstOrDefaultAsync(n => n.CODIGO == codigo);
            if (neumatico == null)
            {
                Console.WriteLine($"Neumático con código {codigo} no encontrado.");
                return NotFound();
            }

            var mismovehiculo = true;
            var cambios = new List<string>(); 
            var diccionarioUbicaciones = new Dictionary<int, string>
            {
                { 1, "BODEGA" },
                { 2, "DIRECCIONAL IZQUIERDA" },
                { 3, "DIRECCIONAL DERECHO" },
                { 4, "PRIMER TRACCIONAL IZQUIERDO INTERNO" },
                { 5, "PRIMER TRACCIONAL IZQUIERDO EXTERNO" },
                { 6, "PRIMER TRACCIONAL DERECHO INTERNO" },
                { 7, "PRIMER TRACCIONAL DERECHO EXTERNO" },
                { 8, "SEGUNDO TRACCIONAL IZQUIERDO INTERNO" },
                { 9, "SEGUNDO TRACCIONAL IZQUIERDO EXTERNO" },
                { 10, "SEGUNDO TRACCIONAL DERECHO INTERNO" },
                { 11, "SEGUNDO TRACCIONAL DERECHO EXTERNO" },
                { 12, "TERCER TRACCIONAL IZQUIERDO INTERNO" },
                { 13, "TERCER TRACCIONAL IZQUIERDO EXTERNO" },
                { 14, "TERCER TRACCIONAL DERECHO INTERNO" },
                { 15, "TERCER TRACCIONAL DERECHO EXTERNO" },
                { 16, "REPUESTO" }
            };

            // Verificar cambios en la patente
            if (!string.IsNullOrEmpty(patente))
            {
                Console.WriteLine($"Verificando patente: {patente}");
                var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patente);
                if (movil == null)
                {
                    Console.WriteLine($"Móvil con patente {patente} no encontrado.");
                    return NotFound("Móvil no encontrado con esa patente.");
                }

                if (neumatico.ID_MOVIL != movil.IdMovil)
                {
                    mismovehiculo = false;
                    Console.WriteLine($"Se asigna un nuevo móvil: {movil.IdMovil}");
                    await RegistrarHistorial(neumatico, idUsuario, 3, $"Móvil asignado: {movil.IdMovil}");   
                    await RegistrarBitacora(idUsuario, 3, neumatico.ID_NEUMATICO, "Neumatico", $"Móvil asignado: {movil.IdMovil}");                     
                }

                neumatico.ID_MOVIL = movil.IdMovil;
                neumatico.UBICACION = ubicacion;
            }
            else
            {
                Console.WriteLine("No se proporciona patente, asignando a la bodega.");
                ubicacion = 1;
                neumatico.ID_MOVIL = null;
            }

            // Verificar si ya hay un neumático en la misma ubicación
            if (neumatico.ID_MOVIL.HasValue && ubicacion != 1)
            {
                var existeNeumatico = await _context.Neumaticos
                .AnyAsync(n => n.ID_MOVIL == neumatico.ID_MOVIL && n.UBICACION == ubicacion && n.CODIGO != codigo);

                if (existeNeumatico)
                {
                    Console.WriteLine($"Conflicto: Ya existe un neumático en la ubicación {ubicacion} para el vehículo con código {codigo}.");
                    return Conflict("Ya existe un neumático en esta ubicación para el mismo vehículo.");
                }
            }

            // Verificar y registrar cambios en otros campos
            if (neumatico.UBICACION != ubicacion && mismovehiculo)
            {
                Console.WriteLine($"Cambio de ubicación: {neumatico.UBICACION} -> {ubicacion}");
                neumatico.UBICACION = ubicacion;
                if (ubicacion == 1) ubicacion = 2;
                await RegistrarHistorial(neumatico, idUsuario, 4, $"Rotación dentro del mismo vehiculo ubicación cambiada a {diccionarioUbicaciones[ubicacion]}");
                await RegistrarBitacora(idUsuario, 4, neumatico.ID_NEUMATICO, "Neumatico", $"Rotación dentro del mismo vehiculo ubicación cambiada a {diccionarioUbicaciones[ubicacion]}");
            }

            if (neumatico.FECHA_INGRESO != fechaIngreso)
            {
                Console.WriteLine($"Cambio de fecha de ingreso: {neumatico.FECHA_INGRESO} -> {fechaIngreso}");
                neumatico.FECHA_INGRESO = fechaIngreso;
                await RegistrarHistorial(neumatico, idUsuario, 7, $"Fecha de ingreso cambiada a {fechaIngreso}");
                await RegistrarBitacora(idUsuario, 7, neumatico.ID_NEUMATICO, "Neumatico", $"Fecha de ingreso cambiada a {fechaIngreso}");
            }

            if (neumatico.KM_TOTAL != kmTotal)
            {
                Console.WriteLine($"Cambio de kilómetros totales: {neumatico.KM_TOTAL} -> {kmTotal}");
                neumatico.KM_TOTAL = kmTotal;
                await RegistrarHistorial(neumatico, idUsuario, 8, $"Kilómetros totales cambiados a {kmTotal}");
                await RegistrarBitacora(idUsuario, 8, neumatico.ID_NEUMATICO, "Neumatico", $"Kilómetros totales cambiados a {kmTotal}");
            }

            if (neumatico.TIPO_NEUMATICO != tipoNeumatico)
            {
                Console.WriteLine($"Cambio de tipo de neumático: {neumatico.TIPO_NEUMATICO} -> {tipoNeumatico}");
                if (tipoNeumatico == 2 && neumatico.TIPO_NEUMATICO != 2)
                {
                    await RegistrarHistorial(neumatico, idUsuario, 5, "Transición a Direccional");
                    await RegistrarBitacora(idUsuario, 5, neumatico.ID_NEUMATICO, "Neumatico", "Transición a Direccional");
                }
                else if (tipoNeumatico != 2 && neumatico.TIPO_NEUMATICO == 2)
                {
                    await RegistrarHistorial(neumatico, idUsuario, 6, "Transición a Traccional");
                    await RegistrarBitacora(idUsuario, 6, neumatico.ID_NEUMATICO, "Neumatico", "Transición a Traccional");
                }
                else if(tipoNeumatico == 3)
                {
                    await RegistrarHistorial(neumatico, idUsuario, 9, "Transición a Repuesto");
                    await RegistrarBitacora(idUsuario, 9, neumatico.ID_NEUMATICO, "Neumatico", "Transición a Repuesto");
                }
                else if(tipoNeumatico == 4)
                {
                    await RegistrarHistorial(neumatico, idUsuario, 3, "Transición a bodega");
                    await RegistrarBitacora(idUsuario, 3, neumatico.ID_NEUMATICO, "Neumatico", "Se guarda neumático en bodega");
                }
                neumatico.TIPO_NEUMATICO = tipoNeumatico;
            }

            if(tipoNeumatico != 4 && neumatico.UBICACION == 1)
            {
                Console.WriteLine("Asignando tipo neumático a bodega por ubicación 1.");
                tipoNeumatico = 4;
            }

            // Si hubo cambios, los registramos en el historial
            if (cambios.Any())
            {
                foreach (var cambio in cambios)
                {
                    Console.WriteLine($"Registrando cambio en historial: {cambio}");
                    var historialDto = new CreateHistorialNeumaticoRequestDto
                    {
                        IDNeumatico = neumatico.ID_NEUMATICO,
                        IDUsuario = idUsuario,
                        CODIGO = 2, // Suponiendo que 2 es para modificaciones
                        FECHA = DateTime.Now,
                        ESTADO = 1,
                        OBSERVACION = cambio,
                    };

                    var historial = _mapper.Map<HistorialNeumatico>(historialDto);
                    _context.Set<HistorialNeumatico>().Add(historial);
                }
                await _context.SaveChangesAsync();
            }

            // Guardamos los cambios en el neumático
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                Console.WriteLine("Error de concurrencia al guardar cambios.");
                return Conflict("Hubo un problema al intentar actualizar el neumático. Puede haber un conflicto de concurrencia.");
            }

            Console.WriteLine("Proceso completado correctamente.");
            return NoContent();
        }

        // Método auxiliar para registrar cambios en el historial
        private async Task RegistrarHistorial(Neumatico neumatico, int idUsuario, int codigo, string observacion)
        {
            var historialDto = new CreateHistorialNeumaticoRequestDto
            {
                IDNeumatico = neumatico.ID_NEUMATICO,
                IDUsuario = idUsuario,
                CODIGO = codigo, // Código dinámico según el cambio
                FECHA = DateTime.Now,
                ESTADO = 1,
                OBSERVACION = observacion,
            };

            var historial = _mapper.Map<HistorialNeumatico>(historialDto);
            _context.Set<HistorialNeumatico>().Add(historial);
            await _context.SaveChangesAsync();
        }

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

        // POST: api/Neumaticos/verificarSiNeumaticoHabilitado
        [HttpPost("verificarSiNeumaticoHabilitado")]
        public async Task<ActionResult<bool>> verificarSiNeumaticoHabilitado(int codigo)
        {
            var neumatico = await _context.Neumaticos.FirstOrDefaultAsync(n => n.CODIGO == codigo);

            if (neumatico != null && neumatico.ESTADO == 1)
            {
                return Ok(true);
            }

            return Ok(false);
        }

        // POST: api/Neumaticos/verificarSiNeumaticoExiste
        [HttpPost("verificarSiNeumaticoExiste")]
        public async Task<ActionResult<bool>> verificarSiNeumaticoExiste(int codigo)
        {
            var neumatico = await _context.Neumaticos.FirstOrDefaultAsync(n => n.CODIGO == codigo);

            if (neumatico != null)
            {
                return Ok(true);
            }

            return Ok(false);
        }
        
        // POST: api/Neumaticos/verificarSiPosicioneEsUnicaConPatente
        // POST: api/Neumaticos/verificarSiPosicioneEsUnicaConPatente
        [HttpPost("verificarSiPosicioneEsUnicaConPatente")]
        public async Task<ActionResult<bool>> verificarSiPosicioneEsUnicaConPatente(string? patente, int posicion)
        {
            Console.WriteLine($"Petición recibida - Patente: {patente}, Posición: {posicion}");

            if (string.IsNullOrEmpty(patente))
            {
                Console.WriteLine("Patente es null o vacía, devolviendo true");
                return Ok(true);
            }

            // Buscar el móvil por patente
            var movil = await _context.Movils.FirstOrDefaultAsync(m => m.Patente == patente);
            if (movil == null)
            {
                Console.WriteLine("Móvil no encontrado con esa patente, devolviendo true");
                return Ok(true);
            }

            // Si la posición es 16, se permite repetirla
            if (posicion == 16)
            {
                Console.WriteLine("Posición 16, se permite repetir, devolviendo true");
                return Ok(true);
            }

            // Buscar si la posición ya está ocupada en ese móvil
            var neumatico = await _context.Neumaticos.FirstOrDefaultAsync(n => n.ID_MOVIL == movil.IdMovil && n.UBICACION == posicion);

            if (neumatico == null)
            {
                Console.WriteLine("No se encontró un neumático en esa posición, devolviendo true");
                return Ok(true);
            }

            Console.WriteLine("Posición ya está ocupada, devolviendo false");
            return Ok(false);
        }
    }
}
