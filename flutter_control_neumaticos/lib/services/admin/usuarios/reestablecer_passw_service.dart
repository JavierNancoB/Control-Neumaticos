import 'package:http/http.dart' as http;
import '../../../models/config.dart';

class RestablecerPasswService {
  final String apiUrl = '${Config.awsUrl}/api/Usuarios/RestablecerClave';
  String errorMessage = '';  // Declara la variable a nivel de clase

  // Método para restablecer la contraseña automáticamente
  Future<bool> restablecerContrasenaAutomatica(String email) async {
    final url = Uri.parse('$apiUrl?mail=$email&autogenerada=true');

    try {
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
      });

      
      if (response.statusCode == 204) {
        return true; // Restablecimiento exitoso
      } else {
        return false; // Error en el servidor
      }
    } catch (e) {
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

    try {
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 204) {
        return true; // Restablecimiento exitoso
      } else {
        errorMessage = response.body;  // Capturamos el mensaje del cuerpo en caso de error
        return false; // Error en el servidor
      }
    } catch (e) {
      errorMessage = 'Error al realizar la solicitud';  // Mensaje de error genérico
      return false;
    }
  }
}
