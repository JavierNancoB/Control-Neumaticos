import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/usuario.dart';

class UsuarioService {
  static const String _baseUrl = 'http://localhost:5062/api/usuarios';

  // Añadir usuario
  static Future<void> crearUsuario(Usuario usuario) async {
    final token = await _getToken();
    final idUsuario = await _getIdUsuario();
    
    
    if (token == null) throw Exception('Token no encontrado.');


    final response = await http.post(
      Uri.parse('$_baseUrl?idUsuarioBitacora=$idUsuario'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(usuario.toJson()),
    );

    if (response.statusCode == 201) {
      // Usuario creado con éxito
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else if (response.statusCode == 409) {
      throw Exception('El correo ya está en uso');
    } else {
      throw Exception('Error al añadir usuario');
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
