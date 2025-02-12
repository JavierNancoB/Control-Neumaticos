import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../models/config.dart';

Future<List<dynamic>> fetchNeumaticos() async {
  const String baseUrl = '${Config.awsUrl}/api';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception('Token not found');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/Neumaticos/GetNeumaticoByMovilNULL'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> neumaticos = json.decode(response.body);
    return neumaticos.where((neumatico) => neumatico['estado'] == 1).toList();
  } else {
    throw Exception('Failed to load neumaticos');
  }
}

Future<List<String>> fetchPatentesSugeridas(String query) async {
  const String baseUrl = '${Config.awsUrl}/api';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception("No se encontró el token de autenticación.");
  }

  final url = Uri.parse('$baseUrl/Movil/BuscarMovilesPorPatente?query=$query');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return List<String>.from(data);
  } else {
    throw Exception('Error al obtener las sugerencias de patentes.');
  }
}
