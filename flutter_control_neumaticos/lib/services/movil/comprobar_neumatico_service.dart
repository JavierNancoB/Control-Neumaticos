import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';

class HistorialMovilService {
  // URL base del servicio de historial móvil
  static const String _baseUrl = '${Config.awsUrl}/api/HistorialMovil/patente';

  // Método para registrar el historial
  Future<void> registrarHistorial({
    required String patente,
    required List<String> codigosNoEscaneados,
    required List<String> codigosNoEncontrados,
  }) async {
    try {
      // Obtener instancia de SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Intentar obtener el ID de usuario almacenado en SharedPreferences
      int? idUsuario = prefs.getInt('userId');

      // Si no se encuentra el ID de usuario, lanzar una excepción
      if (idUsuario == null) {
        throw Exception('IDUsuario no encontrado en SharedPreferences');
      }

      // Inicializar el código y la lista de observaciones
      int codigo = 1;
      List<String> observaciones = [];

      // Preparar las observaciones basadas en los códigos no encontrados y no escaneados
      if (codigosNoEncontrados.isNotEmpty) {
        observaciones.add('No encontrados: ${codigosNoEncontrados.join(', ')}');
      }
      if (codigosNoEscaneados.isNotEmpty) {
        observaciones.add('No escaneados: ${codigosNoEscaneados.join(', ')}');
      }

      // Determinar el código basado en las observaciones
      if (codigosNoEscaneados.isNotEmpty && codigosNoEncontrados.isNotEmpty) {
        codigo = 3;
      } else if (codigosNoEscaneados.isNotEmpty || codigosNoEncontrados.isNotEmpty) {
        codigo = 2;
      }

      // Crear la observación final
      String observacion = observaciones.isEmpty ? 'Sin novedad' : observaciones.join(' | ');

      // Preparar el payload para la solicitud POST
      final Map<String, dynamic> payload = {
        'IDUsuario': idUsuario.toString(),
        'CODIGO': codigo,
        'FECHA': DateTime.now().toIso8601String(),
        'ESTADO': 1,
        'OBSERVACION': observacion,
      };

      // Enviar solicitud POST al servidor
      final response = await http.post(
        Uri.parse('$_baseUrl/$patente'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      // Verificar si la respuesta no es exitosa (código 201)
      if (response.statusCode != 201) {
        throw Exception('Error al registrar historial: ${response.body}');
      }
    } catch (e) {
      // Capturar y lanzar cualquier excepción que ocurra durante el proceso
      throw Exception('Error en HistorialMovilService: $e');
    }
  }
}
