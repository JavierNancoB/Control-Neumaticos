using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using api_control_neumaticos.Models;
using Microsoft.EntityFrameworkCore;
using OfficeOpenXml;

namespace api_control_neumaticos.Services.IExcelService
{
    public class IExcelService
    {
        private readonly ControlNeumaticosContext _context;

        public IExcelService(ControlNeumaticosContext context)
        {
            _context = context;
        }

        public async Task<byte[]> GenerateExcelAsync(DateTime? fromDate, DateTime? toDate)
        {
            Console.WriteLine("Generando archivo Excel...");
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
            using (var package = new ExcelPackage())
            {
                Console.WriteLine("Agregando hojas...");
                await AddSheetAsync(package, "Moviles", _context.Movils, fromDate, toDate);
                await AddSheetAsync(package, "Neumaticos", _context.Neumaticos.Include(n => n.MOVIL_ASIGNADO), fromDate, toDate);
                await AddSheetAsync(package, "Usuarios", _context.Usuarios, fromDate, toDate);
                await AddSheetAsync(package, "Alertas", _context.Alertas
                    .Include(a => a.UsuarioAtendido)
                    .Include(a => a.UsuarioLeido), fromDate, toDate);
                await AddSheetAsync(package, "HistorialNeumatico", _context.HistorialesNeumaticos.Include(h => h.Neumatico), fromDate, toDate);
                await AddSheetAsync(package, "Bitacoras", _context.Bitacoras, fromDate, toDate);

                Console.WriteLine("Archivo Excel generado con éxito.");
                return package.GetAsByteArray();
            }
        }

        private string GetDescripcion<T>(int codigo, Dictionary<int, string> diccionario)
        {
            if (diccionario.TryGetValue(codigo, out var descripcion))
            {
                return descripcion;
            }
            return "Desconocido";  // Si el código no se encuentra en el diccionario
        }

