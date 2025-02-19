import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistorialMovilService {
  static const String _baseUrl = 'http://localhost:5062/api';

  // Método para obtener el historial por patente y fechas
  static Future<List<Map<String, dynamic>>> fetchHistorialPorFechas(
      String patente, DateTime startDate, DateTime endDate) async {
    print('Fetching historial por fechas...');
    print('Patente: $patente');
    print('Start Date: ${startDate.toIso8601String()}');
    print('End Date: ${endDate.toIso8601String()}');
    
    final response = await http.get(Uri.parse('$_baseUrl/HistorialMovil/buscarPorPatenteYFechas/$patente/fechaInicio/${startDate.toIso8601String()}/fechaFin/${endDate.toIso8601String()}'));
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Data: $data');
      return List<Map<String, dynamic>>.from(data);
    } else {
      print('Error al obtener el historial');
      throw Exception('Error al obtener el historial');
    }
  }

  // Método para obtener el historial por patente y usuario
  static Future<List<Map<String, dynamic>>> fetchHistorialPorUsuario(
      String patente) async {
    final userId = await _getIdUsuario();
    
    print('Fetching historial por usuario...');
    print('Patente: $patente');
    
    final response = await http.get(Uri.parse('$_baseUrl/HistorialMovil/buscarPorPatenteUsuarioId/$patente/usuario/$userId'));
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Data: $data');
      return List<Map<String, dynamic>>.from(data);
    } else {
      print('Error al obtener el historial');
      throw Exception('Error al obtener el historial');
    }
  }

  static Future<int?> _getIdUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  // Método para obtener el nombre del usuario por ID
  static Future<String> getUsuarioNombre(int idUsuario) async {
    print('Fetching usuario nombre...');
    print('ID Usuario: $idUsuario');
    
    final response = await http.get(Uri.parse('$_baseUrl/usuarios/$idUsuario'));
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Data: $data');
      return "${data['nombres']} ${data['apellidos']}";
    } else {
      print('Error al obtener el usuario');
      throw Exception('Error al obtener el usuario');
    }
  }
  
}
