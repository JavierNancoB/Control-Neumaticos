import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/alertas.dart';
import '../../models/usuario_alertas.dart';
import '../../models/neumatico.dart';
import '../../models/movil.dart';

class AlertaService {
  static const String baseUrl = "http://localhost:5062/api";

  // Obtener token almacenado en SharedPreferences
  Future<String> _getToken() async {
    print("Obteniendo token...");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print("Token obtenido: $token");
    return token;
  }

  // Obtener userId almacenado en SharedPreferences
  Future<int> _getUserId() async {
    print("Obteniendo userId...");
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    print("UserId obtenido: $userId");
    return userId;
  }

  // Obtener una alerta específica por su ID
  Future<Alerta> getAlertaById(int id) async {
    print("Obteniendo alerta por ID: $id");
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/Alerta/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Respuesta obtenida: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Datos de la alerta: $data");
      return Alerta.fromJson(data);
    } else {
      print("Error al obtener la alerta con ID $id: ${response.body}");
      throw Exception("Error al obtener la alerta con ID $id");
    }
  }

  // Obtener alertas pendientes (puede aceptar un endpoint adicional si es necesario)
  Future<List<Alerta>> getAlertasPendientes(String endpoint) async {
    print("Obteniendo alertas pendientes desde el endpoint: $endpoint");
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/Alerta/$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Respuesta obtenida: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      print("Datos de alertas pendientes: $data");
      return data.map((json) => Alerta.fromJson(json)).toList();
    } else {
      print("Error al cargar las alertas pendientes: ${response.body}");
      throw Exception("Error al cargar las alertas pendientes");
    }
  }

  // Obtener un usuario por su ID
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

  Future<Neumatico> getNeumaticoById(int idNeumatico) async {
    print("Obteniendo neumatico por ID: $idNeumatico");
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/neumaticos/$idNeumatico'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Respuesta obtenida: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Datos del neumatico: $data");
      return Neumatico.fromJson(data);
    } else {
      print("Error al obtener el neumatico con ID $idNeumatico: ${response.body}");
      throw Exception("Error al obtener el neumático con ID $idNeumatico");
    }
  }

  // Obtener el Movil por su ID
  Future<Movil> getMovilById(int idMovil) async {
    print("Obteniendo movil por ID: $idMovil");
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/movil/$idMovil'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Respuesta obtenida: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Datos del movil: $data");
      return Movil.fromJson(data);
    } else {
      print("Error al obtener el movil con ID $idMovil: ${response.body}");
      throw Exception("Error al obtener el móvil con ID $idMovil");
    }
  }

  // Cambiar el estado de una alerta
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