import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/usuario_alertas.dart';

class AlertaDetailsService {
  static const String baseUrl = "http://localhost:5062/api";

  Future<String> _getToken() async {
    print("Obteniendo token...");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print("Token obtenido: $token");
    return token;
  }

  Future<int> _getUserId() async {
    print("Obteniendo userId...");
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    print("UserId obtenido: $userId");
    return userId;
  }

  Future<Usuario> getUsuarioById(int usuarioId) async {
    print("Obteniendo usuario por ID: $usuarioId");
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/$usuarioId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Respuesta obtenida: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Datos del usuario: $data");
      return Usuario.fromJson(data);
    } else {
      print("Error al obtener el usuario con ID $usuarioId: ${response.body}");
      throw Exception("Error al obtener el usuario con ID $usuarioId");
    }
  }

  Future<Map<String, dynamic>> getAlertaById(int id) async {
    final token = await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/Alerta/$id'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al obtener la alerta con ID $id");
    }
  }
  

  Future<Map<String, dynamic>> getNeumaticoById(int idNeumatico) async {
    final token = await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/neumaticos/$idNeumatico'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al obtener el neumático con ID $idNeumatico");
    }
  }

  Future<void> cambiarEstadoAlerta(int alertaId, int estado) async {
    print("Cambiando estado de la alerta con ID: $alertaId a estado: $estado");
    final token = await _getToken();
    final userId = await _getUserId();

    // Construir la URL con los parámetros correspondientes
    final url = Uri.parse(
        'http://localhost:5062/api/Alerta/CambiarEstado?id=$alertaId&estado=$estado&idUsuario=$userId');

    // Enviar la solicitud PUT
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Imprimir los detalles de la respuesta
    print("Respuesta obtenida: ${response.statusCode}");
    if (response.statusCode == 204) {
      print("Estado de la alerta con ID $alertaId cambiado a $estado");
    } else {
      print("Error al cambiar el estado de la alerta con ID $alertaId: ${response.body}");
      throw Exception("Error al cambiar el estado de la alerta con ID $alertaId");
    }
  }
}
