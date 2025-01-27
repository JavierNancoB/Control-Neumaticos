import 'dart:convert';
import 'package:http/http.dart' as http;

class VerBitacoraServices {
  // Función para obtener las bitácoras de un neumático
  static Future<List<Map<String, dynamic>>> getBitacoraByNeumatico(int idNeumatico) async {
    final response = await http.get(
      Uri.parse('http://localhost:5062/api/BitacoraNeumatico/GetBitacoraByNeumaticoID?idNeumatico=$idNeumatico'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => {
        'codigo': item['codigo'],
        'fecha': item['fecha'],
        'estado': item['estado'],
        'id': item['id'],
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
