import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistorialMovilService {
  static const String _baseUrl = 'http://localhost:5062/api/HistorialMovil/patente';

  Future<void> registrarHistorial({
    required String patente,
    required List<String> codigosNoEscaneados,
    required List<String> codigosNoEncontrados,
  }) async {
    try {
      // Obtener SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      print('SharedPreferences obtenidas');

      // Intentar obtener el ID de usuario
      int? idUsuario = prefs.getInt('userId');
      print('IDUsuario recuperado: $idUsuario');

      if (idUsuario == null) {
        print('Error: IDUsuario no encontrado en SharedPreferences');
        throw Exception('IDUsuario no encontrado en SharedPreferences');
      }

      int codigo = 1;
      List<String> observaciones = [];

      // Preparar las observaciones
      if (codigosNoEncontrados.isNotEmpty) {
        observaciones.add('No encontrados: ${codigosNoEncontrados.join(', ')}');
      }
      if (codigosNoEscaneados.isNotEmpty) {
        observaciones.add('No escaneados: ${codigosNoEscaneados.join(', ')}');
      }

      if (codigosNoEscaneados.isNotEmpty && codigosNoEncontrados.isNotEmpty) {
        codigo = 3;
      } else if (codigosNoEscaneados.isNotEmpty || codigosNoEncontrados.isNotEmpty) {
        codigo = 2;
      }

      String observacion = observaciones.isEmpty ? 'Sin novedad' : observaciones.join(' | ');
      print('Observación: $observacion');

      final Map<String, dynamic> payload = {
        'IDUsuario': idUsuario.toString(),
        'CODIGO': codigo,
        'FECHA': DateTime.now().toIso8601String(),
        'ESTADO': 1,
        'OBSERVACION': observacion,
      };

      print('Payload preparado: $payload');

      // Enviar solicitud POST
      final response = await http.post(
        Uri.parse('$_baseUrl/$patente'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Respuesta del servidor: ${response.body}');

      if (response.statusCode != 201) {
        print('Error en respuesta: ${response.body}');
        throw Exception('Error al registrar historial: ${response.body}');
      }
    } catch (e) {
      print('Error en HistorialMovilService: $e');
      throw Exception('Error en HistorialMovilService: $e');
    }
  }
}
