// services/alertas_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlertasService {
  static const String _baseUrl = 'http://localhost:5062/api/Alerta';

  // Método para obtener las alertas pendientes
  Future<List<dynamic>> getAlertasAtendidas() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/GetAlertasByEstadoAlerta3'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load alertas');
      }
    } catch (e) {
      throw Exception('Error fetching alertas: $e');
    }
  }
}
