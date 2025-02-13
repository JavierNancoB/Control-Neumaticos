import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';

class MovilService {
  final String _baseUrl = '${Config.awsUrl}/api';

  // Función para obtener los datos del móvil por patente
  Future<Map<String, dynamic>?> getMovilDataByPatente(String patente) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Movil/GetMovilByPatente?patente=$patente'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener datos del móvil.');
    }
  }

  Future<List<String>> fetchPatentesSugeridas(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("No se encontró el token de autenticación.");
    }

    final url = Uri.parse('$_baseUrl/Movil/BuscarMovilesPorPatente?query=$query');
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
  Future<List<dynamic>?> getNeumaticosDataByMovilId(int idMovil) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/Neumaticos/GetNeumaticoByMovilID?idMovil=$idMovil'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener los neumáticos.');
    }
  }
}
