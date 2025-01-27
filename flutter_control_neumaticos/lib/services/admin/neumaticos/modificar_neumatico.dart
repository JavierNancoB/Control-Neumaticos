import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/neumatico_modifcar.dart';

class NeumaticoService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Neumatico?> fetchNeumatico(String codigo) async {
    final token = await _getToken();
    if (token == null) {
      print('Error: Token no encontrado');
      return null;
    }

    final url = Uri.parse('http://localhost:5062/api/Neumaticos/GetNeumaticoByCodigo?codigo=$codigo');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Respuesta de la API: $jsonResponse');
        final neumatico = Neumatico.fromJson(jsonResponse);

        if (neumatico.idMovil != null) {
          final movil = await fetchMovil(neumatico.idMovil!);
          return Neumatico(
            id: neumatico.id,
            codigo: neumatico.codigo,
            ubicacion: neumatico.ubicacion,
            idMovil: neumatico.idMovil,
            fechaIngreso: neumatico.fechaIngreso,
            fechaSalida: neumatico.fechaSalida,
            estado: neumatico.estado,
            kmTotal: neumatico.kmTotal,
            tipoNeumatico: neumatico.tipoNeumatico,
            patente: movil?.patente,
          );
        }
        return neumatico;
      } else {
        print('Error en la API: Código de estado ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      return null;
    }
  }

  Future<Movil?> fetchMovil(int idMovil) async {
    final token = await _getToken();
    if (token == null) {
      print('Error: Token no encontrado');
      return null;
    }

    final url = Uri.parse('http://localhost:5062/api/Movil/$idMovil');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Respuesta de la API Movil: $jsonResponse');
        return Movil.fromJson(jsonResponse);
      } else {
        print('Error en la API Movil: Código de estado ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al realizar la solicitud Movil: $e');
      return null;
    }
  }

  Future<bool> modificarNeumatico(Neumatico neumatico) async {
    final token = await _getToken();
    if (token == null) {
      print('Error: Token no encontrado');
      return false;
    }

    final url = Uri.parse(
      'http://localhost:5062/api/Neumaticos/ModificarNeumaticoPorCodigo?codigo=${neumatico.codigo}&ubicacion=${neumatico.ubicacion}&patente=${neumatico.patente ?? ''}&fechaIngreso=${neumatico.fechaIngreso}&fechaSalida=${neumatico.fechaSalida ?? ''}&estado=${neumatico.estado}&kmTotal=${neumatico.kmTotal}&tipoNeumatico=${neumatico.tipoNeumatico}',
    );

    try {
      final response = await http.put(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 204) {
        print('Neumático modificado correctamente');
        return true;
      } else {
        print('Error en la modificación: Código de estado ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      return false;
    }
  }
}