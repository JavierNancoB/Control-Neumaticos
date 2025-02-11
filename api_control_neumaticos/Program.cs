using api_control_neumaticos.Models;
using api_control_neumaticos.Services;
using api_control_neumaticos.Services.IExcelService; // Asegúrate de que el espacio de nombres sea correcto
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using SendingEmails;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddTransient<IEmailSender, EmailSender>();
builder.Services.Configure<MailSettings>(builder.Configuration.GetSection("MailSettings"));
builder.Services.AddTransient<IEmailSender, EmailSender>();

// Registrar el servicio IExcelService
builder.Services.AddScoped<IExcelService, IExcelService>(); // Aquí se registra la implementación

builder.Services.AddControllersWithViews();

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
//builder.Services.AddDbContext<ControlNeumaticosContext>(options =>
//    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddDbContext<ControlNeumaticosContext>(options =>
    options.UseMySql(builder.Configuration.GetConnectionString("DefaultConnection"), 
        new MySqlServerVersion(new Version(10, 4, 17))));



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

// Habilita la redirección HTTPS
app.UseHttpsRedirection();

// Mapea los controladores
app.MapControllers();

app.Run();
