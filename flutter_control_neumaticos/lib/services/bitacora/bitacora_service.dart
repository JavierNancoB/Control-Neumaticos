import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BitacoraService {
  // Obtener el token de SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Obtener el userId desde SharedPreferences
  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 1; // Default userId 1 if not found
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
      "estado": estado,
      "observacion": observacion,
    };

    final response = await http.post(
      Uri.parse('http://localhost:5062/api/BitacoraNeumatico'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    return response.statusCode == 201;
  }
}
