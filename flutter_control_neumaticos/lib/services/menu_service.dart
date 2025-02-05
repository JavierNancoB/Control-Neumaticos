import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> checkAlertaPendiente() async {
  final response = await http.get(Uri.parse('http://localhost:5062/api/Alerta/HasAlertaPendiente'));

  if (response.statusCode == 200) {
    // Decodificar la respuesta JSON
    return json.decode(response.body);
  } else {
    throw Exception('Error al verificar alerta pendiente');
  }
}
