import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/neumatico_modifcar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NeumaticoService {
  // Obtiene el token desde SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token obtenido: $token'); // Debugging del token
    return token;
  }

  // Busca el neumático por código
  static Future<Neumatico?> fetchNeumaticoByCodigo(String codigo) async {
    final token = await _getToken();
    print('Token para la solicitud: $token'); // Debugging

    final url = 'http://localhost:5062/api/Neumaticos/GetNeumaticoByCodigo?codigo=$codigo';
    print('URL de la solicitud: $url'); // Debugging

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Estado de la respuesta: ${response.statusCode}'); // Debugging
    print('Cuerpo de la respuesta: ${response.body}'); // Debugging

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Datos decodificados: $data'); // Debugging

      try {
        final neumatico = Neumatico.fromJson(data);
        print('Objeto Neumatico creado: $neumatico'); // Debugging
        return neumatico;
      } catch (e) {
        print('Error al crear el objeto Neumatico: $e'); // Debugging
        throw Exception('Error al parsear los datos del neumático');
      }
    } else {
      throw Exception('Failed to load neumático');
    }
  }
  
  // Método para modificar un neumático
  static Future<void> modificarNeumatico(Neumatico neumatico, String patente) async {
    final token = await _getToken();
    print('Token para la solicitud: $token'); // Debugging

    final url =
        'http://localhost:5062/api/Neumaticos/ModificarNeumaticoPorCodigo?codigo=${neumatico.codigo}&ubicacion=${neumatico.ubicacion}&patente=${Uri.encodeComponent(patente)}&fechaIngreso=${neumatico.fechaIngreso.toIso8601String()}&fechaSalida=${neumatico.fechaSalida?.toIso8601String() ?? ''}&estado=${neumatico.estado}&kmTotal=${neumatico.kmTotal}&tipoNeumatico=${neumatico.tipoNeumatico}';

    print('URL de la solicitud: $url'); // Debugging

    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Estado de la respuesta: ${response.statusCode}'); // Debugging
    print('Cuerpo de la respuesta: ${response.body}'); // Debugging

    if (response.statusCode != 204) {
      throw Exception('Error al modificar neumático');
    }
  }

  
}
