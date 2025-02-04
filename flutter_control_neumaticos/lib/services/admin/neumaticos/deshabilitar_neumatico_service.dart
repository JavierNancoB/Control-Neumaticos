import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeshabilitarNeumaticoService {
  static const String _baseUrl = 'http://localhost:5062/api';

  // Método para modificar el estado de un neumático por su código NFC
  static Future<void> modificarEstadoNeumatico(String codigo, int estado, int confirmacionMovil) async {
    print('Iniciando modificarEstadoNeumatico con codigo: $codigo, estado: $estado y confirmacionMovil: $confirmacionMovil');
    final token = await _getToken();
    final userId = await _getUserId();
    if (token == null) {
      print('Token no encontrado.');
      throw Exception('Token no encontrado.');
    }

    // Añadir confirmacionMovil como parámetro adicional en la URL
    final url = '$_baseUrl/Neumaticos/ModificarEstadoPorCodigo?idUsuario=$userId&codigo=$codigo&estado=$estado&confirmacionMovil=$confirmacionMovil';
    print('URL construida: $url');
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Código de respuesta: ${response.statusCode}');
    if (response.statusCode != 204) {
      print('Error al modificar el estado del neumático. Respuesta: ${response.body}');
      throw Exception('Error al modificar el estado del neumático.');
    } else {
      print('Estado del neumático modificado exitosamente.');
    }
  }

  // Método reutilizable para obtener el token de SharedPreferences
  static Future<String?> _getToken() async {
    print('Obteniendo token de SharedPreferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token obtenido: $token');
    return token;
  }

  static Future<int> _getUserId() async {
    print("Obteniendo userId...");
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    print("UserId obtenido: $userId");
    return userId;
  }
}
