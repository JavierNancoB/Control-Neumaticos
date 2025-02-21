import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/admin/movil_estado.dart';
import '../../../models/config.dart';

class MovilService {
  final String baseUrl = '${Config.awsUrl}/api/Movil';

  // Cambiar el estado del móvil y eliminar neumáticos si es necesario
  Future<bool> cambiarEstadoMovil(String patente, EstadoMovil estado) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  int? idUsuario = prefs.getInt('userId');

  if (token == null) {
    throw Exception('Token no encontrado');
  }


  final response = await http.put(
    
    // Uri.parse('$baseUrl/CambiaEstadoMovilPorPatente?patente=$patente&estado=${estado.id}&idUsuario=$idUsuario&eliminarNeumaticos=$eliminarNeumaticos'),
    Uri.parse('$baseUrl/CambiaEstadoMovilPorPatente?patente=$patente&estado=${estado.id}&idUsuario=$idUsuario'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    
  );

  if (response.statusCode == 204) {
    return true; // Estado cambiado con éxito
  } else if (response.statusCode == 404) {
    throw Exception('Camión no encontrado');
  } else {
    throw Exception('Error al modificar el estado');
  }
}


  Future<List<String>> fetchPatentesSugeridas(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("No se encontró el token de autenticación.");
    }

    final url = Uri.parse('$baseUrl/BuscarMovilesPorPatente?query=$query');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Error al obtener las sugerencias de patentes.');
    }
  }
}
