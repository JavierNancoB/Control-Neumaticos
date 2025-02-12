import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/menu/admin/movil/modificar_movil.dart';
import '../screens/menu/admin/neumatico/anadir_neumatico_screen.dart';
import '../screens/menu/admin/neumatico/modifcar_neumatico_screen.dart';
import '../screens/menu/admin/movil/anadir_movil_screen.dart';
import '../screens/menu/bitacora/asignar_neumatico.dart';
import '../../../models/config.dart';

class IngresarPatenteService {
  static const String _baseUrl = '${Config.awsUrl}/api';
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
    if (tipo == 'movil' && patente.isNotEmpty) {
      print('Verificando existencia de patente para móvil...');
      bool patenteExiste = await checkPatenteExistence(patente, token);

      if (patenteExiste) {
        print('La patente existe.');
        // Verificar el estado del móvil
        bool estadoMovil = await _checkEstadoMovil(patente, token);

        if (estadoMovil) {
          print('El móvil está activo.');
          // Si el estado es verdadero, navegar al móvil
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModificarMovilPage(patente: patente, codigo: codigo),
            ),
          );
        } else {
          print('El móvil no está activo.');
          // Si el estado es falso, mostrar mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('El móvil no está activo, no se puede modificar.')),
          );
        }
      } else {
        print('La patente no existe.');
        // Si no existe, mostrar el mensaje de error para añadir un móvil
        _showAddMovilDialog(context);
      }
    } else if (tipo != 'movil' && patente.isNotEmpty) {
      print('Verificando existencia de patente para neumático...');
      // Para neumáticos, si hay patente, comprobar si existe
      bool patenteExiste = await checkPatenteExistence(patente, token);

      if (patenteExiste) {
        print('La patente existe.');
        // Verificar el estado del móvil si estamos modificando o añadiendo
        bool estadoMovil = await _checkEstadoMovil(patente, token);

        if (estadoMovil && tipo == 'Añadir') {
          print('Añadiendo neumático...');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnadirNeumaticoScreen(patente: patente, nfcData: codigo),
            ),
          );
        } else if (estadoMovil && tipo == 'Modificar') {
          print('Modificando neumático...');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModificarNeumaticoPage(patente: patente, nfcData: codigo),
            ),
          );
        } else if (estadoMovil && tipo == 'Asignar') {
          print('Asignando neumático...');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AsignarNeumaticoPage(patente: patente, nfcData: codigo),
            ),
          );
        } else {
          print('El móvil o neumático no está activo.');
          // Si el estado es falso, mostrar mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('El móvil o Neumatico no está activo, no se puede modificar.')),
          );
        }
      } else {
        print('La patente no existe.');
        // Si la patente no existe, mostrar ventana que diga no existe desea añadir
        _showAddMovilDialog(context);
      }
    } else if (patente.isEmpty) {
      print('La patente está vacía.');
      if (tipo == 'Añadir') {
        print('Añadiendo neumático...');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnadirNeumaticoScreen(patente: patente, nfcData: codigo),
          ),
        );
      }
      if (tipo == 'Modificar') {
        print('Modificando neumático...');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModificarNeumaticoPage(patente: patente, nfcData: codigo),
          ),
        );
      }
      if (tipo == 'Asignar') {
        print('Asignando neumático...');
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("No se encontró el token de autenticación.");
    }

    final url = Uri.parse('$_baseUrl/Movil/BuscarMovilesPorPatente?query=$query');
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
  // Cambiar _checkPatenteExistence a checkPatenteExistence
    static Future<bool> checkPatenteExistence(String patente, String token) async {
      try {
        final url = Uri.parse('$_baseUrl/Movil/GetMovilByPatente?patente=$patente');
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data != null && data.isNotEmpty;
        } else if (response.statusCode == 404) {
          return false;
        } else {
          throw Exception('Error desconocido: ${response.statusCode}');
        }
      } catch (e) {
        return false; // Si ocurre un error, devuelve false
      }
    }


  // Comprobar el estado del móvil en la API
  static Future<bool> _checkEstadoMovil(String patente, String token) async {
    try {
      final url = Uri.parse('$_baseUrl/Movil/ComprobarEstadoMovil?patente=$patente');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data == true;
      } else if (response.statusCode == 404) {
        return false;
      } else {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
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
              onPressed: () {
                Navigator.pop(context);
              },
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
