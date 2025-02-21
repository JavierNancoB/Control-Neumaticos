import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/config.dart';

class HistorialMovilService {
  // URL base de la API
  static const String _baseUrl = '${Config.awsUrl}/api';

  // Método para obtener el historial por patente y fechas
  // Recibe como parámetros la patente del vehículo, la fecha de inicio y la fecha de fin
  // Retorna una lista de mapas con los datos del historial
  static Future<List<Map<String, dynamic>>> fetchHistorialPorFechas(
      String patente, DateTime startDate, DateTime endDate) async {
    
    // Realiza una solicitud GET a la API con los parámetros proporcionados
    final response = await http.get(Uri.parse('$_baseUrl/HistorialMovil/buscarPorPatenteYFechas/$patente/fechaInicio/${startDate.toIso8601String()}/fechaFin/${endDate.toIso8601String()}'));
    
    // Verifica si la respuesta es exitosa (código 200)
    if (response.statusCode == 200) {
      // Decodifica el cuerpo de la respuesta en una lista dinámica
      final List<dynamic> data = json.decode(response.body);
      // Convierte la lista dinámica en una lista de mapas y la retorna
      return List<Map<String, dynamic>>.from(data);
    } else {
      // Lanza una excepción si la respuesta no es exitosa
      throw Exception('Error al obtener el historial');
    }
  }

  // Método para obtener el historial por patente y usuario
  // Recibe como parámetro la patente del vehículo
  // Retorna una lista de mapas con los datos del historial
  static Future<List<Map<String, dynamic>>> fetchHistorialPorUsuario(
      String patente) async {
    // Obtiene el ID del usuario almacenado en las preferencias compartidas
    final userId = await _getIdUsuario();
    
    // Realiza una solicitud GET a la API con los parámetros proporcionados
    final response = await http.get(Uri.parse('$_baseUrl/HistorialMovil/buscarPorPatenteUsuarioId/$patente/usuario/$userId'));
    
    // Verifica si la respuesta es exitosa (código 200)
    if (response.statusCode == 200) {
      // Decodifica el cuerpo de la respuesta en una lista dinámica
      final List<dynamic> data = json.decode(response.body);
      // Convierte la lista dinámica en una lista de mapas y la retorna
      return List<Map<String, dynamic>>.from(data);
    } else {
      // Lanza una excepción si la respuesta no es exitosa
      throw Exception('Error al obtener el historial');
    }
  }

  // Método privado para obtener el ID del usuario almacenado en las preferencias compartidas
  // Retorna el ID del usuario como un entero opcional
  static Future<int?> _getIdUsuario() async {
    // Obtiene una instancia de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retorna el ID del usuario almacenado en las preferencias
    return prefs.getInt('userId');
  }

  // Método para obtener el nombre del usuario por ID
  // Recibe como parámetro el ID del usuario
  // Retorna el nombre completo del usuario como una cadena
  static Future<String> getUsuarioNombre(int idUsuario) async {
    // Realiza una solicitud GET a la API con el ID del usuario
    final response = await http.get(Uri.parse('$_baseUrl/usuarios/$idUsuario'));
    
    // Verifica si la respuesta es exitosa (código 200)
    if (response.statusCode == 200) {
      // Decodifica el cuerpo de la respuesta en un mapa
      final data = json.decode(response.body);
      // Retorna el nombre completo del usuario concatenando nombres y apellidos
      return "${data['nombres']} ${data['apellidos']}";
    } else {
      // Lanza una excepción si la respuesta no es exitosa
      throw Exception('Error al obtener el usuario');
    }
  }
}
