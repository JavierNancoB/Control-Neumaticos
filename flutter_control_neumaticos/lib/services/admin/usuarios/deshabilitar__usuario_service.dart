import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../models/config.dart';

class UsuarioService {
  static const String _baseUrl = '${Config.awsUrl}/api';

  // Buscar usuarios por correo mientras el usuario escribe
  static Future<List<String>> buscarUsuariosPorCorreo(String query) async {
    final token = await _getToken();
    final idUsuario = await _getIdUsuario();
    
    if (idUsuario == null) throw Exception('ID de usuario no encontrado.');
    if (token == null) throw Exception('Token no encontrado.');

    final url = '$_baseUrl/Usuarios/BuscarUsuariosPorCorreo?query=$query&idUsuario=$idUsuario';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = List<String>.from(
        (response.body.isNotEmpty)
            ? json.decode(response.body)
            : [],
      );
      return data;
    } else {
      throw Exception('Error al obtener sugerencias de correos.');
    }
  }

  // Modificar estado de usuario por correo electrónico
  static Future<void> modificarEstadoUsuario(String correo, int estado) async {
    final token = await _getToken();
    final idUsuario = await _getIdUsuario();
    if (token == null) throw Exception('Token no encontrado.');


    final url = '$_baseUrl/Usuarios/ModificarCodEstadoPorCorreo?mail=$correo&codEstado=$estado&idUsuarioBitacora=$idUsuario';
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
  static Future<int?> _getIdUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}