        private async Task AddSheetAsync<T>(ExcelPackage package, string sheetName, IQueryable<T> query, DateTime? fromDate, DateTime? toDate) where T : class
        {
            var sheet = package.Workbook.Worksheets.Add(sheetName);
            Console.WriteLine($"Añadiendo hoja: {sheetName}");

            // Aplicar filtros de fecha
            // Filtrar solo para la entidad de Neumáticos
            if (sheetName == "Neumaticos" || sheetName == "Alertas")
            {
                if (fromDate.HasValue)
                {
                    query = query.Where(x => EF.Property<DateTime>(x, "FECHA_INGRESO").Date >= fromDate.Value.Date);
                    Console.WriteLine($"Filtrando desde {fromDate.Value.Date}");
                }

                if (toDate.HasValue)
                {
                    query = query.Where(x => EF.Property<DateTime>(x, "FECHA_INGRESO").Date <= toDate.Value.Date);
                    Console.WriteLine($"Filtrando hasta {toDate.Value.Date}");
                }
            }
            if (sheetName == "HistorialNeumatico" || sheetName == "Bitacoras")
            {
                if (fromDate.HasValue)
                {
                    query = query.Where(x => EF.Property<DateTime>(x, "FECHA").Date >= fromDate.Value.Date);
                    Console.WriteLine($"Filtrando desde {fromDate.Value.Date}");
                }

                if (toDate.HasValue)
                {
                    query = query.Where(x => EF.Property<DateTime>(x, "FECHA").Date <= toDate.Value.Date);
                    Console.WriteLine($"Filtrando hasta {toDate.Value.Date}");
                }
            }


            Console.WriteLine($"Filtrando entre {fromDate?.ToString()} y {toDate?.ToString()}");

            var data = await query.ToListAsync();
            Console.WriteLine($"Datos obtenidos: {data.Count} registros.");

            if (data.Count == 0)
            {
                Console.WriteLine("No se encontraron registros para esta hoja.");
                return;
            }

            var properties = typeof(T).GetProperties();

            // Ajuste de columnas por tabla
            if (sheetName == "Usuarios") properties = properties.Take(4).ToArray();
            if (sheetName == "Neumaticos") properties = properties.Where((p, index) => index != 5 && index != 6).ToArray();
            if (sheetName == "Moviles") properties = properties.Where((p, index) => index != 6 && index != 7).ToArray();

            // Agregar encabezados
            Console.WriteLine("Agregando encabezados...");
            for (int i = 0; i < properties.Length; i++)
            {
                sheet.Cells[1, i + 1].Value = properties[i].Name;
            }

            // Llenar datos en la hoja de Excel
            Console.WriteLine("Llenando datos...");
            for (int row = 0; row < data.Count; row++)
            {
                for (int col = 0; col < properties.Length; col++)
                {
                    var value = properties[col].GetValue(data[row]);

                    if (value == null || value.ToString() == "Sin Datos")
                    {
                        sheet.Cells[row + 2, col + 1].Value = "Sin Datos";
                        continue;
                    }

                    // Verificar y asignar descripciones usando diccionarios
                    if (properties[col].Name == "EstadoUsuario" && value is int estadoCodigo)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(estadoCodigo, Estado);
                    }
                    else if (properties[col].Name == "TIPO_NEUMATICO" && value is int tipoNeumaticoCodigo)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(tipoNeumaticoCodigo, TipoNeumatico);
                    }
                    else if (properties[col].Name == "EstadoNeumatico" && value is int estadoNeumaticoCodigo)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(estadoNeumaticoCodigo, Estado);
                    }
                    else if (properties[col].Name == "UBICAION" && value is int ubicacionCodigo)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(ubicacionCodigo, UbicacionNeumatico);
                    }
                    else if (properties[col].Name == "EstadoMovil" && value is int estadoMovilCodigo)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(estadoMovilCodigo, Estado);
                    }
                    else if (properties[col].Name == "TipoMovil" && value is int tipoMovilCodigo)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(tipoMovilCodigo, TipoMovil);
                    }
                    else if (properties[col].Name == "CODIGO_ALERTA" && value is int codigoAlerta)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(codigoAlerta, CodigoAlerta);
                    }
                    else if (properties[col].Name == "ESTADO_ALERTA" && value is int estadoAlerta)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(estadoAlerta, EstadoAlerta);
                    }
                    else if (properties[col].Name == "ESTADO" && value is int estado)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(estado, Estado);
                    }
                    else if (properties[col].Name == "Estado" && value is int estado2)
                    {
                        var bodega = await _context.Bodegas.FindAsync(estado2);
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(estado2, Estado);
                    }
                    else if (properties[col].Name == "CODIGO" && value is int idBitacora)
                    {
                        sheet.Cells[row + 2, col + 1].Value = GetDescripcion<int>(idBitacora, CodigoBitacora);
                    }
                    else
                    {
                        if (properties[col].Name == "MOVIL_ASIGNADO")
                        {
                            var movil = value as Movil;
                            sheet.Cells[row + 2, col + 1].Value = movil?.Patente ?? "Sin Movil Asignado";
                        }
                        else if (properties[col].Name == "UsuarioLeido" || properties[col].Name == "UsuarioAtendido" || properties[col].Name == "Usuario")
                        {
                            var usuario = value as Usuario;
                            sheet.Cells[row + 2, col + 1].Value = usuario != null
                                ? $"{usuario.Nombres} {usuario.Apellidos}"
                                : "Usuario no encontrado";
                        }
                        else if (properties[col].Name == "Neumatico")
                        {
                            var neumatico = value as Neumatico;
                            sheet.Cells[row + 2, col + 1].Value = neumatico?.CODIGO;
                        }
                        else
                        {
                            sheet.Cells[row + 2, col + 1].Value = value?.ToString() ?? "Sin Datos";
                        }
                    }
                }
            }
            Console.WriteLine($"Hoja {sheetName} procesada.");
        }

        // Diccionarios de descripciones
        private static readonly Dictionary<int, string> Estado = new Dictionary<int, string>
        {
            { 1, "HABILITADO" },
            { 2, "DESHABILITADO" },
            { 3, "BLOQUEADO" }
        };

        private static readonly Dictionary<int, string> EstadoAlerta = new Dictionary<int, string>
        {
            { 1, "PENDIENTE" },
            { 2, "LEIDA" },
            { 3, "ATENDIDA" }
        };

        private static readonly Dictionary<int, string> TipoNeumatico = new Dictionary<int, string>
        {
            { 1, "Neumático de Tracción" },
            { 2, "Neumático de Dirección" },
            { 3, "Repuesto" },
            { 4, "Bodega" }
        };

        private static readonly Dictionary<int, string> TipoMovil = new Dictionary<int, string>
        {
            { 1, "4X2" },
            { 2, "6X4" },
            { 3, "RAMPLA" }
        };

        private static readonly Dictionary<int, string> CodigoAlerta = new Dictionary<int, string>
        {
            { 1, "MÁS DE 2 VULCANIZACIONES" },
            { 2, "MÁS DE 100.000 KM" },
            { 3, "DESHABILITAR POR DESGASTE" }
        };

        private static readonly Dictionary<int, string> UbicacionNeumatico = new Dictionary<int, string>
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

        private static readonly Dictionary<int, string> CodigoBitacora = new Dictionary<int, string>
        {
            { 1, "INGRESO DE NEUMÁTICOS" },
            { 2, "DESHABILITACIÓN DE NEUMÁTICOS" },
            { 3, "CAMBIO DE MÓVIL ASIGNADO" },
            { 4, "ROTACIÓN NEUMÁTICO" },
            { 5, "TRANSICIÓN DE TRACCIONAL A DIRECCIONAL" },
            { 6, "TRANSICIÓN DE DIRECCIONAL A TRACCIONAL" },
            { 7, "CAMBIO DE FECHA DE INGRESO" },
            { 8, "CAMBIO MANUAL DE KILOMETRAJE TOTAL" },
            { 9, "CAMBIO AUTOMÁTICO DE KILOMETRAJE TOTAL" },
            { 10, "CAMBIO DE PRESIÓN DE AIRE" },
            { 11, "PINCHAZO NEUMÁTICO" },
            { 12, "INGRESO DE USUARIO" },
            { 13, "EDICIÓN DE NOMBRES" },
            { 14, "EDICIÓN DE APELLIDOS" },
            { 15, "EDICIÓN DE PERFIL" },
            { 16, "CAMBIO DE CORREO" },
            { 17, "CAMBIO DE CONTRASEÑA" },
            { 18, "DESHABILITACIÓN DE USUARIOS" },
            { 19, "INGRESO DE MÓVIL" },
            { 20, "MODIFICACIÓN DE PATENTE DE MÓVIL" },
            { 21, "MODIFICACIÓN DE MARCA DE MÓVIL" },
            { 22, "MODIFICACIÓN DE MODELO DE MÓVIL" },
            { 23, "MODIFICACIÓN DE EJES DE MÓVIL" },
            { 24, "MODIFICACIÓN DE CÓDIGO DE MÓVIL" },
            { 25, "MODIFICACIÓN DE CANTIDAD DE RUEDAS" },
            { 26, "DESHABILITACIÓN DE MÓVIL" }
        };
    }
}
