import 'dart:convert'; // Importa la librería para convertir objetos en formato JSON.
import 'package:http/http.dart' as http; // Importa la librería para realizar solicitudes HTTP.
import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería para acceder a las preferencias compartidas (datos locales).
import '../../models/bitacora_models.dart'; // Importa el modelo de la bitácora.
import '../../models/usuario_alertas.dart'; // Importa el modelo de usuario.
import '../../../models/config.dart';

class BitacoraServices {
  static final String baseUrl = '${Config.awsUrl}/api';
  // Función para obtener la bitácora por su ID
  static Future<Bitacora> fetchBitacoraData(int id) async {
    // Obtiene las preferencias compartidas (SharedPreferences) para acceder al token almacenado.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Obtiene el token de las preferencias.
    

    // Si no se encuentra el token, lanza una excepción.
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    // Crea la URL para la solicitud HTTP con el ID de la bitácora.
    final url = Uri.parse('$baseUrl/HistorialNeumatico/$id');
    // Realiza la solicitud GET a la API para obtener los datos de la bitácora.
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Agrega el token al encabezado de la solicitud.
      },
    );

    // Si la respuesta es exitosa (código 200), procesa la respuesta y devuelve la bitácora.
    if (response.statusCode == 200) {
      return Bitacora.fromJson(json.decode(response.body)); // Convierte la respuesta en un objeto Bitacora.
    } else {
      // Si la respuesta no es exitosa, lanza una excepción.
      throw Exception('Error al obtener la bitácora');
    }
  }

  // Función para obtener los datos del usuario por su ID
  static Future<Usuario> fetchUsuarioData(int usuarioId) async {
    // Obtiene las preferencias compartidas (SharedPreferences) para acceder al token almacenado.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Obtiene el token de las preferencias.

    // Si no se encuentra el token, lanza una excepción.
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    // Crea la URL para la solicitud HTTP con el ID del usuario.
    final url = Uri.parse('$baseUrl/usuarios/$usuarioId');
    // Realiza la solicitud GET a la API para obtener los datos del usuario.
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Agrega el token al encabezado de la solicitud.
      },
    );

    // Si la respuesta es exitosa (código 200), procesa la respuesta y devuelve el usuario.
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body)); // Convierte la respuesta en un objeto Usuario.
    } else {
      // Si la respuesta no es exitosa, lanza una excepción.
      throw Exception('Error al obtener el usuario');
    }
  }

  // Función para actualizar el estado de la bitácora
  static Future<void> updateBitacoraState(int id, int estado) async {
    // Obtiene las preferencias compartidas (SharedPreferences) para acceder al token almacenado.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Obtiene el token de las preferencias.

    // Si no se encuentra el token, lanza una excepción.
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    // Crea la URL para la solicitud PUT con el ID de la bitácora y el nuevo estado.
    final url = Uri.parse('$baseUrl/HistorialNeumatico/UpdateEstadoHistorialNeumatico/$id?estado=$estado');
    // Realiza la solicitud PUT a la API para actualizar el estado de la bitácora.
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Agrega el token al encabezado de la solicitud.
      },
    );

    // Si la respuesta no es exitosa (código distinto de 200), lanza una excepción.
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el estado de la bitácora');
    }
  }
}
