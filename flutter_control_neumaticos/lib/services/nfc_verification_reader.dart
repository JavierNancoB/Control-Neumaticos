import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';

class NfcVerificationReader {
  static final String _baseUrl = '${Config.awsUrl}/api';
  // Método de verificación de habilitación del neumático
  Future<bool> verificarSiNeumaticoHabilitado(String codigo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final urlHabilitado = '$_baseUrl/Neumaticos/verificarSiNeumaticoHabilitado?codigo=$codigo';
    
    try {
      final response = await http.post(
        Uri.parse(urlHabilitado),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data == true; // Retorna true si está habilitado
      } else {
        throw Exception('Error al verificar si el neumático está habilitado');
      }
    } catch (e) {
      return false;
    }
  }

  // Método de verificación de existencia del neumático
  Future<bool> verificarSiNeumaticoExiste(int codigo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Actualizar la URL para incluir el código como query parameter
    final urlExiste = '$_baseUrl/Neumaticos/verificarSiNeumaticoExiste?codigo=$codigo';
    
    try {
      final response = await http.post(
        Uri.parse(urlExiste),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data == true; // Retorna true si el neumático existe
      } else {
        throw Exception('Error al verificar si el neumático existe');
      }
    } catch (e) {
      return false;
    }
  }
}
