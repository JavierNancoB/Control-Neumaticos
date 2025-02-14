using Microsoft.AspNetCore.Mvc;
using api_control_neumaticos.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;
using System.Runtime.InteropServices;
using System.Security;

namespace api_control_neumaticos.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BitacoraController : ControllerBase
    {
        private readonly ControlNeumaticosContext _context;

        public BitacoraController(ControlNeumaticosContext context)
        {
            _context = context;
        }

        private const string Neumatico = "Neumatico";
        private const string Movil = "Movil";
        private const string Usuario = "Usuario";

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Bitacora>>> GetBitacoras()
        {
            var bitacoras = await _context.Set<Bitacora>().ToListAsync();
            return Ok(bitacoras);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Bitacora>> GetBitacora(int id)
        {
            var bitacora = await _context.Set<Bitacora>().FindAsync(id);
            if (bitacora == null)
            {
                return NotFound();
            }
            return Ok(bitacora);
        }

        [HttpPost]
        public async Task<ActionResult<Bitacora>> CreateBitacora(Bitacora bitacora)
        {
            // Validar que TIPO_OBJETO sea uno de los valores permitidos
            if (bitacora.TIPO_OBJETO != Neumatico && bitacora.TIPO_OBJETO != Movil && bitacora.TIPO_OBJETO != Usuario)
            {
                return BadRequest("El tipo de objeto no es válido. Debe ser 'Neumatico', 'Movil' o 'Usuario'.");
            }

            // Validar que el ID_OBJETO sea válido según el tipo de objeto
            if (bitacora.TIPO_OBJETO == Neumatico && !await _context.Neumaticos.AnyAsync(n => n.ID_NEUMATICO == bitacora.ID_OBJETO))
            {
                return BadRequest("El Neumático con el ID especificado no existe.");
            }
            if (bitacora.TIPO_OBJETO == Movil && !await _context.Movils.AnyAsync(m => m.IdMovil == bitacora.ID_OBJETO))
            {
                return BadRequest("El Móvil con el ID especificado no existe.");
            }
            if (bitacora.TIPO_OBJETO == Usuario && !await _context.Usuarios.AnyAsync(u => u.IdUsuario == bitacora.ID_OBJETO))
            {
                return BadRequest("El Usuario con el ID especificado no existe.");
            }

            bitacora.FECHA = DateTime.Now;
            _context.Set<Bitacora>().Add(bitacora);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetBitacora), new { id = bitacora.ID }, bitacora);
        }
        //Funcion que llamaremos cuando queremos registrar los neutmaticos que se han comprobado en un movil
        [HttpPost("RegistraComprobarNeumaticoEnMovil")]
        public async Task<ActionResult<Bitacora>> RegistraComprobarNeumaticoEnMovil(int idMovil, int exito, string observacion,int idUsuario)
        {
            //El usuario en el front vea si existen tales neumatico en tal movil
            //EL objetivo de esta funcion es que ante las 2 situaciones posibles, se registre en la bitacora
            //1. Que los neumaticos se hayan comprobado en el movil con exito.
            //2. Que los neumaticos no se encuentren en el movil registrado, en este caso se registra en la bitacora los neumaticos que no se encuentran en el movil
            //Validar que el movil exista
            Bitacora bitacora = new Bitacora();
            if (!await _context.Movils.AnyAsync(m => m.IdMovil == idMovil))
            {
                return BadRequest($"El Móvil con el ID especificado ({idMovil}) no existe.");
            }

            if (!await _context.Usuarios.AnyAsync(u => u.IdUsuario == idUsuario))
            {
                return BadRequest($"El Usuario con el ID especificado ({idUsuario}) no existe.");
            }

            //En caso de que los neumaticos se hayan comprobado con exito
            if (exito == 1)
            {
                bitacora.FECHA = DateTime.Now;
                bitacora.OBSERVACION = "Se han comprobado los neumaticos en el movil con exito";
                bitacora.TIPO_OBJETO = "Movil";
                bitacora.ID_OBJETO = idMovil;
                bitacora.CODIGO = 27;
                bitacora.ID_USUARIO = idUsuario;
                _context.Set<Bitacora>().Add(bitacora);
                await _context.SaveChangesAsync();
                return CreatedAtAction(nameof(GetBitacora), new { id = bitacora.ID }, bitacora); //Retornamos la bitacora
            }

            if(exito == 0)
            {
                //En caso de que los neumaticos no se encuentren en el movil
                bitacora.FECHA = DateTime.Now;
                bitacora.OBSERVACION = observacion;
                bitacora.TIPO_OBJETO = "Movil";
                bitacora.ID_OBJETO = idMovil;
                bitacora.CODIGO = 27;
                bitacora.ID_USUARIO = idUsuario;
                _context.Set<Bitacora>().Add(bitacora);
                await _context.SaveChangesAsync();
                return CreatedAtAction(nameof(GetBitacora), new { id = bitacora.ID }, bitacora); //Retornamos la bitacora
            }

            return BadRequest("Error al registrar la bitacora");

        }
    }
}
