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
  Future<bool> modificarDatosUsuario(Usuario usuario) async {
    try {
      final uri = Uri.parse('$baseUrl/ModificarDatosUsuario')
          .replace(queryParameters: {
        'mail': usuario.correo,
        'nombres': usuario.nombres,
        'apellidos': usuario.apellidos,
        'codigoPerfil': usuario.codigoPerfil.toString(),
      });

      final response = await http.put(uri);

      if (response.statusCode == 200) {
        return true;
      } else if(response.statusCode == 404) {
        print("Error: Usuario no encontrado");
        return false;
      }
      else if(response.statusCode == 204) {
        print("Usuario modificado con éxito");
        return true;
      }
      else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error al modificar los datos del usuario: $e');
    }
  }
}
