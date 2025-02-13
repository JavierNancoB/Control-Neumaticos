import 'dart:convert'; // Importa la librería para convertir objetos en formato JSON.
import 'package:http/http.dart' as http; // Importa la librería para realizar solicitudes HTTP.
import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería para acceder a las preferencias compartidas (datos locales).
import '../../../models/config.dart';

class BitacoraService {
  static final String baseUrl = '${Config.awsUrl}/api';
  // Método estático para obtener el token almacenado en SharedPreferences.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance(); // Accede a las preferencias compartidas.
    final token = prefs.getString('token'); // Obtiene el token almacenado.
    return token; // Retorna el token.
  }

  // Método estático para obtener el ID del usuario desde las preferencias compartidas.
  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance(); // Accede a las preferencias compartidas.
    final userId = prefs.getInt('userId') ?? 1; // Obtiene el ID del usuario o 1 si no existe.
    return userId; // Retorna el ID del usuario.
  }

  // Método estático que verifica si existen dos pinchazos en un neumático específico.
  static Future<bool> existenDosPinchazos(int idNeumatico) async {
    String? token = await getToken(); // Obtiene el token de las preferencias.
    if (token == null || token.isEmpty) { // Si no existe el token, retorna false.
      return false;
    }

    // Realiza una solicitud GET a la API para verificar si existen dos pinchazos.
    final response = await http.get(
      Uri.parse('$baseUrl/HistorialNeumatico/ExistenDosPinchazos/$idNeumatico'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Incluye el token en los encabezados de la solicitud.
      },
    );

    // Si la respuesta es exitosa (código 200), procesa la respuesta y devuelve el resultado.
    if (response.statusCode == 200) {
      final result = json.decode(response.body); // Convierte la respuesta en formato JSON.
      return result == true; // Retorna true si existen dos pinchazos, de lo contrario false.
    } else {
      return false; // Si la respuesta no es exitosa, retorna false.
    }
  }

  // Método estático para añadir una nueva bitácora.
  static Future<bool> addBitacora(int idNeumatico, int userId, int? codigo, int? estado, String observacion) async {
    String? token = await getToken(); // Obtiene el token de las preferencias.
    if (token == null || token.isEmpty) { // Si no existe el token, retorna false.
      return false;
    }

    // Prepara los datos para crear la bitácora.
    final data = {
      "idNeumatico": idNeumatico,
      "idUsuario": userId,
      "codigo": codigo,
      "fecha": DateTime.now().toIso8601String(), // Fecha actual en formato ISO 8601.
      "estado": 1, // Estado de la bitácora, por defecto 1.
      "observacion": observacion, // Observación proporcionada.
    };

    // Realiza una solicitud POST a la API para añadir la bitácora.
    final response = await http.post(
      Uri.parse('$baseUrl/HistorialNeumatico'),
      headers: {
        'Content-Type': 'application/json', // Indica que el cuerpo de la solicitud es en formato JSON.
        'Authorization': 'Bearer $token', // Incluye el token en los encabezados.
      },
      body: json.encode(data), // Convierte los datos en formato JSON y los envía en el cuerpo de la solicitud.
    );

    // Si la respuesta es exitosa (código 201), retorna true, de lo contrario false.
    return response.statusCode == 201;
  }
}
