import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/neumatico_crear.dart';

class NeumaticoService {
  static const String _baseUrl = 'http://localhost:5062/api';

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<int?> getMovilByPatente(String patente) async {
  final token = await getToken();
  if (token == null) return null;

  print('Buscando Movil por patente: $patente');

  final response = await http.get(
    Uri.parse('$_baseUrl/Movil/GetMovilByPatente?patente=$patente'),
    headers: {'Authorization': 'Bearer $token'},
  );

  print('Respuesta de la API: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Datos recibidos: $data');

    // Acceder al campo correctamente, con la misma estructura de la respuesta
    if (data['iD_MOVIL'] != null) {
      print('Movil encontrado con ID: ${data['iD_MOVIL']}');
      return data['iD_MOVIL'];
    } else {
      print('No se encontró el ID del móvil en la respuesta.');
      return null;
    }
  } else {
    throw Exception('Error al obtener el móvil por patente. Respuesta: ${response.statusCode}');
  }
}



  static Future<void> addNeumatico(NeumaticoCrear neumatico, String? patente) async {
    final token = await getToken();
    if (token == null) throw Exception('Token no encontrado.');

    // Si no hay patente, el movilId será nulo.
    final movilId = patente != null && patente.isNotEmpty ? await getMovilByPatente(patente) : null;

    // Imprimir los valores que estamos usando
    print('Token: $token');
    print('Patente: $patente');
    print('MovilId: $movilId');
    print('Neumatico Datos:');
    print('Codigo: ${neumatico.codigo}');
    print('Ubicacion: 1');  // Ajusta según tu lógica de ubicaciones
    print('Fecha Ingreso: ${neumatico.fechaIngreso.toIso8601String()}');
    print('Estado: ${neumatico.estado}');
    print('Kilometraje Total: ${neumatico.kilometrajeTotal}');
    print('Tipo Neumatico: ${neumatico.tipo}');

    // Crear el objeto Neumatico con el formato esperado para el POST.
    final neumaticoData = {
      'CODIGO': neumatico.codigo,
      'UBICACION': 1,  // Ajusta esto según la lógica de tu aplicación
      'ID_MOVIL': movilId,  // Puede ser null si no hay patente
      'ID_BODEGA': 1,  // Ajusta esto según la lógica de tu aplicación
      'FECHA_INGRESO': neumatico.fechaIngreso.toIso8601String(),
      'ESTADO': neumatico.estado,
      'KM_TOTAL': neumatico.kilometrajeTotal,
      'TIPO_NEUMATICO': neumatico.tipo,
    };

    // Imprimir los datos que se enviarán a la API
    print('Datos a enviar a la API:');
    print(neumaticoData);

    final response = await http.post(
      Uri.parse('$_baseUrl/Neumaticos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(neumaticoData),
    );

    // Verificar el código de estado y manejar los errores
    if (response.statusCode != 201) {
      if (response.statusCode == 400) {
        throw Exception('El código del neumático ya está registrado.');
      } else {
        throw Exception('Error al añadir el neumático. Respuesta: ${response.statusCode}');
      }
    }
  }
}
