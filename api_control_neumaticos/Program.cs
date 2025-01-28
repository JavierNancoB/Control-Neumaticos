using api_control_neumaticos.Models;
using api_control_neumaticos.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Microsoft.Extensions.Options;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Cargar la configuración SMTP desde appsettings.json
builder.Services.Configure<SmtpSettings>(builder.Configuration.GetSection("SmtpSettings"));

// Agregar el servicio de envío de correos
builder.Services.AddSingleton<IEmailService, EmailService>();

// Agregar otros servicios necesarios
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddAutoMapper(typeof(Program));

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "API Control Neumaticos", Version = "v1" });
});

builder.Services.AddControllers();

// Inyección del Token Generator
builder.Services.AddSingleton<TokenGenerator>();

// Configuración de la base de datos
builder.Services.AddDbContext<ControlNeumaticosContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Configuración de autorización y autenticación JWT
builder.Services.AddAuthorization();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(x =>
    {
        x.TokenValidationParameters = new TokenValidationParameters
        {
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("H8v!L3r$XnD9k2@wWzU8pK0#tYfJ7d2L")),
            ValidateIssuer = false,
            ValidateAudience = false,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
        };
    });

var app = builder.Build();

// Configurar el pipeline de solicitudes HTTP
if (app.Environment.IsDevelopment())
{
    app.UseSwagger(); // Habilita Swagger en el entorno de desarrollo
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "API Control Neumaticos v1");
    });
}

// Configuración de autenticación y autorización
app.UseAuthentication();
app.UseAuthorization();

// Endpoint para login
app.MapPost("/api/login", (LoginRequestApp request, TokenGenerator tokenGenerator) =>
{
    return new {
        access_token = tokenGenerator.GenerateToken(request.Email)
    };
});

// Endpoint para enviar correo
app.MapPost("/api/send-email", async (string to, string subject, string body, IEmailService emailService) =>
{
    await emailService.SendEmailAsync(to, subject, body);
    return Results.Ok(new { message = "Correo enviado" });
});

// Habilita la redirección HTTPS
app.UseHttpsRedirection();

// Mapea los controladores
app.MapControllers();

app.Run();
