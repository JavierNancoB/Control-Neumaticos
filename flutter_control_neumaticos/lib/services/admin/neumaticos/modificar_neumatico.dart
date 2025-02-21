import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/admin/neumatico_modifcar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';

// Excepción personalizada para cuando la posición ya está ocupada
class NeumaticoYaAsignadoException implements Exception {
  final String message;

  NeumaticoYaAsignadoException(this.message);

  @override
  String toString() => message;
}

class NeumaticoService {
  // Obtiene el token desde SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  static final String _baseUrl = '${Config.awsUrl}/api';

  // Busca el neumático por código y verifica si está habilitado
  static Future<Neumatico?> fetchNeumaticoByCodigo(String codigo) async {
    final token = await _getToken();

    // URL para obtener los datos del neumático
    final urlNeumatico = '$_baseUrl/Neumaticos/GetNeumaticoByCodigo?codigo=$codigo';

    final responseNeumatico = await http.get(
      Uri.parse(urlNeumatico),
      headers: {'Authorization': 'Bearer $token'},
    );


    if (responseNeumatico.statusCode == 200) {
      final data = json.decode(responseNeumatico.body);

      try {
        // Crear objeto Neumatico con los datos obtenidos
        final neumatico = Neumatico.fromJson(data);
        return neumatico;
      } catch (e) {
        throw Exception('Error al parsear los datos del neumático: $e');
      }
    } else {
      throw Exception('Error al obtener los datos del neumático');
    }
  }

  // Verifica si el neumático está habilitado usando la API
  static Future<bool> _verificarSiNeumaticoHabilitado(String codigo) async {
    final token = await _getToken();

    // URL para verificar si el neumático está habilitado
    final urlHabilitado = '$_baseUrl/Neumaticos/verificarSiNeumaticoHabilitado?codigo=$codigo';

    final response = await http.post(
      Uri.parse(urlHabilitado),
      headers: {'Authorization': 'Bearer $token'},
    );


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data == true; // Retorna true si está habilitado
    } else {
      throw Exception('Error al verificar si el neumático está habilitado');
    }
  }

  // Verifica si la posición del neumático es única para el vehículo
  static Future<bool> verificarPosicionUnica(String patente, int posicion) async {
    final token = await _getToken();

    final url =
        '$_baseUrl/Neumaticos/verificarSiPosicioneEsUnicaConPatente?idMovil=$patente&posicion=$posicion';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data == true;
      } else {
        throw Exception('Error al verificar si la posición es única');
      }
    } catch (e) {
      throw Exception('Error en la verificación de posición única');
    }
  }

  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    return userId;
  }

  // Método para modificar un neumático
  Future<void> modificarNeumatico(Neumatico neumatico, String patente) async {
    final token = await _getToken();
    final idUsuario = await _getUserId();
    
    // Asegúrate de eliminar espacios adicionales de la patente
    String patenteTrimmed = patente.trim();
    
    // Verificar si la posición es única antes de continuar
    bool isPosicionUnica = await verificarPosicionUnica(patenteTrimmed, neumatico.ubicacion);

    if (!isPosicionUnica) {
      // Aquí lanzamos la excepción personalizada en lugar de la genérica
      throw NeumaticoYaAsignadoException('La posición ${neumatico.ubicacion} ya está ocupada por otro neumático. Por favor, elija otra posición.');
    }

    // Si la patente está vacía, la ubicación se ajusta a 'BODEGA' (ubicacion = 1)
    int ubicacionFinal = patenteTrimmed.isEmpty ? 1 : neumatico.ubicacion;

    // Construir la URL de la API con los parámetros
    final url =
        '$_baseUrl/Neumaticos/ModificarNeumaticoPorCodigo?codigo=${neumatico.codigo}&ubicacion=$ubicacionFinal&patente=${Uri.encodeComponent(patenteTrimmed.isEmpty ? '' : patenteTrimmed)}&fechaIngreso=${neumatico.fechaIngreso.toIso8601String()}&kmTotal=${neumatico.kmTotal}&tipoNeumatico=${neumatico.tipoNeumatico}&idUsuario=$idUsuario';

    // Realizar la solicitud PUT a la API
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );


    // Verificar si el neumático está habilitado
    final estaHabilitado = await _verificarSiNeumaticoHabilitado(neumatico.codigo);

    // Si no está habilitado, se lanza una excepción
    if (!estaHabilitado) {
      throw Exception('El neumático no está habilitado');
    }

    // Manejar la respuesta del servidor
    if (response.statusCode != 204) {
      if (response.statusCode == 409) {
        throw NeumaticoYaAsignadoException('La posición ya está ocupada por otro neumático.');
      }
      throw Exception('Error al modificar el neumático. Código: ${response.statusCode}');
    }
  }
}
