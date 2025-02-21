import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';

// Función para obtener los datos de un neumático a partir de un código NFC
Future<Map<String, dynamic>> fetchNeumaticoData(String nfcData) async {
  // Obtener instancia de SharedPreferences para acceder al token almacenado
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final String baseUrl = '${Config.awsUrl}/api';

  // Verificar si el token existe
  if (token == null) {
    throw Exception("Token no encontrado.");
  }

  // Construir la URL para la solicitud HTTP
  final url = Uri.parse(
    '$baseUrl/Neumaticos/GetNeumaticoByCodigo?codigo=$nfcData',
  );

  // Realizar la solicitud HTTP GET
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token', // Añadir el token en los headers
    },
  );

  // Verificar si la respuesta es exitosa
  if (response.statusCode == 200) {
    // Decodificar la respuesta JSON
    Map<String, dynamic> neumaticoData = json.decode(response.body);

    // Obtener el nombre de la bodega
    String? idBodega = neumaticoData['iD_BODEGA'].toString();
    if (idBodega.isNotEmpty) {
      // Llamar a la función para obtener el nombre de la bodega
      final bodegaName = await fetchBodegaName(idBodega);
      neumaticoData['nombre_bodega'] = bodegaName;  // Añadir el nombre de la bodega al mapa de datos
    }

    return neumaticoData; // Retornar los datos del neumático
  } else {
    // Lanzar una excepción si la respuesta no es exitosa
    throw Exception('Error al obtener los datos: ${response.statusCode}');
  }
}

// Función para obtener la patente de un móvil a partir de su ID
Future<String> fetchMovilPatente(String idMovil) async {
  final String baseUrl = '${Config.awsUrl}/api';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  // Construir la URL para la solicitud HTTP
  final url = Uri.parse('$baseUrl/Movil/$idMovil');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token', // Añadir el token en los headers
    },
  );

  // Verificar si la respuesta es exitosa
  if (response.statusCode == 200) {
    // Decodificar la respuesta JSON
    final data = json.decode(response.body);
    // Retornar la patente del móvil o un mensaje si no se encuentra
    return data['patente'] ?? 'Patente no encontrada';
  } else {
    // Lanzar una excepción si la respuesta no es exitosa
    throw Exception('Error al obtener la patente del móvil');
  }
}

// Función para obtener el nombre de una bodega a partir de su ID
Future<String> fetchBodegaName(String idBodega) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final String baseUrl = '${Config.awsUrl}/api';

  // Construir la URL para la solicitud HTTP
  final url = Uri.parse('$baseUrl/Bodega/$idBodega');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token', // Añadir el token en los headers
    },
  );

  // Verificar si la respuesta es exitosa
  if (response.statusCode == 200) {
    // Decodificar la respuesta JSON
    final data = json.decode(response.body);
    // Retornar el nombre de la bodega o un mensaje si no se encuentra
    return data['nombrE_BODEGA'] ?? 'Bodega no encontrada';
  } else {
    // Lanzar una excepción si la respuesta no es exitosa
    throw Exception('Error al obtener el nombre de la bodega');
  }
}
