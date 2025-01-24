using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using api_control_neumaticos.Models;


public class UsuarioService
{
    private readonly ControlNeumaticosContext _context;
    private readonly PasswordHasher<Usuario> _passwordHasher;

    public UsuarioService(ControlNeumaticosContext context)
    {
        _context = context;
        _passwordHasher = new PasswordHasher<Usuario>(); // Inicializa el PasswordHasher
    }

    public async Task RegisterUsuario(Usuario usuario, string password)
    {
        // Cifrar la contraseña antes de almacenarla
        usuario.Clave = _passwordHasher.HashPassword(usuario, password); // Cifra la contraseña

        _context.Usuarios.Add(usuario);
        await _context.SaveChangesAsync(); // Guarda el usuario en la base de datos
    }
}
