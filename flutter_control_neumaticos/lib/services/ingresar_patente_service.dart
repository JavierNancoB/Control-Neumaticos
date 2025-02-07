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
    print('Iniciando handlePatente con patente: $patente, tipo: $tipo, codigo: $codigo');
    
    // Obtener el token de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Token obtenido: $token');

    if (token == null) {
      print('Token no encontrado');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró el token de autenticación.')),
      );
      return;
    }

    // Verificar si la patente existe solo si es un móvil
    if (tipo == 'movil' && patente.isNotEmpty) {
      print('Verificando si la patente existe...');
      bool patenteExiste = await _checkPatenteExistence(patente, token);
      print('¿Patente existe? $patenteExiste');

      if (patenteExiste) {
        // Verificar el estado del móvil
        print('Verificando el estado del móvil...');
        bool estadoMovil = await _checkEstadoMovil(patente, token);
        print('¿Estado del móvil activo? $estadoMovil');

        if (estadoMovil) {
          // Si el estado es verdadero, navegar al móvil
          print('Navegando a la pantalla de modificación del móvil...');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModificarMovilPage(patente: patente, codigo: codigo),
            ),
          );
        } else {
          // Si el estado es falso, mostrar mensaje de error
          print('El móvil no está activo');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('El móvil no está activo, no se puede modificar.')),
          );
        }
      } else {
        // Si no existe, mostrar el mensaje de error para añadir un móvil
        print('Patente no encontrada, mostrando diálogo para añadir móvil...');
        _showAddMovilDialog(context);
      }
    } else if (tipo != 'movil' && patente.isNotEmpty) {
      print('Verificando patente para tipo: $tipo');
      // Para neumáticos, si hay patente, comprobar si existe
      if (patente.isNotEmpty) {
        bool patenteExiste = await _checkPatenteExistence(patente, token);
        print('¿Patente existe? $patenteExiste');

        if (patenteExiste) {
          // Verificar el estado del móvil si estamos modificando o añadiendo
          print('Verificando estado del móvil...');
          bool estadoMovil = await _checkEstadoMovil(patente, token);
          print('¿Estado del móvil activo? $estadoMovil');

          if (estadoMovil && tipo == 'Añadir') {
            print('Navegando a añadir neumático...');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnadirNeumaticoScreen(patente: patente, nfcData: codigo),
              ),
            );
          } else if (estadoMovil && tipo == 'Modificar') {
            print('Navegando a modificar neumático...');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModificarNeumaticoPage(patente: patente, nfcData: codigo),
              ),
            );
          } else if (estadoMovil && tipo == 'Asignar') {
            print('Navegando a asignar neumático...');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AsignarNeumaticoPage(patente: patente, nfcData: codigo),
              ),
            );
          } else {
            // Si el estado es falso, mostrar mensaje de error
            print('El móvil o neumático no está activo, no se puede modificar');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El móvil o Neumatico no está activo, no se puede modificar.')),
            );
          }
        } else {
          // Si la patente no existe, mostrar mensaje de error
          print('Patente no encontrada, mostrando diálogo para añadir móvil...');
          _showAddMovilDialog(context);
        }
      }
    } else if (patente.isEmpty) {
      print('No hay patente, continuando con la lógica de neumático...');
      print('Navegando a la pantalla correspondiente... tipo: $tipo');
      if (tipo == 'Añadir') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnadirNeumaticoScreen(patente: patente, nfcData: codigo),
          ),
        );
      }
      if (tipo == 'Modificar') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModificarNeumaticoPage(patente: patente, nfcData: codigo),
          ),
        );
      }
      if (tipo == 'Asignar') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AsignarNeumaticoPage(patente: patente, nfcData: codigo),
          ),
        );
      }
    }
  }
  

  static Future<List<String>> fetchPatentesSugeridas(String query) async {
    print('Iniciando fetchPatentesSugeridas con query: $query');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Token obtenido: $token');

    if (token == null) {
      print('Token no encontrado');
      throw Exception("No se encontró el token de autenticación.");
    }

    final url = Uri.parse('http://localhost:5062/api/Movil/BuscarMovilesPorPatente?query=$query');
    print('URL de la API para obtener sugerencias: $url');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print('Respuesta exitosa, decodificando datos...');
      List<dynamic> data = jsonDecode(response.body);
      print('Datos obtenidos: $data');
      return List<String>.from(data);
    } else {
      print('Error al obtener las sugerencias de patentes');
      throw Exception('Error al obtener las sugerencias de patentes.');
    }
  }

  // Comprobar si la patente existe en la API
  static Future<bool> _checkPatenteExistence(String patente, String token) async {
    print('Comprobando existencia de la patente: $patente');
    try {
      final url = Uri.parse('http://localhost:5062/api/Movil/GetMovilByPatente?patente=$patente');
      print('URL de la API para comprobar existencia: $url');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Respuesta de existencia: $data');
        return data != null && data.isNotEmpty;
      } else if (response.statusCode == 404) {
        print('Móvil no encontrado');
        return false;
      } else {
        print('Error desconocido: ${response.statusCode}');
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al comprobar existencia: $e');
      return false; // Si ocurre un error, devuelve false
    }
  }

  // Comprobar el estado del móvil en la API
  static Future<bool> _checkEstadoMovil(String patente, String token) async {
    print('Comprobando estado del móvil: $patente');
    try {
      final url = Uri.parse('http://localhost:5062/api/Movil/ComprobarEstadoMovil?patente=$patente');
      print('URL de la API para comprobar estado: $url');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Estado del móvil: $data');
        return data == true;
      } else if (response.statusCode == 404) {
        print('Estado del móvil no encontrado');
        return false;
      } else {
        print('Error desconocido: ${response.statusCode}');
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al comprobar estado: $e');
      return false; // Si ocurre un error, devuelve false
    }
  }

  static void _showAddMovilDialog(BuildContext context) {
    print('Mostrando diálogo para añadir móvil...');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Patente no encontrada'),
          content: Text('¿Desea añadir un nuevo móvil?'),
          actions: [
            TextButton(
              onPressed: () {
                print('Cancelando...');
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                print('Aceptando y navegando a añadir móvil...');
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
