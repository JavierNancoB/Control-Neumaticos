import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/menu/admin/movil/modificar_movil.dart';
import '../screens/menu/admin/neumatico/anadir_neumatico_screen.dart';
import '../screens/menu/admin/neumatico/modifcar_neumatico_screen.dart';
import '../screens/menu/admin/movil/añadir_movil_screen.dart';
import '../screens/menu/bitacora/asignar_neumatico.dart';

class IngresarPatenteService {
  static Future<void> handlePatente({
    required BuildContext context,
    required String patente,
    required String tipo,
    required String codigo,
  }) async {
    // Obtener el token de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró el token de autenticación.')),
      );
      return;
    }

    // Verificar si la patente existe solo si es un móvil
    if (tipo == 'movil' && patente.isNotEmpty || tipo == 'Asignar') {
      bool patenteExiste = await _checkPatenteExistence(patente, token);
      if (patenteExiste) {
        // Verificar el estado del móvil
        bool estadoMovil = await _checkEstadoMovil(patente, token);
        if (estadoMovil) {
          // Si el estado es verdadero, navegar al móvil
          if (tipo == 'Asignar') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AsignarNeumaticoPage(patente: patente, nfcData: codigo),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModificarMovilPage(patente: patente, codigo: codigo),
              ),
            );
          }
        } else {
          // Si el estado es falso, mostrar mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('El móvil no está activo, no se puede modificar.')),
          );
        }
      } else {
        // Si no existe, mostrar el mensaje de error para añadir un móvil
        _showAddMovilDialog(context);
      }
    } else if (tipo == 'Añadir' || tipo == 'Modificar') {
      // Para neumáticos, si hay patente, comprobar si existe
      if (patente.isNotEmpty) {
        bool patenteExiste = await _checkPatenteExistence(patente, token);
        if (patenteExiste) {
          // Verificar el estado del móvil si estamos modificando o añadiendo
          bool estadoMovil = await _checkEstadoMovil(patente, token);
          if (estadoMovil) {
            // Si el estado es verdadero, continuar con la lógica de neumático
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => tipo == 'Añadir'
                    ? AnadirNeumaticoScreen(patente: patente, nfcData: codigo)
                    : ModificarNeumaticoPage(patente: patente, nfcData: codigo),
              ),
            );
          } else {
            // Si el estado es falso, mostrar mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El móvil o Neumatico no está activo, no se puede modificar.')),
            );
          }
        } else {
          // Si la patente no existe, mostrar mensaje de error
          _showAddMovilDialog(context);
        }
      } else {
        // Si no hay patente, continuar directamente con la pantalla de neumático
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => tipo == 'Añadir'
                  ? AnadirNeumaticoScreen(patente: patente, nfcData: codigo)
                  : ModificarNeumaticoPage(patente: patente, nfcData: codigo),
            ),
          );
        
      }
    }
  }
  
static Future<List<String>> fetchPatentesSugeridas(String query) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception("No se encontró el token de autenticación.");
  }

  final url = Uri.parse('http://localhost:5062/api/Movil/BuscarMovilesPorPatente?query=$query');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return List<String>.from(data);
  } else {
    throw Exception('Error al obtener las sugerencias de patentes.');
  }
}




  // Comprobar si la patente existe en la API
  static Future<bool> _checkPatenteExistence(String patente, String token) async {
    try {
      final url = Uri.parse('http://localhost:5062/api/Movil/GetMovilByPatente?patente=$patente');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Verifica si los datos están vacíos, lo que significa que no existe
        print('response: $data');
        return data != null && data.isNotEmpty;
      } else if (response.statusCode == 404) {
        // Si la respuesta es 404, significa que no se encontró el móvil
        print('Móvil no encontrado');
        return false;
      } else {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return false; // Si ocurre un error, devuelve false
    }
  }

  // Comprobar el estado del móvil en la API
  static Future<bool> _checkEstadoMovil(String patente, String token) async {
    try {
      final url = Uri.parse('http://localhost:5062/api/Movil/ComprobarEstadoMovil?patente=$patente');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Si el estado es 1 (activo), permite la navegación
        return data == true;
      } else if (response.statusCode == 404) {
        // Si la respuesta es 404, significa que no se encontró el estado del móvil
        print('Estado del móvil no encontrado');
        return false;
      } else {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return false; // Si ocurre un error, devuelve false
    }
  }

  static void _showAddMovilDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Patente no encontrada'),
          content: Text('¿Desea añadir un nuevo móvil?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnadirMovilPage()),
                );
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
