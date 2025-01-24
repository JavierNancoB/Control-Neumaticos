import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<Map<String, dynamic>> fetchNeumaticoData(String nfcData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception("Token no encontrado.");
  }

  final url = Uri.parse(
    'http://localhost:5062/api/Neumaticos/GetNeumaticoByCodigo?codigo=$nfcData',
  );
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al obtener los datos: ${response.statusCode}');
  }
}
