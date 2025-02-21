import 'dart:convert'; // Importa la librería para convertir objetos en formato JSON.
import 'package:http/http.dart' as http; // Importa la librería para realizar solicitudes HTTP.
import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería para acceder a las preferencias compartidas (datos locales).
import '../../models/menu/alertas.dart'; // Importa el modelo de alerta.
import '../../models/admin/movil.dart'; // Importa el modelo de móvil.
import '../../../models/config.dart';

class AlertaService {
  static final String baseUrl = "${Config.awsUrl}/api"; // URL base de la API.

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

  // Método para obtener los detalles de una alerta por su ID.
  Future<Alerta> getAlertaById(int id) async {
    final token = await _getToken(); // Obtiene el token de las preferencias.
    // Realiza una solicitud GET a la API para obtener los detalles de la alerta.
    final response = await http.get(
      Uri.parse('$baseUrl/Alerta/$id'), // Construye la URL con el ID de la alerta.
      headers: {'Authorization': 'Bearer $token'}, // Agrega el token al encabezado de la solicitud.
    );

    // Si la respuesta es exitosa (código 200), procesa los datos y los convierte en un objeto Alerta.
    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Convierte la respuesta en un mapa de datos.
      return Alerta.fromJson(data); // Retorna un objeto Alerta.
    } else {
      throw Exception("Error al obtener la alerta con ID $id"); // Lanza una excepción si hay error.
    }
  }

  // Método para obtener las alertas pendientes desde un endpoint específico.
  Future<List<Alerta>> getAlertasPendientes(String endpoint) async {
    final token = await _getToken(); // Obtiene el token de las preferencias.
    // Realiza una solicitud GET a la API para obtener las alertas pendientes.
    final response = await http.get(
      Uri.parse('$baseUrl/Alerta/$endpoint'), // Construye la URL con el endpoint proporcionado.
      headers: {'Authorization': 'Bearer $token'}, // Agrega el token al encabezado de la solicitud.
    );

    // Si la respuesta es exitosa (código 200), procesa los datos y los convierte en una lista de objetos Alerta.
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List; // Convierte la respuesta en una lista de mapas de datos.
      return data.map((json) => Alerta.fromJson(json)).toList(); // Retorna una lista de objetos Alerta.
    } else {
      throw Exception("Error al cargar las alertas pendientes"); // Lanza una excepción si la respuesta no es exitosa.
    }
  }

  // Método para obtener los detalles de un móvil por su ID.
  Future<Movil> getMovilById(int idMovil) async {
    final token = await _getToken(); // Obtiene el token de las preferencias.
    // Realiza una solicitud GET a la API para obtener los detalles del móvil.
    final response = await http.get(
      Uri.parse('$baseUrl/movil/$idMovil'), // Construye la URL con el ID del móvil.
      headers: {'Authorization': 'Bearer $token'}, // Agrega el token al encabezado de la solicitud.
    );

    // Si la respuesta es exitosa (código 200), procesa los datos y los convierte en un objeto Movil.
    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Convierte la respuesta en un mapa de datos.
      return Movil.fromJson(data); // Retorna un objeto Movil.
    } else {
      throw Exception("Error al obtener el móvil con ID $idMovil"); // Lanza una excepción si la respuesta no es exitosa.
    }
  }

  // Método para cambiar el estado de una alerta.
  Future<void> cambiarEstadoAlerta(int alertaId, int estado) async {
    final token = await _getToken(); // Obtiene el token de las preferencias.
    final userId = await _getUserId(); // Obtiene el ID del usuario desde las preferencias.

    // Construye la URL para la solicitud PUT con los parámetros necesarios.
    final url = Uri.parse(
        '$baseUrl/Alerta/CambiarEstado?id=$alertaId&estado=$estado&idUsuario=$userId');

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
