using api_correos.services;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;

var builder = WebApplication.CreateBuilder(args);

// Configurar Kestrel para escuchar en todas las IPs en el puerto 5182
builder.WebHost.ConfigureKestrel(options =>
{
    options.ListenAnyIP(5182); // Acepta conexiones en todas las interfaces de red
});

// Agregar OpenAPI
builder.Services.AddOpenApi();

// Cargar configuración desde appsettings.json
builder.Services.Configure<EmailSettings>(builder.Configuration.GetSection("EmailSettings"));

// Registrar el servicio de Email con inyección de configuración
builder.Services.AddScoped<EmailSender>();

// 🔹 Agregar CORS para aceptar cualquier origen
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader());
});

// 🔹 Agregar controladores
builder.Services.AddControllers();

var app = builder.Build();

// Aplicar CORS
app.UseCors("AllowAll");

// Configurar OpenAPI solo en desarrollo
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// Habilitar controladores
app.MapControllers();

app.Run();
