import 'package:http/http.dart' as http;

import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioService {
  static const String apiUrl = 'http://localhost:5062/api/Usuarios/ComprobarUsuarioHabilitado';

  Future<bool> buscarUsuarioPorCorreo(String email) async {
    final response = await http.get(Uri.parse('$apiUrl?mail=$email'));

    if (response.statusCode == 200) {
      // El usuario existe y está habilitado si la API retorna true
      final data = json.decode(response.body);
      return data == true;
    } else if (response.statusCode == 404) {
      // El usuario no fue encontrado
      throw Exception('Usuario deshabilitado/no encontrado');
    } else {
      // Hubo un error en la solicitud
      throw Exception('Error al comprobar el estado del usuario. Código: ${response.statusCode}');
    }
  }
}
