// alertas/models/alerta_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlertaService {

  // Método para obtener las alertas

  Future<List<dynamic>?> fetchAlertas() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return null; // Si no hay token, no hacemos la solicitud
      }

      final url = Uri.parse('http://localhost:5062/api/Alerta');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener las alertas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ocurrió un error: $e');
    }
  }
  
  // Método para obtener los datos de un neumático
  
  Future<Map<String, dynamic>?> fetchNeumaticoData(String idNeumatico) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return null; // Si no hay token, no hacemos la solicitud
      }

      final url = Uri.parse('http://localhost:5062/api/neumaticos?id=$idNeumatico');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          return jsonResponse[0]; // Tomar el primer objeto
        } else {
          throw Exception('No se encontró información del neumático.');
        }
      } else {
        throw Exception('Error al obtener los datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ocurrió un error: $e');
    }
  }
}
