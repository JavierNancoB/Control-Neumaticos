import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/config.dart';

class MovilService {
  // URL base para las solicitudes a la API
  final String _baseUrl = '${Config.awsUrl}/api';

  // Función para obtener los datos del móvil por patente
  Future<Map<String, dynamic>?> getMovilDataByPatente(String patente) async {
    // Obtener instancia de SharedPreferences para acceder al token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Realizar solicitud GET a la API con la patente proporcionada
    final response = await http.get(
      Uri.parse('$_baseUrl/Movil/GetMovilByPatente?patente=$patente'),
      headers: {
        'Authorization': 'Bearer $token', // Incluir token en los encabezados
      },
    );

    // Verificar si la respuesta es exitosa (código 200)
    if (response.statusCode == 200) {
      // Decodificar el cuerpo de la respuesta y devolver los datos
      return json.decode(response.body);
    } else {
      // Lanzar una excepción si ocurre un error
      throw Exception('Error al obtener datos del móvil.');
    }
  }

  // Función para obtener las patentes sugeridas según un query
  Future<List<String>> fetchPatentesSugeridas(String query) async {
    // Obtener instancia de SharedPreferences para acceder al token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Verificar si el token es nulo
    if (token == null) {
      throw Exception("No se encontró el token de autenticación.");
    }

    // Construir la URL para la solicitud GET con el query proporcionado
    final url = Uri.parse('$_baseUrl/Movil/BuscarMovilesPorPatente?query=$query');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'}, // Incluir token en los encabezados
    );

    // Verificar si la respuesta es exitosa (código 200)
    if (response.statusCode == 200) {
      // Decodificar el cuerpo de la respuesta y devolver la lista de patentes
      List<dynamic> data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      // Lanzar una excepción si ocurre un error
      throw Exception('Error al obtener las sugerencias de patentes.');
    }
  }

  // Función para obtener los neumáticos de un móvil por su ID
  Future<List<dynamic>?> getNeumaticosDataByMovilId(int idMovil) async {
    // Obtener instancia de SharedPreferences para acceder al token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Realizar solicitud GET a la API con el ID del móvil proporcionado
    final response = await http.get(
      Uri.parse('$_baseUrl/Neumaticos/GetNeumaticoByMovilID?idMovil=$idMovil'),
      headers: {
        'Authorization': 'Bearer $token', // Incluir token en los encabezados
      },
    );

    // Verificar si la respuesta es exitosa (código 200)
    if (response.statusCode == 200) {
      // Decodificar el cuerpo de la respuesta y devolver los datos
      return json.decode(response.body);
    } else {
      // Lanzar una excepción si ocurre un error
      throw Exception('Error al obtener los neumáticos.');
    }
  }
}
