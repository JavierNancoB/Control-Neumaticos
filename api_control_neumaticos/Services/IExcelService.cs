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
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
            using (var package = new ExcelPackage())
            {
                // Agregar cada tabla como una hoja en el Excel
                await AddSheetAsync(package, "Moviles", _context.Movils, fromDate, toDate);
                await AddSheetAsync(package, "Neumaticos", _context.Neumaticos, fromDate, toDate);
                await AddSheetAsync(package, "Usuarios", _context.Usuarios, fromDate, toDate);
                await AddSheetAsync(package, "Bodegas", _context.Bodegas, fromDate, toDate);
                await AddSheetAsync(package, "Alertas", _context.Alertas, fromDate, toDate);
                await AddSheetAsync(package, "Kilometros", _context.Kilometros, fromDate, toDate);
                await AddSheetAsync(package, "HistorialNeumatico", _context.HistorialesNeumaticos, fromDate, toDate);
                await AddSheetAsync(package, "Bitacoras", _context.Bitacoras, fromDate, toDate);

                return package.GetAsByteArray();
            }
        }

        private async Task AddSheetAsync<T>(ExcelPackage package, string sheetName, DbSet<T> dbSet, DateTime? fromDate, DateTime? toDate) where T : class
        {
            var sheet = package.Workbook.Worksheets.Add(sheetName);

            // Aplicar los filtros de fecha si son proporcionados
            IQueryable<T> query = dbSet.AsQueryable();

            if (fromDate.HasValue)
            {
                // Filtrar por fecha desde
                query = query.Where(x => EF.Property<DateTime>(x, "FechaIngreso") >= fromDate.Value);
            }

            if (toDate.HasValue)
            {
                // Filtrar por fecha hasta
                query = query.Where(x => EF.Property<DateTime>(x, "FechaIngreso") <= toDate.Value);
            }

            var data = await query.ToListAsync();
            if (data.Count == 0) return;

            var properties = typeof(T).GetProperties();
            for (int i = 0; i < properties.Length; i++)
            {
                sheet.Cells[1, i + 1].Value = properties[i].Name;
            }

            for (int row = 0; row < data.Count; row++)
            {
                for (int col = 0; col < properties.Length; col++)
                {
                    var value = properties[col].GetValue(data[row]);

                    // Reemplazar valores nulos o vacíos por texto adecuado
                    if (value == null || value.ToString() == "Sin Datos")
                    {
                        if (properties[col].Name == "MOVIL_ASIGNADO")
                        {
                            // Si no hay movil asignado
                            sheet.Cells[row + 2, col + 1].Value = "Sin Movil Asignado";
                        }
                        else if (properties[col].Name == "FECHA_SALIDA")
                        {
                            sheet.Cells[row + 2, col + 1].Value = "Sin Datos"; // Mantener para otras propiedades como Fecha de salida
                        }
                        else
                        {
                            sheet.Cells[row + 2, col + 1].Value = "Sin Datos"; // Valores predeterminados
                        }
                    }
                    else
                    {
                        // Si es un movil asignado y tiene patente, reemplazar por patente
                        if (properties[col].Name == "MOVIL_ASIGNADO" && value is Movil movil)
                        {
                            sheet.Cells[row + 2, col + 1].Value = movil.Patente ?? "Sin Movil Asignado"; // Mostrar patente si existe
                        }
                        else
                        {
                            sheet.Cells[row + 2, col + 1].Value = value.ToString();
                        }
                    }
                }
            }
        }
    }
}