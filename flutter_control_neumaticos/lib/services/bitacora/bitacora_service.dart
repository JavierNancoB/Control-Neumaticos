import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BitacoraService {
  // Obtener el token de SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  // Obtener el userId desde SharedPreferences
  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 1; // Default userId 1 if not found
    return userId;
  }

  static Future<bool> existenDosPinchazos(int idNeumatico) async {
    String? token = await getToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    final response = await http.get(
      Uri.parse('http://localhost:5062/api/HistorialNeumatico/ExistenDosPinchazos/$idNeumatico'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result == true; // Retorna true si existen dos pinchazos, de lo contrario false
    } else {
      return false;
    }
  }

  // Función para añadir una bitácora
  static Future<bool> addBitacora(int idNeumatico, int userId, int? codigo, int? estado, String observacion) async {
    String? token = await getToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    final data = {
      "idNeumatico": idNeumatico,
      "idUsuario": userId,
      "codigo": codigo,
      "fecha": DateTime.now().toIso8601String(),
      "estado": 1,
      "observacion": observacion,
    };


    final response = await http.post(
      Uri.parse('http://localhost:5062/api/HistorialNeumatico'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );


    return response.statusCode == 201;
  }
}
