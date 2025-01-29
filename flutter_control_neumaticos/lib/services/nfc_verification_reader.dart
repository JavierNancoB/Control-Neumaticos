import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NfcVerificationReader {
  // Método de verificación de habilitación del neumático
  Future<bool> verificarSiNeumaticoHabilitado(String codigo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final urlHabilitado = 'http://localhost:5062/api/Neumaticos/verificarSiNeumaticoHabilitado?codigo=$codigo';
    print('Verificando si el neumático está habilitado con código: $codigo');
    
    try {
      final response = await http.post(
        Uri.parse(urlHabilitado),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Respuesta de la API para habilitación: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Datos recibidos: $data');
        return data == true; // Retorna true si está habilitado
      } else {
        print('Error al verificar si el neumático está habilitado');
        throw Exception('Error al verificar si el neumático está habilitado');
      }
    } catch (e) {
      print('Exception al verificar si el neumático está habilitado: $e');
      return false;
    }
  }

  // Método de verificación de existencia del neumático
  Future<bool> verificarSiNeumaticoExiste(int codigo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Actualizar la URL para incluir el código como query parameter
    final urlExiste = 'http://localhost:5062/api/Neumaticos/verificarSiNeumaticoExiste?codigo=$codigo';
    print('mandamos la url: $urlExiste');
    print('Verificando si el neumático existe con código: $codigo');
    
    try {
      final response = await http.post(
        Uri.parse(urlExiste),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );

      print('Respuesta de la API para existencia: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Datos recibidos (existe?): $data');
        return data == true; // Retorna true si el neumático existe
      } else {
        print('Error al verificar si el neumático existe');
        throw Exception('Error al verificar si el neumático existe');
      }
    } catch (e) {
      print('Exception al verificar si el neumático existe: $e');
      return false;
    }
  }
}
