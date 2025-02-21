import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../models/config.dart';

// Función para obtener la lista de neumáticos desde el servidor
Future<List<dynamic>> fetchNeumaticos() async {
  // Construye la URL base usando la configuración de AWS
  final String baseUrl = '${Config.awsUrl}/api';
  
  // Obtiene una instancia de SharedPreferences para acceder al token almacenado
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  // Si no se encuentra el token, lanza una excepción
  if (token == null) {
    throw Exception('Token not found');
  }

  // Realiza una solicitud GET a la API para obtener los neumáticos
  final response = await http.get(
    Uri.parse('$baseUrl/Neumaticos/GetNeumaticoByMovilNULL'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  // Si la respuesta es exitosa (código 200), decodifica el cuerpo de la respuesta
  if (response.statusCode == 200) {
    List<dynamic> neumaticos = json.decode(response.body);
    // Filtra los neumáticos para devolver solo aquellos con estado 1
    return neumaticos.where((neumatico) => neumatico['estado'] == 1).toList();
  } else {
    // Si la respuesta no es exitosa, lanza una excepción
    throw Exception('Failed to load neumaticos');
  }
}

// Función para obtener las sugerencias de patentes según una consulta
Future<List<String>> fetchPatentesSugeridas(String query) async {
  // Construye la URL base usando la configuración de AWS
  final String baseUrl = '${Config.awsUrl}/api';
  
  // Obtiene una instancia de SharedPreferences para acceder al token almacenado
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  // Si no se encuentra el token, lanza una excepción
  if (token == null) {
    throw Exception("No se encontró el token de autenticación.");
  }

  // Construye la URL para la solicitud GET con la consulta proporcionada
  final url = Uri.parse('$baseUrl/Movil/BuscarMovilesPorPatente?query=$query');
  
  // Realiza una solicitud GET a la API para obtener las sugerencias de patentes
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  // Si la respuesta es exitosa (código 200), decodifica el cuerpo de la respuesta
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    // Convierte la lista dinámica en una lista de cadenas y la devuelve
    return List<String>.from(data);
  } else {
    // Si la respuesta no es exitosa, lanza una excepción
    throw Exception('Error al obtener las sugerencias de patentes.');
  }
}
