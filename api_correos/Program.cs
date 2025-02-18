using api_correos.services;
using Microsoft.Extensions.Options;

var builder = WebApplication.CreateBuilder(args);

// Agregar OpenAPI
builder.Services.AddOpenApi();

// Cargar configuración desde appsettings.json
builder.Services.Configure<EmailSettings>(builder.Configuration.GetSection("EmailSettings"));

// Registrar el servicio de Email con inyección de configuración
builder.Services.AddScoped<EmailSender>();

// 🔹 ¡Faltaba esto! Agregar controladores para evitar el error
builder.Services.AddControllers(); 

var app = builder.Build();

// Configurar el pipeline de OpenAPI
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// 🔹 ¡Faltaba esto! Habilitar controladores en el pipeline
app.MapControllers();

app.Run();
