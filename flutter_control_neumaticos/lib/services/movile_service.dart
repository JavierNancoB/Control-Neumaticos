import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovilService {
  // Función para obtener los datos del móvil por patente
  static Future<Map<String, dynamic>?> getMovilDataByPatente(String patente) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://localhost:5062/api/Movil/GetMovilByPatente?patente=$patente'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<String>> fetchPatentesSugeridas(String query) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception("No se encontró el token de autenticación.");
  }

  final url = Uri.parse('http://localhost:5062/api/Movil/BuscarMovilesPorPatente?query=$query');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return List<String>.from(data);
  } else {
    throw Exception('Error al obtener las sugerencias de patentes.');
  }
}
  // Función para obtener los neumáticos de un móvil
  static Future<List<dynamic>?> getNeumaticosDataByMovilId(int idMovil) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://localhost:5062/api/Neumaticos/GetNeumaticoByMovilID?idMovil=$idMovil'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
