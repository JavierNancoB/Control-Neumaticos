import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/movil_modificar.dart'; // Asegúrate de tener un modelo 'Movil'.
import 'package:shared_preferences/shared_preferences.dart';

class MovilService {
  final String baseUrl = 'http://localhost:5062/api/Movil';

  // Obtener el token de SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Devuelve el token almacenado
  }

  Future<int?> _getIdUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Devuelve el ID de usuario almacenado
  }
  // Obtener el móvil por patente
  Future<Movil?> getMovilByPatente(String patente) async {
  try {
    final token = await _getToken();  // Obtener el token
    final idUsuario = await _getIdUsuario();  // Obtener el ID de usuario
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/GetMovilByPatente?patente=$patente&idUsuario=$idUsuario'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // Agregar el token al encabezado
      },
    );

    print("Respuesta de la API: ${response.body}"); // Imprimir la respuesta para ver qué llega

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("JSON recibido: $jsonResponse"); // Ver el JSON antes de convertirlo

      // Verificar si los campos necesarios están presentes
      return Movil.fromJson(jsonResponse);  // Asegúrate de tener el modelo 'Movil' bien definido
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      throw Exception('Error al obtener los datos del móvil');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Error al obtener los datos del móvil: $e');
  }
}
Future<bool> modificarDatosMovil(String patenteOrigen, Movil movil) async {
  try {
    // Construcción de la URL con los parámetros en la query
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    final uri = Uri.parse('$baseUrl/ModificarMovilPorPatente')
        .replace(queryParameters: {
      'patenteActual': patenteOrigen,  // Patente actual
      'patenteNueva': movil.patente,   // Patente nueva (o la que quieras asignar)
      'marca': movil.marca,
      'modelo': movil.modelo,
      'ejes': movil.ejes.toString(),
      'cantidadNeumaticos': movil.cantidadNeumaticos.toString(),
      'tipoMovil': movil.tipoMovil.toString(),
    });

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // No olvides el token de autorización
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      print("Error: Móvil no encontrado");
      return false;
    } else if (response.statusCode == 204) {
      print("Móvil modificado con éxito");
      return true;
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Error al modificar los datos del móvil: $e');
  }
}



}
