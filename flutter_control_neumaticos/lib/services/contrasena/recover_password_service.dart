import 'dart:convert'; // Importa la librería para convertir objetos en formato JSON.
import 'package:http/http.dart' as http; // Importa la librería para realizar solicitudes HTTP.
import '../../../models/config.dart';

class RecoverPasswordService {
  static final String baseUrl = '${Config.awsUrl}/api';
  // Método para enviar una solicitud de recuperación de contraseña con el correo del usuario.
  Future<void> enviarSolicitud(String correo) async {
    // Si el correo está vacío, lanza una excepción.
    if (correo.isEmpty) {
      throw Exception('Por favor, ingresa tu correo electrónico.');
    }

    try {
      // Realiza una solicitud POST al servidor con el correo proporcionado.
      final response = await http.post(
        Uri.parse('$baseUrl/solicitudcorreos'), // URL de la API de solicitud de correo.
        headers: {'Content-Type': 'application/json'}, // Define el tipo de contenido como JSON.
        body: json.encode({'CorreoSolicitante': correo}), // Envía el correo como parte del cuerpo de la solicitud.
      );

      // Si la respuesta no es exitosa (código distinto de 200), maneja el error.
      if (response.statusCode != 200) {
        // Si la respuesta es un error, lanza una excepción con el mensaje de error obtenido.
        final errorMessage = await _getErrorMessage(response);
        throw Exception(errorMessage);
      }

    } catch (e) {
      // Si ocurre un error al realizar la solicitud, lanza una excepción con el mensaje de error.
      throw Exception('Error al enviar la solicitud: $e');
    }
  }

  // Método privado para obtener el mensaje de error de la respuesta del servidor.
  Future<String> _getErrorMessage(http.Response response) async {
    try {
      // Intenta parsear el cuerpo de la respuesta como JSON.
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      // Retorna el mensaje de error o un mensaje por defecto si no se encuentra el mensaje.
      return errorResponse['message'] ?? 'Ha ocurrido un error desconocido.';
    } catch (e) {
      // Si ocurre un error al parsear como JSON, retorna el cuerpo de la respuesta tal cual.
      return response.body;
    }
  }
}
