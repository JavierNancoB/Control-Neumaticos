import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../models/config.dart';

Future<bool> checkAlertaPendiente() async {
  const String baseUrl = '${Config.awsUrl}/api';
  final response = await http.get(Uri.parse('$baseUrl/Alerta/HasAlertaPendiente'));

  if (response.statusCode == 200) {
    // Decodificar la respuesta JSON
    return json.decode(response.body);
  } else {
    throw Exception('Error al verificar alerta pendiente');
  }
}
