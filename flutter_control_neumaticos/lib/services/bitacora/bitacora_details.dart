import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/bitacora_models.dart';
import '../../models/usuario_alertas.dart';
class BitacoraServices {
  // Función para obtener la bitácora por ID
  static Future<Bitacora> fetchBitacoraData(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final url = Uri.parse('http://localhost:5062/api/BitacoraNeumatico/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Agregar token al encabezado
      },
    );

    if (response.statusCode == 200) {
      return Bitacora.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener la bitácora');
    }
  }

  // Función para obtener el usuario por ID
  static Future<Usuario> fetchUsuarioData(int usuarioId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final url = Uri.parse('http://localhost:5062/api/usuarios/$usuarioId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Agregar token al encabezado
      },
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el usuario');
    }
  }

  // Función para actualizar el estado de la bitácora
  static Future<void> updateBitacoraState(int id, int estado) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final url = Uri.parse('http://localhost:5062/api/BitacoraNeumatico/UpdateEstadoBitacora/$id?estado=$estado');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Agregar token al encabezado
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el estado de la bitácora');
    }
  }
}