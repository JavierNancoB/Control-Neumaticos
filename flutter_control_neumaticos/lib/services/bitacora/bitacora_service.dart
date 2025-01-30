import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BitacoraService {
  // Obtener el token de SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token obtenido: $token');
    return token;
  }

  // Obtener el userId desde SharedPreferences
  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 1; // Default userId 1 if not found
    print('UserId obtenido: $userId');
    return userId;
  }

  // Función para añadir una bitácora
  static Future<bool> addBitacora(int idNeumatico, int userId, int? codigo, int? estado, String observacion) async {
    print('Iniciando addBitacora');
    String? token = await getToken();
    if (token == null || token.isEmpty) {
      print('Token no encontrado o vacío');
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

    print('Datos a enviar: $data');

    final response = await http.post(
      Uri.parse('http://localhost:5062/api/HistorialNeumatico'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    print('Respuesta del servidor: ${response.statusCode} - ${response.body}');

    return response.statusCode == 201;
  }
}
