import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/movil.dart';

class MovilService {
  static const String _baseUrl = 'http://localhost:5062/api/Movil';

  // Crear móvil
  static Future<void> crearMovil(Movil movil) async {
    final token = await _getToken();
    final idUsuario = await _getIdUsuario();
    if (token == null) throw Exception('Token no encontrado.');
    if (idUsuario == null) throw Exception('ID de usuario no encontrado.');

    final response = await http.post(
      Uri.parse('$_baseUrl?idUsuario=$idUsuario'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(movil.toJson()),
    );

    if (response.statusCode == 201) {
      // Móvil creado con éxito
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    } else {
      throw Exception('Error al añadir móvil');
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
