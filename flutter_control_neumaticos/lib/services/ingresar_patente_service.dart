import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/menu/admin/movil/modificar_movil.dart';
import '../screens/menu/admin/neumatico/anadir_neumatico_screen.dart';
import '../screens/menu/admin/neumatico/modifcar_neumatico_screen.dart';
import '../screens/menu/admin/movil/añadir_movil_screen.dart';

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
    if (tipo == 'movil' && patente.isNotEmpty) {
      bool patenteExiste = await _checkPatenteExistence(patente, token);
      if (patenteExiste) {
        // Si la patente existe, navegar al móvil
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModificarMovilPage(patente: patente, codigo: codigo),
          ),
        );
      } else {
        // Si no existe, mostrar el mensaje de error para añadir un móvil
        _showAddMovilDialog(context);
      }
    } else if (tipo == 'Añadir' || tipo == 'Modificar') {
  // Para neumáticos, si hay patente, comprobar si existe
      if (patente.isNotEmpty) {
        bool patenteExiste = await _checkPatenteExistence(patente, token);
        if (patenteExiste) {
          // Si la patente existe, continuar con la lógica de neumático
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => tipo == 'Añadir'
                  ? AnadirNeumaticoScreen(patente: patente, nfcData: codigo)
                  : ModificarNeumaticoPage(patente: patente, nfcData: codigo),
            ),
          );
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
