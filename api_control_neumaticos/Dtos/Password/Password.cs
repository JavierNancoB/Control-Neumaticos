namespace api_control_neumaticos.Dtos.Password
{
    public class ForgotPasswordDto
    {
        public required string Correo { get; set; }
    }

    public class ResetPasswordDto
    {
        public required string Correo { get; set; }
        public required string Token { get; set; }
        public required string NewPassword { get; set; }
    }

}