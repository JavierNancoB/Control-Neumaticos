import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/neumatico.dart';

class NeumaticoService {
  static const String _baseUrl = 'http://localhost:5062/api';

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<int?> getMovilByPatente(String patente) async {
    final token = await getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/Movil/GetMovilByPatente?patente=$patente'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['ID_MOVIL'];
    } else {
      throw Exception('Error al obtener el móvil por patente.');
    }
  }

  static Future<void> addNeumatico(Neumatico neumatico) async {
    final token = await getToken();
    if (token == null) throw Exception('Token no encontrado.');

    final response = await http.post(
      Uri.parse('$_baseUrl/Neumaticos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(neumatico.toJson()),
    );

    if (response.statusCode != 201) {
      if (response.statusCode == 400) {
        throw Exception('El código del neumático ya está registrado.');
      } else {
        throw Exception('Error al añadir el neumático.');
      }
    }
  }
}
