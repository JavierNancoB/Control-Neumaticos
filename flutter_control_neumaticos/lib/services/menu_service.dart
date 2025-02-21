import 'package:http/http.dart' as http; // Importa la biblioteca http para realizar solicitudes HTTP
import 'dart:convert'; // Importa la biblioteca convert para trabajar con JSON
import '../../../models/config.dart'; // Importa el archivo de configuración

// Función asincrónica que verifica si hay una alerta pendiente
Future<bool> checkAlertaPendiente() async {
  // Construye la URL base utilizando la configuración de AWS
  final String baseUrl = '${Config.awsUrl}/api';
  
  // Realiza una solicitud GET a la URL específica para verificar alertas pendientes
  final response = await http.get(Uri.parse('$baseUrl/Alerta/HasAlertaPendiente'));

  // Verifica si la respuesta tiene un código de estado 200 (OK)
  if (response.statusCode == 200) {
    // Decodifica la respuesta JSON y devuelve el resultado
    return json.decode(response.body);
  } else {
    // Si la respuesta no es 200, lanza una excepción con un mensaje de error
    throw Exception('Error al verificar alerta pendiente');
  }
}
