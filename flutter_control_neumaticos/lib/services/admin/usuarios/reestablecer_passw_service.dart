import 'package:http/http.dart' as http;

class RestablecerPasswService {
  final String apiUrl = 'http://localhost:5062/api/Usuarios/RestablecerClave';
  String errorMessage = '';  // Declara la variable a nivel de clase

  // Método para restablecer la contraseña automáticamente
  Future<bool> restablecerContrasenaAutomatica(String email) async {
    final url = Uri.parse('$apiUrl?mail=$email&autogenerada=true');

    print('Enviando solicitud PUT a endpoint: $url');

    try {
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
      });

      print('Respuesta recibida: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 204) {
        print('Contraseña restablecida automáticamente para $email');
        return true; // Restablecimiento exitoso
      } else {
        print('Error en el servidor, código de respuesta: ${response.statusCode}');
        return false; // Error en el servidor
      }
    } catch (e) {
      print('Error al restablecer contraseña automática: $e');
      // Verifica el tipo de error para dar detalles más claros
      if (e is http.ClientException) {
        return false; // Error relacionado con el cliente
      } else {
        return false; // Error general
      }
    }
  }

  // Método para restablecer la contraseña de forma manual
  Future<bool> restablecerContrasenaManual(String email, String nuevaClave, bool admin) async {
    final url = Uri.parse('$apiUrl?mail=$email&NuevaClave=$nuevaClave&administrador=$admin');

    print('Enviando solicitud PUT a endpoint: $url');

    try {
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
      });

      print('Respuesta recibida: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 204) {
        print('Contraseña manualmente restablecida para $email');
        return true; // Restablecimiento exitoso
      } else {
        errorMessage = response.body;  // Capturamos el mensaje del cuerpo en caso de error
        print('Error en el servidor, código de respuesta: ${response.statusCode}');
        return false; // Error en el servidor
      }
    } catch (e) {
      print('Error al restablecer contraseña manual: $e');
      errorMessage = 'Error al realizar la solicitud';  // Mensaje de error genérico
      return false;
    }
  }
}
