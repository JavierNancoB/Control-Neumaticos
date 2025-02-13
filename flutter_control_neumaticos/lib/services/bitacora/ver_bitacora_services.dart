import 'dart:convert'; // Importa la librería para convertir objetos en formato JSON.
import 'package:http/http.dart' as http; // Importa la librería para realizar solicitudes HTTP.
import '../../../models/config.dart';

class VerBitacoraServices {
  static final String baseUrl = '${Config.awsUrl}/api';
  // Función estática para obtener las bitácoras de un neumático específico.
  static Future<List<Map<String, dynamic>>> getBitacoraByNeumatico(int idNeumatico) async {
    
    // Realiza una solicitud GET a la API para obtener el historial de neumático con estado 1.
    final response = await http.get(
      Uri.parse('$baseUrl/HistorialNeumatico/GetHistorialNeumaticoByNeumaticoIDAndEstado?idNeumatico=$idNeumatico&estado=1'),
    );

    // Si la respuesta es exitosa (código 200), procesa los datos recibidos.
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body); // Convierte la respuesta JSON a un objeto Dart.

      // Mapea los datos de la respuesta a una lista de Mapas con las propiedades que se requieren.
      List<Map<String, dynamic>> bitacoras = data.map((item) => {
        'codigo': item['codigo'],  // Código de la bitácora.
        'fecha': item['fecha'],    // Fecha en la que se registró la bitácora.
        'estado': item['estado'],  // Estado de la bitácora.
        'id': item['id'],          // ID de la bitácora.
      }).toList();
      
      return bitacoras; // Retorna la lista de bitácoras mapeadas.
    } else {
      throw Exception('Failed to load data'); // Lanza una excepción si la respuesta no es exitosa.
    }
  }
}
