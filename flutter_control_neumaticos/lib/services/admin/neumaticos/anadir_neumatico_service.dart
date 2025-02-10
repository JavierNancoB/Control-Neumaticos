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
    // Obtener userId almacenado en SharedPreferences
  static Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    return userId;
  }


  static Future<int?> getMovilByPatente(String patente) async {
    final token = await getToken();
    if (token == null) return null;


    final response = await http.get(
      Uri.parse('$_baseUrl/Movil/GetMovilByPatente?patente=$patente'),
      headers: {'Authorization': 'Bearer $token'},
    );


    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Acceder al campo correctamente, con la misma estructura de la respuesta
      if (data['iD_MOVIL'] != null) {
        return data['iD_MOVIL'];
      } else {
        return null;
      }
    } else {
      throw Exception('Error al obtener el móvil por patente. Respuesta: ${response.statusCode}');
    }
  }

  // Nueva función para verificar si la posición es única
  static Future<bool> verificarPosicionUnica(String patente, int posicion) async {
    final token = await getToken();
    // Debugging

    final url = '$_baseUrl/Neumaticos/verificarSiPosicioneEsUnicaConPatente?idMovil=$patente&posicion=$posicion';
    // Debugging

    final response = await http.post(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    // Debugging
    // Debugging

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data == true;
    } else {
      throw Exception('Error al verificar si la posición es única');
    }
  }

  static Future<void> addNeumatico(NeumaticoCrear neumatico, String? patente) async {
    final userId = await _getUserId();
    final token = await getToken();
    if (token == null) throw Exception('Token no encontrado.');

    // Si no hay patente, el movilId será nulo.
    final movilId = patente != null && patente.isNotEmpty ? await getMovilByPatente(patente) : null;

    // Verificar si la posición es única antes de continuar
    if (movilId != null) {
      final esPosicionUnica = await verificarPosicionUnica(patente!, neumatico.ubicacion);
      if (!esPosicionUnica) {
        throw Exception('La posición ya está ocupada por otro neumático en este vehículo');
      }
    }

    // Imprimir los valores que estamos usando

    // Crear el objeto Neumatico con el formato esperado para el POST.
    final neumaticoData = {
      'CODIGO': neumatico.codigo,
      'UBICACION': neumatico.ubicacion,
      'ID_MOVIL': movilId,  // Puede ser null si no hay patente
      'ID_BODEGA': 1,  // Ajusta esto según la lógica de tu aplicación
      'FECHA_INGRESO': neumatico.fechaIngreso.toIso8601String(),
      'ESTADO': neumatico.estado,
      'KM_TOTAL': neumatico.kilometrajeTotal,
      'TIPO_NEUMATICO': neumatico.tipo,
    };

    // Imprimir los datos que se enviarán a la API

    final response = await http.post(
      Uri.parse('$_baseUrl/Neumaticos?idUsuario=$userId'),
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
