import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/alertas.dart';
import '../../models/usuario_alertas.dart';
import '../../models/neumatico.dart';
import '../../models/movil.dart';
/*
class AlertaService {
  static const String baseUrl = "http://localhost:5062/api";

  // Obtener token almacenado en SharedPreferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // Obtener userId almacenado en SharedPreferences
  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  // Obtener una alerta específica por su ID
  Future<Alerta> getAlertaById(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/Alerta/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Alerta.fromJson(data);
    } else {
      throw Exception("Error al obtener la alerta con ID $id");
    }
  }

  // Obtener alertas pendientes (puede aceptar un endpoint adicional si es necesario)
  Future<List<Alerta>> getAlertasPendientes(String endpoint) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/Alerta/$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => Alerta.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar las alertas pendientes");
    }
  }

  // Obtener un usuario por su ID
  Future<Usuario> getUsuarioById(int usuarioId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/$usuarioId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Usuario.fromJson(data);
    } else {
      throw Exception("Error al obtener el usuario con ID $usuarioId");
    }
  }

  // Cambiar el estado de una alerta
  Future<void> cambiarEstadoAlerta(int alertaId, int estado) async {
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
    print("Estado de la alerta con ID $alertaId cambiado a $estado");
    // Manejo de error
    if (response.statusCode != 204) {
      print("Error response: ${response.body}");
      throw Exception("Error al cambiar el estado de la alerta con ID $alertaId");
    }
  }

}
*/
/*
class AlertaService {
  static const String baseUrl = "http://localhost:5062/api";

  // Obtener el Neumatico por su ID
  Future<Neumatico> getNeumaticoById(int idNeumatico) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/neumaticos/$idNeumatico'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Neumatico.fromJson(data);
    } else {
      throw Exception("Error al obtener el neumático con ID $idNeumatico");
    }
  }

  // Obtener el Movil por su ID
  Future<Movil> getMovilById(int idMovil) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/movil/$idMovil'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movil.fromJson(data);
    } else {
      throw Exception("Error al obtener el móvil con ID $idMovil");
    }
  }
}
*/
class AlertaService {
  static const String baseUrl = "http://localhost:5062/api";

  // Obtener token almacenado en SharedPreferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // Obtener userId almacenado en SharedPreferences
  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  // Obtener una alerta específica por su ID
  Future<Alerta> getAlertaById(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/Alerta/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Alerta.fromJson(data);
    } else {
      throw Exception("Error al obtener la alerta con ID $id");
    }
  }

  // Obtener alertas pendientes (puede aceptar un endpoint adicional si es necesario)
  Future<List<Alerta>> getAlertasPendientes(String endpoint) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/Alerta/$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => Alerta.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar las alertas pendientes");
    }
  }

  // Obtener un usuario por su ID
  Future<Usuario> getUsuarioById(int usuarioId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/$usuarioId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Usuario.fromJson(data);
    } else {
      throw Exception("Error al obtener el usuario con ID $usuarioId");
    }
  }

  Future<Neumatico> getNeumaticoById(int idNeumatico) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/neumaticos/$idNeumatico'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Neumatico.fromJson(data);
    } else {
      throw Exception("Error al obtener el neumático con ID $idNeumatico");
    }
  }

  // Obtener el Movil por su ID
  Future<Movil> getMovilById(int idMovil) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/movil/$idMovil'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movil.fromJson(data);
    } else {
      throw Exception("Error al obtener el móvil con ID $idMovil");
    }
  }

  // Cambiar el estado de una alerta
  Future<void> cambiarEstadoAlerta(int alertaId, int estado) async {
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
    print("Estado de la alerta con ID $alertaId cambiado a $estado");
    // Manejo de error
    if (response.statusCode != 204) {
      print("Error response: ${response.body}");
      throw Exception("Error al cambiar el estado de la alerta con ID $alertaId");
    }
  }

}