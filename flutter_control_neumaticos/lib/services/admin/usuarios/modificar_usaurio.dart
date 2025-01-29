import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/usuario_modifcar.dart';

class UsuarioService {
  final String baseUrl = 'http://localhost:5062/api/Usuarios';

  // Obtener el usuario por correo
  Future<Usuario?> getUsuarioByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/GetUsuarioByMail?mail=$email'),
      );

      if (response.statusCode == 200) {
        return Usuario.fromJson(json.decode(response.body));
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        throw Exception('Error al obtener los datos del usuario');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error al obtener los datos del usuario: $e');
    }
  }

  // Modificar los datos del usuario
  // Modificar los datos del usuario
  // Modificar los datos del usuario
 // Modificar los datos del usuario
  Future<bool> modificarDatosUsuario(Usuario usuario, String email) async {
    try {
      // Construir la URL manualmente sin usar `replace(queryParameters:)`
      final url = Uri.parse('$baseUrl/ModificarDatosUsuario') 
          .replace(queryParameters: {
        'mail': email, // El correo actual para buscar el usuario
        'nuevosMail': usuario.correo, // El nuevo correo si se modifica
        'nombres': usuario.nombres,
        'apellidos': usuario.apellidos,
        'codigoPerfil': usuario.codigoPerfil.toString(),
      });

      // Imprimir la URL antes de hacer la solicitud
      print("Endpoint: ${url.toString()}");

      final response = await http.put(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error al modificar los datos del usuario: $e');
    }
  }

}
