import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/movil_estado.dart';

class MovilService {
  final String baseUrl = 'http://localhost:5062/api/Movil';

  // Cambiar el estado del móvil y eliminar neumáticos si es necesario
  Future<bool> cambiarEstadoMovil(String patente, EstadoMovil estado, bool eliminarNeumaticos) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  int? idUsuario = prefs.getInt('userId');

  if (token == null) {
    throw Exception('Token no encontrado');
  }

  print("Haciendo PUT a la API...");
  print("Patente: $patente");
  print("Estado: ${estado.id} (${estado.descripcion})");
  print("Eliminar Neumáticos: $eliminarNeumaticos");

  final response = await http.put(
    
    Uri.parse('$baseUrl/CambiaEstadoMovilPorPatente?patente=$patente&estado=${estado.id}&idUsuario=$idUsuario&eliminarNeumaticos=$eliminarNeumaticos'),
    
    headers: {
      'Authorization': 'Bearer $token',
    },
    
  );
  print("URL: $baseUrl/CambiaEstadoMovilPorPatente?patente=$patente&estado=${estado.id}&idUsuario=$idUsuario&eliminarNeumaticos=$eliminarNeumaticos");

  if (response.statusCode == 204) {
    print("Estado cambiado con éxito");
    return true; // Estado cambiado con éxito
  } else if (response.statusCode == 404) {
    print("Error: Camión no encontrado");
    throw Exception('Camión no encontrado');
  } else {
    print("Error en la respuesta: ${response.statusCode}");
    throw Exception('Error al modificar el estado');
  }
}


  Future<List<String>> fetchPatentesSugeridas(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("No se encontró el token de autenticación.");
    }

    final url = Uri.parse('http://localhost:5062/api/Movil/BuscarMovilesPorPatente?query=$query');
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
