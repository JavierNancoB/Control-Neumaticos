import 'dart:convert';
import 'package:http/http.dart' as http;

class VerBitacoraServices {
  // Función para obtener las bitácoras de un neumático
  static Future<List<Map<String, dynamic>>> getBitacoraByNeumatico(int idNeumatico) async {
    print('Iniciando solicitud para obtener bitácoras del neumático con ID: $idNeumatico');
    
    final response = await http.get(
      Uri.parse('http://localhost:5062/api/HistorialNeumatico/GetHistorialNeumaticoByNeumaticoIDAndEstado?idNeumatico=$idNeumatico&estado=1'),
    );

    print('Respuesta recibida con código de estado: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      print('Respuesta exitosa, procesando datos...');
      List<dynamic> data = json.decode(response.body);
      print('Datos decodificados: $data');
      
      List<Map<String, dynamic>> bitacoras = data.map((item) => {
        'codigo': item['codigo'],
        'fecha': item['fecha'],
        'estado': item['estado'],
        'id': item['id'],
      }).toList();
      
      print('Bitácoras procesadas: $bitacoras');
      return bitacoras;
    } else {
      print('Error al cargar los datos: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
