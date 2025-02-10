using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using api_control_neumaticos.Services;
using System.IO;
using SendingEmails;
using api_control_neumaticos.Services.IExcelService;
using Microsoft.Extensions.Logging;
using System.Text;  // Para logging

[Route("api/[controller]")]
[ApiController]
public class ReportesController : ControllerBase
{
    private readonly IExcelService _excelService;
    private readonly IEmailSender _emailService;
    private readonly ILogger<ReportesController> _logger;  // Agregar logger

    public ReportesController(IExcelService excelService, IEmailSender emailService, ILogger<ReportesController> logger)
    {
        _excelService = excelService;
        _emailService = emailService;
        _logger = logger;  // Inyectar logger
    }

    [HttpGet("descargar")]
    public async Task<IActionResult> DescargarExcel(DateTime? fromDate, DateTime? toDate)
    {
        if (fromDate.HasValue && toDate.HasValue && fromDate.Value > toDate.Value)
        {
            _logger.LogWarning("La fecha de inicio no puede ser posterior a la fecha de fin.");
            return BadRequest("La fecha de inicio no puede ser posterior a la fecha de fin.");
        }

        try
        {
            _logger.LogInformation($"Generando Excel con fecha de inicio: {fromDate?.ToString("yyyy-MM-dd") ?? "No especificada"} y fecha de fin: {toDate?.ToString("yyyy-MM-dd") ?? "No especificada"}");

            var excelFile = await _excelService.GenerateExcelAsync(fromDate, toDate);
            var fileName = $"Reporte_CONTROL_NEUMATICOS_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            _logger.LogInformation($"Excel generado exitosamente: {fileName}");
            _logger.LogInformation($"Tamaño del archivo generado: {excelFile.Length} bytes");

            return File(excelFile, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
        }
        catch (Exception ex)
        {
            _logger.LogError($"Error al generar el Excel: {ex.Message} - {ex.StackTrace}");
            return StatusCode(500, $"Error al generar el Excel: {ex.Message}");
        }
    }
    /*
    [HttpPost("enviar-correo")]
    public async Task<IActionResult> EnviarExcelPorCorreo([FromBody] EnviarExcelRequest request, DateTime? fromDate, DateTime? toDate)
    {
        if (string.IsNullOrEmpty(request.Email))
        {
            _logger.LogWarning("El correo proporcionado no es válido.");
            return BadRequest("Debe proporcionar un correo válido.");
        }

        try
        {
            _logger.LogInformation($"Generando Excel para enviar a: {request.Email} con fechas de inicio: {fromDate?.ToString("yyyy-MM-dd") ?? "No especificada"} y fin: {toDate?.ToString("yyyy-MM-dd") ?? "No especificada"}");

            var excelFile = await _excelService.GenerateExcelAsync(fromDate, toDate);
            var fileName = $"Reporte_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            _logger.LogInformation($"Archivo Excel generado para envío: {fileName}");
            _logger.LogInformation($"Tamaño del archivo generado: {excelFile.Length} bytes");

            // Log adicional antes de enviar el correo
            _logger.LogInformation($"Iniciando proceso de envío de correo a {request.Email}...");
            _logger.LogInformation($"Archivo Excel que se va a enviar: {fileName}, tamaño: {excelFile.Length} bytes");

            _logger.LogInformation($"Iniciando el proceso de envío de correo a {request.Email} con el archivo {fileName} de tamaño {excelFile.Length} bytes");

            // Log para asegurarnos de que el archivo Excel no está vacío o corrupto
            if (excelFile == null || excelFile.Length == 0)
            {
                _logger.LogError("El archivo Excel está vacío o no se generó correctamente.");
                return StatusCode(500, "El archivo Excel no se generó correctamente.");
            }

            try
            {
                // Log para ver cómo está el contenido del archivo antes de enviarlo
                _logger.LogInformation("Se va a enviar el archivo adjunto al correo...");
                
                // Intentamos enviar el correo con el archivo adjunto
                await _emailService.SendEmailWithAttachmentAsync(
                    request.Email,
                    "Reporte de Datos",
                    "Adjunto encontrarás el reporte en formato Excel.",
                    excelFile,
                    fileName
                );

                // Si llegamos aquí, el correo se envió correctamente
                _logger.LogInformation($"Correo enviado exitosamente a {request.Email} con el archivo adjunto {fileName}");
                return Ok($"Excel enviado correctamente a {request.Email}");
            }
            catch (Exception ex)
            {
                // Log adicional en caso de fallo al enviar el correo
                _logger.LogError($"Error al enviar el correo a {request.Email}: {ex.Message} - {ex.StackTrace}");
                return StatusCode(500, $"Error al enviar el correo: {ex.Message}");
            }
        }
        catch (Exception ex)
        {
            // Log adicional en caso de fallo al enviar el correo
            _logger.LogError($"Error al enviar el correo a {request.Email}: {ex.Message} - {ex.StackTrace}");
            return StatusCode(500, $"Error al enviar el correo: {ex.Message}");
        }
    }*/
    [HttpPost("enviar-correo")]
    public async Task<IActionResult> EnviarExcelPorCorreo([FromBody] EnviarExcelRequest request, DateTime? fromDate, DateTime? toDate)
    {
        if (string.IsNullOrEmpty(request.Email))
        {
            _logger.LogWarning("El correo proporcionado no es válido.");
            return BadRequest("Debe proporcionar un correo válido.");
        }

        try
        {
            _logger.LogInformation($"Generando Excel para enviar a: {request.Email} con fechas de inicio: {fromDate?.ToString("yyyy-MM-dd") ?? "No especificada"} y fin: {toDate?.ToString("yyyy-MM-dd") ?? "No especificada"}");

            var excelFile = await _excelService.GenerateExcelAsync(fromDate, toDate);
            var fileName = $"Reporte_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            _logger.LogInformation($"Archivo Excel generado para envío: {fileName}");
            _logger.LogInformation($"Tamaño del archivo generado: {excelFile.Length} bytes");

            // Verificación de que el archivo no está vacío
            if (excelFile.Length == 0)
            {
                _logger.LogError("El archivo Excel generado está vacío.");
                return StatusCode(500, "El archivo generado está vacío.");
            }

            // Log para revisar el contenido del archivo antes de enviarlo
            try
            {
                _logger.LogInformation("Revisando el contenido del archivo adjunto...");
                string fileContent = string.Empty;

                // Intentamos leer las primeras líneas del archivo (para verificar si el contenido parece válido)
                using (var reader = new MemoryStream(excelFile))
                {
                    // Si es un archivo Excel, lo tratamos como un archivo binario, pero por si es de texto:
                    reader.Position = 0;
                    var buffer = new byte[Math.Min(100, excelFile.Length)]; // Leemos solo los primeros 100 bytes
                    reader.Read(buffer, 0, buffer.Length);
                    fileContent = System.Text.Encoding.UTF8.GetString(buffer);

                    _logger.LogInformation($"Contenido del archivo (primeros 100 bytes): {fileContent}");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error al leer el contenido del archivo: {ex.Message}");
                throw;
            }

            _logger.LogInformation("Enviando correo con archivo adjunto...");

            // Intentamos enviar el correo con el archivo adjunto
            await _emailService.SendEmailWithAttachmentAsync(
                request.Email,
                "Reporte de Datos",
                "Adjunto encontrarás el reporte en formato Excel.",
                excelFile,
                fileName
            );

            _logger.LogInformation($"Correo enviado correctamente a {request.Email}");
            return Ok($"Excel enviado correctamente a {request.Email}");
        }
        catch (Exception ex)
        {
            _logger.LogError($"Error al enviar el correo con el archivo adjunto: {ex.Message} - StackTrace: {ex.StackTrace}");

            // Verificar si el error es de tipo SmtpException y extraer detalles adicionales
            if (ex is System.Net.Mail.SmtpException smtpEx)
            {
                _logger.LogError($"Detalles SMTP: {smtpEx.StatusCode}, {smtpEx.Message}");
            }

            return StatusCode(500, $"Error al enviar el correo: {ex.Message}");
        }
    }


    public class EnviarExcelRequest
    {
        public required string Email { get; set; }
    }
}
