import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioService {
  static const String _baseUrl = 'http://localhost:5062/api';

  // Modificar estado de usuario por correo electrónico
  static Future<void> modificarEstadoUsuario(String correo, int estado) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token no encontrado.');

    final url = '$_baseUrl/Usuarios/ModificarCodEstadoPorCorreo?mail=$correo&codEstado=$estado';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Error al modificar el estado del usuario.');
    }
  }

  // Obtener token de SharedPreferences
  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
