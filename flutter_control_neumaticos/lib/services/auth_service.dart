import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';
import 'dart:io';  // Necesario para manejar SocketException
import 'package:http/http.dart';  // Necesario para ClientException

class AuthService {
  // URL de la API para la autenticación
  final String apiUrl = '${Config.awsUrl}/api/Auth/Login';

  // Realiza la autenticación
  Future<Map<String, dynamic>> login(String username, String password) async {
    // Cuerpo de la solicitud en formato JSON
    final body = json.encode({
      'Correo': username,
      'Clave': password,
    });

    try {
      // Realiza la solicitud POST a la API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Si la respuesta es exitosa (código 200)
      if (response.statusCode == 200) {
        return _handleLoginResponse(response.body);
      } else {
        // Si la respuesta tiene un error
        return _handleErrorResponse(response.body);
      }
    } on SocketException catch (_) {
      // Si hay un error de red, lo manejamos aquí
      return {'error': 'No se pudo conectar al servidor. Verifica tu conexión a Internet.'};
    } on ClientException catch (_) {
      // Error relacionado con la API o cliente, como mal formado el request
      return {'error': 'Error de conexión con el servidor. Puede que el servidor esté inactivo o haya un problema con la API.'};
    } catch (e) {
      // Para otros errores generales
      return {'error': 'Error desconocido: ${e.toString()}'};
    }
  }

  // Maneja la respuesta exitosa de login
  Map<String, dynamic> _handleLoginResponse(String responseBody) {
    try {
      // Decodifica la respuesta JSON
      final Map<String, dynamic> response = json.decode(responseBody);
      return response; // Aquí se puede desestructurar si es necesario
    } catch (e) {
      // Si hay un error al procesar la respuesta
      return {'error': 'Error al procesar la respuesta: $e'};
    }
  }

  // Maneja las respuestas con errores
  Map<String, dynamic> _handleErrorResponse(String responseBody) {
    try {
      // Intentamos parsear como JSON, si no podemos, devolvemos el texto tal cual
      final Map<String, dynamic> errorResponse = json.decode(responseBody);
      return {'error': errorResponse['message'] ?? 'Error desconocido en el servidor'};
    } catch (e) {
      // Si no es JSON, solo devolvemos el texto tal cual
      return {'error': responseBody};
    }
  }

  // Guarda los datos de usuario en SharedPreferences
  Future<void> saveUserData(String username, String password, bool rememberMe) async {
    if (rememberMe) {
      // Obtiene la instancia de SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // Guarda el nombre de usuario y la contraseña
      prefs.setString('username', username);
      prefs.setString('password', password);
    }
  }

  // Carga los datos guardados de usuario
  Future<Map<String, String?>> loadUserData() async {
    // Obtiene la instancia de SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Carga el nombre de usuario y la contraseña
    final String? username = prefs.getString('username');
    final String? password = prefs.getString('password');
    return {'username': username, 'password': password};
  }

  // Guarda el token y el ID del usuario
  Future<void> saveTokenAndUserId(String token, int userId, int perfil, String correo, DateTime date, String contrasenaTemporal, String nombres) async {
    // Obtiene la instancia de SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Guarda el token, ID de usuario, perfil, correo, fecha, contraseña temporal y nombres
    prefs.setString('token', token);
    prefs.setInt('userId', userId);
    prefs.setInt('perfil', perfil);
    prefs.setString('correo', correo);
    prefs.setString('date', date.toString());
    prefs.setString('contrasenaTemporal', contrasenaTemporal);
    prefs.setString('nombres', nombres);
  }
}
