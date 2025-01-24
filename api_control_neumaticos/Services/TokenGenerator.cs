using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

// Todo esto se utiliza despues de haber hecho el match con la base de datos y el mail/contraseña.

// existen 3 partes en la codificacion de un token

// Header: contiene el tipo de token y el algoritmo de encriptacion

// Payload: contiene la informacion que se quiere transmitir

// Signature: contiene la firma digital que garantiza que el token no ha sido modificado

namespace api_control_neumaticos.Services
{
    public class TokenGenerator
    {
        public string GenerateToken(string email)
        {
            // Clave secreta para firmar el token
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes("H8v!L3r$XnD9k2@wWzU8pK0#tYfJ7d2L");

            var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new(JwtRegisteredClaimNames.Email, email),
            };

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddHours(2),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }
    }
}