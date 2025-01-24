import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeshabilitarNeumaticoService {
  static const String _baseUrl = 'http://localhost:5062/api';

  // Método para modificar el estado de un neumático por su código NFC
  static Future<void> modificarEstadoNeumatico(String codigo, int estado) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token no encontrado.');

    final url = '$_baseUrl/Neumaticos/ModificarEstadoPorCodigo?codigo=$codigo&estado=$estado';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Error al modificar el estado del neumático.');
    }
  }

  // Método reutilizable para obtener el token de SharedPreferences
  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
