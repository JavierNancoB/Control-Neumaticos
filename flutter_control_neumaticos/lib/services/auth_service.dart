import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';

class AuthService {
  final String apiUrl = '${Config.awsUrl}/api/Auth/Login';

  // Realiza la autenticación
  Future<Map<String, dynamic>> login(String username, String password) async {
    final body = json.encode({
      'Correo': username,
      'Clave': password,
    });

    print('Enviando solicitud de login a $apiUrl con body: $body');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Respuesta recibida: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return _handleLoginResponse(response.body);
      } else {
        return _handleErrorResponse(response.body);
      }
    } catch (e) {
      print('Error durante la solicitud de login: $e');
      return {'error': e.toString()};  // Muestra el error en limpio, tal cual viene
    }
  }

  // Maneja la respuesta exitosa de login
  Map<String, dynamic> _handleLoginResponse(String responseBody) {
    print('Procesando respuesta exitosa de login: $responseBody');
    try {
      final Map<String, dynamic> response = json.decode(responseBody);
      print('Respuesta procesada: $response');
      return response; // Aquí se puede desestructurar si es necesario
    } catch (e) {
      print('Error al procesar la respuesta: $e');
      return {'error': 'Error al procesar la respuesta: $e'};
    }
  }

  // Maneja las respuestas con errores
  Map<String, dynamic> _handleErrorResponse(String responseBody) {
    print('Procesando respuesta con error: $responseBody');
    try {
      // Intentamos parsear como JSON, si no podemos, devolvemos el texto tal cual
      final Map<String, dynamic> errorResponse = json.decode(responseBody);
      print('Respuesta de error procesada: $errorResponse');
      return {'error': errorResponse['message'] ?? 'Ha ocurrido un error desconocido.'};
    } catch (e) {
      print('Error al procesar la respuesta de error: $e');
      // Si no es JSON, solo devolvemos el texto tal cual
      return {'error': responseBody};
    }
  }

  // Guarda los datos de usuario en SharedPreferences
  Future<void> saveUserData(String username, String password, bool rememberMe) async {
    if (rememberMe) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print('Guardando datos de usuario: username=$username, password=$password');
      prefs.setString('username', username);
      prefs.setString('password', password);
    }
  }

  // Carga los datos guardados de usuario
  Future<Map<String, String?>> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final String? password = prefs.getString('password');
    print('Datos de usuario cargados: username=$username, password=$password');
    return {'username': username, 'password': password};
  }

  // Guarda el token y el ID del usuario
  Future<void> saveTokenAndUserId(String token, int userId, int perfil, String correo, DateTime date, String contrasenaTemporal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Guardando token y datos de usuario: token=$token, userId=$userId, perfil=$perfil, correo=$correo, date=$date, contrasenaTemporal=$contrasenaTemporal');
    prefs.setString('token', token);
    prefs.setInt('userId', userId);
    prefs.setInt('perfil', perfil);
    prefs.setString('correo', correo);
    prefs.setString('date', date.toString());
    prefs.setString('contrasenaTemporal', contrasenaTemporal);
  }
}
