import 'dart:convert'; // Importa la librería para convertir objetos en formato JSON.
import 'package:http/http.dart' as http; // Importa la librería para realizar solicitudes HTTP.
import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería para acceder a las preferencias compartidas (datos locales).
import '../../models/usuario_alertas.dart'; // Importa el modelo de usuario.
import '../../../models/config.dart';


class AlertaDetailsService {
  static final String baseUrl = '${Config.awsUrl}/api'; // URL base de la API.

  // Método privado para obtener el token de las preferencias compartidas.
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance(); // Accede a las preferencias compartidas.
    final token = prefs.getString('token') ?? ''; // Obtiene el token o un string vacío si no existe.
    return token; // Retorna el token.
  }

  // Método privado para obtener el ID del usuario desde las preferencias compartidas.
  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance(); // Accede a las preferencias compartidas.
    final userId = prefs.getInt('userId') ?? 0; // Obtiene el ID del usuario o 0 si no existe.
    return userId; // Retorna el ID del usuario.
  }

  // Método para obtener los datos de un usuario por su ID.
  Future<Usuario> getUsuarioById(int usuarioId) async {
    final token = await _getToken(); // Obtiene el token de las preferencias.
    // Realiza una solicitud GET a la API para obtener los datos del usuario.
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/$usuarioId'), // Construye la URL con el ID del usuario.
      headers: {'Authorization': 'Bearer $token'}, // Agrega el token al encabezado de la solicitud.
    );

    // Si la respuesta es exitosa (código 200), procesa los datos y los convierte en un objeto Usuario.
    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Convierte la respuesta en un mapa de datos.
      return Usuario.fromJson(data); // Retorna un objeto Usuario.
    } else {
      throw Exception("Error al obtener el usuario con ID $usuarioId"); // Lanza una excepción si hay error.
    }
  }

  // Método para obtener los datos de una alerta por su ID.
  Future<Map<String, dynamic>> getAlertaById(int id) async {
    final token = await _getToken(); // Obtiene el token de las preferencias.
    // Realiza una solicitud GET a la API para obtener los detalles de la alerta.
    final response = await http.get(Uri.parse('$baseUrl/Alerta/$id'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return json.decode(response.body); // Si la respuesta es exitosa, retorna los datos de la alerta.
    } else {
      throw Exception("Error al obtener la alerta con ID $id"); // Lanza una excepción si la respuesta no es exitosa.
    }
  }
  
  // Método para obtener los detalles de un neumático por su ID.
  Future<Map<String, dynamic>> getNeumaticoById(int idNeumatico) async {
    final token = await _getToken(); // Obtiene el token de las preferencias.
    // Realiza una solicitud GET a la API para obtener los detalles del neumático.
    final response = await http.get(Uri.parse('$baseUrl/neumaticos/$idNeumatico'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return json.decode(response.body); // Si la respuesta es exitosa, retorna los datos del neumático.
    } else {
      throw Exception("Error al obtener el neumático con ID $idNeumatico"); // Lanza una excepción si la respuesta no es exitosa.
    }
  }

  // Método para cambiar el estado de una alerta.
  Future<void> cambiarEstadoAlerta(int alertaId, int estado) async {
    final token = await _getToken(); // Obtiene el token de las preferencias.
    final userId = await _getUserId(); // Obtiene el ID del usuario desde las preferencias.

    // Construye la URL para la solicitud PUT con los parámetros necesarios.
    final url = Uri.parse(
        'http://localhost:5062/api/Alerta/CambiarEstado?id=$alertaId&estado=$estado&idUsuario=$userId');

    // Realiza la solicitud PUT a la API para cambiar el estado de la alerta.
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Agrega el token al encabezado de la solicitud.
      },
    );

    // Si la respuesta es exitosa (código 204), no hace nada. Si no es exitosa, lanza una excepción.
    if (response.statusCode == 204) {
    } else {
      throw Exception("Error al cambiar el estado de la alerta con ID $alertaId");
    }
  }
}
