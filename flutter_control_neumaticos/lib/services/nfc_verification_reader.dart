import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';

class NfcVerificationReader {
  // URL base para las solicitudes a la API
  static final String _baseUrl = '${Config.awsUrl}/api';

  // Método para verificar si un neumático está habilitado
  Future<bool> verificarSiNeumaticoHabilitado(String codigo) async {
    // Obtener instancia de SharedPreferences para acceder al token almacenado
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtener el token de autenticación
    String? token = prefs.getString('token');

    // Construir la URL para la solicitud de verificación de habilitación
    final urlHabilitado = '$_baseUrl/Neumaticos/verificarSiNeumaticoHabilitado?codigo=$codigo';
    
    try {
      // Realizar la solicitud HTTP POST
      final response = await http.post(
        Uri.parse(urlHabilitado),
        headers: {'Authorization': 'Bearer $token'}, // Incluir el token en los headers
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final data = json.decode(response.body);
        // Retornar true si el neumático está habilitado
        return data == true;
      } else {
        // Lanzar una excepción si la respuesta no es exitosa
        throw Exception('Error al verificar si el neumático está habilitado');
      }
    } catch (e) {
      // Retornar false en caso de cualquier error
      return false;
    }
  }

  // Método para verificar si un neumático existe
  Future<bool> verificarSiNeumaticoExiste(int codigo) async {
    // Obtener instancia de SharedPreferences para acceder al token almacenado
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtener el token de autenticación
    String? token = prefs.getString('token');

    // Construir la URL para la solicitud de verificación de existencia
    final urlExiste = '$_baseUrl/Neumaticos/verificarSiNeumaticoExiste?codigo=$codigo';
    
    try {
      // Realizar la solicitud HTTP POST
      final response = await http.post(
        Uri.parse(urlExiste),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}, // Incluir el token y el tipo de contenido en los headers
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final data = json.decode(response.body);
        // Retornar true si el neumático existe
        return data == true;
      } else {
        // Lanzar una excepción si la respuesta no es exitosa
        throw Exception('Error al verificar si el neumático existe');
      }
    } catch (e) {
      // Retornar false en caso de cualquier error
      return false;
    }
  }
}
