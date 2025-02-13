import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';

class DeshabilitarNeumaticoService {
  static final String _baseUrl = '${Config.awsUrl}/api';

  // Método para modificar el estado de un neumático por su código NFC
  static Future<void> modificarEstadoNeumatico(String codigo, int estado, int confirmacionMovil) async {
    final token = await _getToken();
    final userId = await _getUserId();
    if (token == null) {
      throw Exception('Token no encontrado.');
    }

    // Añadir confirmacionMovil como parámetro adicional en la URL
    final url = '$_baseUrl/Neumaticos/ModificarEstadoPorCodigo?idUsuario=$userId&codigo=$codigo&estado=$estado&confirmacionMovil=$confirmacionMovil';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Error al modificar el estado del neumático.');
    } else {
    }
  }

  // Método reutilizable para obtener el token de SharedPreferences
  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  static Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    return userId;
  }
}
