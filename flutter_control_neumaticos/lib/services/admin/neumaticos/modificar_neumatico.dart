import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/neumatico_modifcar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NeumaticoService {
  // Obtiene el token desde SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  // Busca el neumático por código y verifica si está habilitado
  static Future<Neumatico?> fetchNeumaticoByCodigo(String codigo) async {
    final token = await _getToken();

    // URL para obtener los datos del neumático
    final urlNeumatico = 'http://localhost:5062/api/Neumaticos/GetNeumaticoByCodigo?codigo=$codigo';

    final responseNeumatico = await http.get(
      Uri.parse(urlNeumatico),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (responseNeumatico.statusCode == 200) {
      final data = json.decode(responseNeumatico.body);

      try {
        // Crear objeto Neumatico con los datos obtenidos
        final neumatico = Neumatico.fromJson(data);

        // Verificar si el neumático está habilitado
        final estaHabilitado = await _verificarSiNeumaticoHabilitado(neumatico.codigo);

        // Mostrar que el neumático está deshabilitado en caso necesario
        if (!estaHabilitado) {
          print('El neumático con código ${neumatico.codigo} está deshabilitado.');
          neumatico.estado = 0; // Actualizar estado en el objeto Neumatico
        }

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
    final urlHabilitado = 'http://localhost:5062/api/Neumaticos/verificarSiNeumaticoHabilitado?codigo=$codigo';

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
  static Future<bool> verificarPosicionUnica(int idMovil, int posicion) async {
    final token = await _getToken();

    final url =
        'http://localhost:5062/api/Neumaticos/verificarSiPosicioneEsUnicaEnEseVehiculo?idMovil=$idMovil&posicion=$posicion';

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
  }

  // Método para modificar un neumático
  static Future<void> modificarNeumatico(Neumatico neumatico, String patente) async {
    final token = await _getToken();

    // Verificar si la posición es única antes de proceder
    final isPosicionUnica = await verificarPosicionUnica(neumatico.idMovil!, neumatico.ubicacion);
    if (!isPosicionUnica) {
      throw Exception('La posición del neumático ya está ocupada por otro neumático en este vehículo');
    }

    final url =
        'http://localhost:5062/api/Neumaticos/ModificarNeumaticoPorCodigo?codigo=${neumatico.codigo}&ubicacion=${neumatico.ubicacion}&patente=${Uri.encodeComponent(patente)}&fechaIngreso=${neumatico.fechaIngreso.toIso8601String()}&fechaSalida=${neumatico.fechaSalida?.toIso8601String() ?? ''}&estado=${neumatico.estado}&kmTotal=${neumatico.kmTotal}&tipoNeumatico=${neumatico.tipoNeumatico}';

    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Error al modificar el neumático. Código: ${response.statusCode}');
    }
  }
}
