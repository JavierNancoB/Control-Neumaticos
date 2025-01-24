// Purpose: This file is used to define the model for the LoginRequest object.
// The LoginRequest object is used to model the request body for the login endpoint.

namespace api_control_neumaticos.Models
{
    public class LoginRequestApp
    {
        public required string Email { get; set; }
        public required string Password { get; set; }
    }
}