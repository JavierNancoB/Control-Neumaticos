import 'dart:convert';
import 'package:http/http.dart' as http;

class RecoverPasswordService {
  Future<void> enviarSolicitud(String correo) async {
    if (correo.isEmpty) {
      print('Correo vacío');
      throw Exception('Por favor, ingresa tu correo electrónico.');
    }

    try {
      print('Enviando solicitud de recuperación para el correo: $correo');

      final response = await http.post(
        Uri.parse('http://localhost:5062/api/solicitudcorreos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'CorreoSolicitante': correo}),
      );

      print('Respuesta recibida con código de estado: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');

      if (response.statusCode != 200) {
        // Si la respuesta es un error, lanzamos una excepción con el mensaje de error
        final errorMessage = await _getErrorMessage(response);
        print('Error en la respuesta: $errorMessage');
        throw Exception(errorMessage);
      }

      print('Solicitud enviada correctamente');
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      throw Exception('Error al enviar la solicitud: $e');
    }
  }

  Future<String> _getErrorMessage(http.Response response) async {
    try {
      // Intentamos parsear el cuerpo como JSON
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      return errorResponse['message'] ?? 'Ha ocurrido un error desconocido.';
    } catch (e) {
      // Si ocurre un error al parsear como JSON, devolvemos el mensaje tal cual
      print('Respuesta no es JSON, devolviendo mensaje directo');
      return response.body;
    }
  }
}
