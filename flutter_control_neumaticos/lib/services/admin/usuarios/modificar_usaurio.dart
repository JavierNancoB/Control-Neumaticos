import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/admin/usuario_modifcar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/config.dart';

class UsuarioService {
  final String baseUrl = '${Config.awsUrl}/api/Usuarios';

  // Obtener el usuario por correo
  Future<Usuario?> getUsuarioByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/GetUsuarioByMail?mail=$email'),
      );

      if (response.statusCode == 200) {
        return Usuario.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener los datos del usuario');
      }
    } catch (e) {
      throw Exception('Error al obtener los datos del usuario: $e');
    }
  }

  // Modificar los datos del usuario
  Future<bool> modificarDatosUsuario(Usuario usuario, String email) async {
    //Obtenemos la id y el token del usuario
    final token = await _getToken();
    final idUsuarioEnvio = await _getIdUsuario();

    try {
      // Construir la URL manualmente sin usar `replace(queryParameters:)`
      final url = Uri.parse('$baseUrl/ModificarDatosUsuario')
          .replace(queryParameters: {
        'mail': email, // El correo actual para buscar el usuario
        'nuevosMail': usuario.correo, // El nuevo correo si se modifica
        'nombres': usuario.nombres,
        'apellidos': usuario.apellidos,
        'codigoPerfil': usuario.codigoPerfil.toString(),
        'idUsuarioBitacora': idUsuarioEnvio.toString(),
      });

      // Imprimir la URL antes de hacer la solicitud

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error al modificar los datos del usuario: $e');
    }
  }

  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<int?> _getIdUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}
