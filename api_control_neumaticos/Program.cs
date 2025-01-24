using api_control_neumaticos.Models;
using api_control_neumaticos.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddAutoMapper(typeof(Program));

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "API Control Neumaticos", Version = "v1" });
});

builder.Services.AddControllers();

builder.Services.AddSingleton<TokenGenerator>();

builder.Services.AddDbContext<ControlNeumaticosContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// **Mover la configuración de autenticación y autorización antes de builder.Build()**
builder.Services.AddAuthorization();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(x =>
    {
        x.TokenValidationParameters = new TokenValidationParameters
        {
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("H8v!L3r$XnD9k2@wWzU8pK0#tYfJ7d2L")), // Asegúrate de que la cadena esté bien escrita
            ValidateIssuer = false,
            ValidateAudience = false,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
        };
    });

var app = builder.Build();

// Configure the HTTP request pipeline

if (app.Environment.IsDevelopment())
{
    app.UseSwagger(); // Habilita Swagger en el entorno de desarrollo
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "API Control Neumaticos v1");
    });
}

/********************JWT TOKEN GENERATOR************************/

app.UseAuthentication();
app.UseAuthorization();

app.MapPost("/api/login", (LoginRequestApp request, TokenGenerator tokenGenerator) =>
{
    return new {
        access_token = tokenGenerator.GenerateToken(request.Email)
    };
});

// Primero se hace la validación de usuario y contraseña, si es correcto se genera el token
// Esta validación se hace en el controlador de login

/***************************************************************/

app.UseHttpsRedirection();

app.MapControllers(); // Mapea los controladores

app.Run();
