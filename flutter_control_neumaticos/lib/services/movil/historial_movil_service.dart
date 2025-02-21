import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistorialMovilService {
  static const String _baseUrl = 'http://localhost:5062/api';

  // Método para obtener el historial por patente y fechas
  static Future<List<Map<String, dynamic>>> fetchHistorialPorFechas(
      String patente, DateTime startDate, DateTime endDate) async {
    
    final response = await http.get(Uri.parse('$_baseUrl/HistorialMovil/buscarPorPatenteYFechas/$patente/fechaInicio/${startDate.toIso8601String()}/fechaFin/${endDate.toIso8601String()}'));
    
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener el historial');
    }
  }

  // Método para obtener el historial por patente y usuario
  static Future<List<Map<String, dynamic>>> fetchHistorialPorUsuario(
      String patente) async {
    final userId = await _getIdUsuario();
    
    
    final response = await http.get(Uri.parse('$_baseUrl/HistorialMovil/buscarPorPatenteUsuarioId/$patente/usuario/$userId'));
    
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener el historial');
    }
  }

  static Future<int?> _getIdUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  // Método para obtener el nombre del usuario por ID
  static Future<String> getUsuarioNombre(int idUsuario) async {
    
    final response = await http.get(Uri.parse('$_baseUrl/usuarios/$idUsuario'));
    
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return "${data['nombres']} ${data['apellidos']}";
    } else {
      throw Exception('Error al obtener el usuario');
    }
  }
  
}
