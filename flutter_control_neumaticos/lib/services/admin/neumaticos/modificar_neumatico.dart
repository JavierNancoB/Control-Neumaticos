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

      // Imprimir el JSON recibido para revisar la respuesta
      print("JSON recibido: $data");

      try {
        // Crear objeto Neumatico con los datos obtenidos
        final neumatico = Neumatico.fromJson(data);

        // Verificar si el neumático está habilitado
        print("ubicacion original: ${neumatico.ubicacion}");
        print("patente original: ${neumatico.idMovil}");
        print("kilometraje original: ${neumatico.kmTotal}");

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
    static Future<bool> verificarPosicionUnica(String patente, int posicion) async {
      
      final token = await _getToken();

      final url =
          'http://localhost:5062/api/Neumaticos/verificarSiPosicioneEsUnicaConPatente?idMovil=$patente&posicion=$posicion';


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
  print("Obteniendo userId...");
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId') ?? 0;
  print("UserId obtenido: $userId");
  return userId;
  }
  // Método para modificar un neumático
  // Método para modificar un neumático
 // Método para modificar un neumático
Future<void> modificarNeumatico(Neumatico neumatico, String patente) async {
  final token = await _getToken();
  final idUsuario = await _getUserId();
  // Imprimir el token obtenido
  print("Token obtenido: $token");
  print("ID de usuario: $idUsuario");

  // Asegúrate de eliminar espacios adicionales de la patente
  String patenteTrimmed = patente.trim();
  print("ubicacion original: ${neumatico.ubicacion}");
  print("patente original: $patente");

  // Si la patente está vacía, la ubicación se ajusta a 'BODEGA' (ubicacion = 1)
  int ubicacionFinal = patenteTrimmed.isEmpty ? 1 : neumatico.ubicacion;

  // Imprimir la patente recortada y la ubicación final
  print("Patente recortada: '$patenteTrimmed'");
  print("Ubicación final: $ubicacionFinal");
  print("Fecha de ingreso: ${neumatico.fechaIngreso.toIso8601String()}");
  print("Kilometraje total: ${neumatico.kmTotal}");
  print("Tipo de neumático: ${neumatico.tipoNeumatico}");
  

  // Construir la URL de la API con los parámetros
  final url =
      'http://localhost:5062/api/Neumaticos/ModificarNeumaticoPorCodigo?codigo=${neumatico.codigo}&ubicacion=$ubicacionFinal&patente=${Uri.encodeComponent(patenteTrimmed.isEmpty ? '' : patenteTrimmed)}&fechaIngreso=${neumatico.fechaIngreso.toIso8601String()}&kmTotal=${neumatico.kmTotal}&tipoNeumatico=${neumatico.tipoNeumatico}&idUsuario=$idUsuario';

  // Imprimir la URL generada
  print("URL de la API: $url");

  // Realizar la solicitud PUT a la API
  final response = await http.put(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );

  // Imprimir el código de respuesta HTTP
  print("Código de respuesta HTTP: ${response.statusCode}");
  print("Cuerpo de la respuesta: ${response.body}");

  final estaHabilitado = await _verificarSiNeumaticoHabilitado(neumatico.codigo);

  // Si no está habilitado, se lanza una excepción
  if (!estaHabilitado) {
    throw Exception('El neumático no está habilitado');
  }

  if (response.statusCode != 204) {
    throw Exception('Error al modificar el neumático. Código: ${response.statusCode}');
  }
}



}
