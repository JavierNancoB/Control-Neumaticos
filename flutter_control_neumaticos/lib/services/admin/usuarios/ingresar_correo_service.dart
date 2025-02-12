import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../models/config.dart';

class UsuarioService {
  static const String apiUrl = '${Config.awsUrl}/api/Usuarios';

  // Función para comprobar si el usuario está habilitado
  Future<bool> buscarUsuarioPorCorreo(String email) async {
    try {
      // Construir la URL completa para la solicitud
      final url = Uri.parse('$apiUrl/ComprobarUsuarioHabilitado?mail=$email');

      // Imprimir la URL que se está usando

      final response = await http.get(url);


      if (response.statusCode == 200) {
        // El usuario existe y está habilitado si la API retorna true
        final data = json.decode(response.body);
        return data == true;
      } else {
        // El usuario no fue encontrado o está deshabilitado
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Función para buscar sugerencias de correos mientras el usuario escribe
  Future<List<String>> buscarUsuariosPorCorreo(String query) async {
    try {
      final url = Uri.parse('$apiUrl/BuscarUsuariosPorCorreo?query=$query');

      // Imprimir la URL que se está usando

      final response = await http.get(url);


      if (response.statusCode == 200) {
        // Convertir la respuesta a una lista de correos
        final data = json.decode(response.body);
        return List<String>.from(data); // Asumiendo que cada elemento tiene un campo "Correo"
      } else {
        // Si no hay resultados o hubo algún error
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
