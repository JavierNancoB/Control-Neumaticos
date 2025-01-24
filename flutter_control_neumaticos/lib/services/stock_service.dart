import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchNeumaticos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception('Token not found');
  }

  final response = await http.get(
    Uri.parse('http://localhost:5062/api/Neumaticos/GetNeumaticoByMovilNULL'),
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
