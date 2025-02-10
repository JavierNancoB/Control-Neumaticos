import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> fetchNeumaticoData(String nfcData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception("Token no encontrado.");
  }

  final url = Uri.parse(
    'http://localhost:5062/api/Neumaticos/GetNeumaticoByCodigo?codigo=$nfcData',
  );
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> neumaticoData = json.decode(response.body);

    // Obtener el nombre de la bodega
    String? idBodega = neumaticoData['iD_BODEGA'].toString();
    if (idBodega.isNotEmpty) {
      final bodegaName = await fetchBodegaName(idBodega);
      neumaticoData['nombre_bodega'] = bodegaName;  // Añadir el nombre de la bodega al mapa de datos
    }

    return neumaticoData;
  } else {
    throw Exception('Error al obtener los datos: ${response.statusCode}');
  }
}

  Future<String> fetchMovilPatente(String idMovil) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // Verifica si es el token correcto
    
    final url = Uri.parse('http://localhost:5062/api/Movil/$idMovil');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Asegúrate de que la clave sea correcta, puedes hacer un print para revisar la respuesta
      return data['patente'] ?? 'Patente no encontrada'; // Cambié la clave a 'patente'
    } else {
      throw Exception('Error al obtener la patente del móvil');
    }
  }


  Future<String> fetchBodegaName(String idBodega) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  // Verifica si es el token correcto
  
  final url = Uri.parse('http://localhost:5062/api/Bodega/$idBodega');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Asegúrate de que la clave sea correcta, puedes hacer un print para revisar la respuesta
    return data['nombrE_BODEGA'] ?? 'Bodega no encontrada'; // Cambié la clave a 'nombrE_BODEGA'
  } else {
    throw Exception('Error al obtener el nombre de la bodega');
  }
}



