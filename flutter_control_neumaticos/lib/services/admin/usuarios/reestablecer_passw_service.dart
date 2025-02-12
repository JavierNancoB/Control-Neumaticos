import 'package:http/http.dart' as http;
import '../../../models/config.dart';

class RestablecerPasswService {
  final String apiUrl = '${Config.awsUrl}/api/Usuarios/RestablecerClave';
  String errorMessage = '';  // Declara la variable a nivel de clase

  // Método para restablecer la contraseña automáticamente
  Future<bool> restablecerContrasenaAutomatica(String email) async {
    final url = Uri.parse('$apiUrl?mail=$email&autogenerada=true');
    print('URL para restablecer contrasena automatica: $url');

    try {
      print('Realizando la solicitud HTTP PUT...');
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
      });

      print('Respuesta recibida: ${response.statusCode}');
      
      if (response.statusCode == 204) {
        print('Restablecimiento exitoso');
        return true; // Restablecimiento exitoso
      } else {
        print('Error en el servidor: ${response.body}');
        return false; // Error en el servidor
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      // Verifica el tipo de error para dar detalles más claros
      if (e is http.ClientException) {
        print('Error relacionado con el cliente');
        return false; // Error relacionado con el cliente
      } else {
        print('Error general desconocido');
        return false; // Error general
      }
    }
  }

  // Método para restablecer la contraseña de forma manual
  Future<bool> restablecerContrasenaManual(String email, String nuevaClave, bool admin) async {
    final url = Uri.parse('$apiUrl?mail=$email&NuevaClave=$nuevaClave&administrador=$admin');
    print('URL para restablecer contrasena manual: $url');

    try {
      print('Realizando la solicitud HTTP PUT...');
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
      });

      print('Respuesta recibida: ${response.statusCode}');
      if (response.statusCode == 204) {
        print('Restablecimiento exitoso');
        return true; // Restablecimiento exitoso
      } else {
        errorMessage = response.body;  // Capturamos el mensaje del cuerpo en caso de error
        print('Error en el servidor: $errorMessage');
        return false; // Error en el servidor
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      errorMessage = 'Error al realizar la solicitud';  // Mensaje de error genérico
      return false;
    }
  }
}
