using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using api_control_neumaticos.Services;
using System.IO;
using SendingEmails;
using api_control_neumaticos.Services.IExcelService;

[Route("api/[controller]")]
[ApiController]
public class ReportesController : ControllerBase
{
    private readonly IExcelService _excelService;
    private readonly IEmailSender _emailService;

    public ReportesController(IExcelService excelService, IEmailSender emailService)
    {
        _excelService = excelService;
        _emailService = emailService;
    }

    /// <summary>
    /// Genera y descarga un Excel con toda la información de la base de datos.
    /// </summary>
    [HttpGet("descargar")]
    public async Task<IActionResult> DescargarExcel(DateTime? fromDate, DateTime? toDate)
    {
        try
        {
            var excelFile = await _excelService.GenerateExcelAsync(fromDate, toDate);
            var fileName = $"Reporte_CONTROL_NEUMATICOS_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            return File(excelFile, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error al generar el Excel: {ex.Message}");
        }
    }


    /// <summary>
    /// Genera un Excel y lo envía a un correo.
    /// </summary>
    [HttpPost("enviar-correo")]
    public async Task<IActionResult> EnviarExcelPorCorreo([FromBody] EnviarExcelRequest request, DateTime? fromDate, DateTime? toDate)
    {
        if (string.IsNullOrEmpty(request.Email))
            return BadRequest("Debe proporcionar un correo válido.");

        try
        {
            var excelFile = await _excelService.GenerateExcelAsync(fromDate, toDate);
            var fileName = $"Reporte_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            // Si deseas enviar un correo con adjunto
            await _emailService.SendEmailWithAttachmentAsync(
                request.Email,
                "Reporte de Datos",
                "Adjunto encontrarás el reporte en formato Excel.",
                excelFile,
                fileName
            );

            return Ok($"Excel enviado correctamente a {request.Email}");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error al enviar el correo: {ex.Message}");
        }
    }

  
    public class EnviarExcelRequest
    {
        public required string Email { get; set; }
    }
}


