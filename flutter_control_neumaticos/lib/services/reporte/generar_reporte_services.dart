import 'dart:convert'; // Importa la librería para convertir objetos en formato JSON.
import 'dart:io'; // Importa la librería de manejo de archivos y directorios.
import 'package:http/http.dart' as http; // Importa la librería para realizar solicitudes HTTP.
import 'package:permission_handler/permission_handler.dart'; // Importa la librería para gestionar permisos.
import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería para almacenar datos locales.
import '../../../models/config.dart';

class ReportService {
  static const String baseUrl = '${Config.awsUrl}/api';
  // Método estático para descargar un reporte entre dos fechas.
  static Future<void> downloadReport(String fromDate, String toDate) async {
    // Crea la URL con los parámetros fromDate y toDate.
    final url = Uri.parse('$baseUrl/reportes/descargar/?fromDate=$fromDate&toDate=$toDate');

    try {
      // Si la plataforma es Android, solicita el permiso de almacenamiento.
      if (Platform.isAndroid) {
        bool hasPermission = await requestStoragePermission();
        if (!hasPermission) {
          return; // Si no tiene permiso, sale del método.
        }
      }

      // Realiza la solicitud HTTP para obtener el reporte.
      final response = await http.get(url);

      // Si la respuesta es exitosa (código 200), procesa el archivo.
      if (response.statusCode == 200) {
        // Define la carpeta de Descargas en el dispositivo Android.
        Directory directory = Directory('/storage/emulated/0/Download'); // Carpeta Descargas

        if (!directory.existsSync()) {
          return; // Si la carpeta no existe, sale del método.
        }

        // Define la ruta y nombre del archivo donde se guardará el reporte.
        String filePath = '${directory.path}/reporte.xlsx';

        // Crea un archivo en esa ubicación y guarda los datos del reporte.
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        // Si el código de estado no es 200, no hace nada (aquí podrías agregar lógica para manejar el error).
      }
    } catch (e) {
        // Si ocurre algún error, espera un segundo antes de continuar.
        await Future.delayed(Duration(seconds: 1));
    }
  }

  // Método para solicitar permiso de almacenamiento en Android.
  static Future<bool> requestStoragePermission() async {
    // Verifica si el permiso ya está concedido.
    if (await Permission.manageExternalStorage.isGranted) {
      return true; // Si ya tiene permiso, retorna true.
    }

    // Si no tiene permiso, solicita el permiso al usuario.
    PermissionStatus status = await Permission.manageExternalStorage.request();

    // Si el permiso es concedido, retorna true.
    if (status.isGranted) {
      return true;
    } else {
      return false; // Si no se concede el permiso, retorna false.
    }
  }

  // Método para enviar un reporte por correo.
  static Future<void> sendReportByEmail(String desde, String hasta) async {
    // Obtiene las preferencias compartidas (SharedPreferences) para acceder al correo almacenado.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('correo');

    // Si no hay correo registrado, lanza una excepción.
    if (email == null || email.isEmpty) {
      throw Exception("No hay un correo registrado.");
    }

    // Crea la URL para la solicitud POST con las fechas proporcionadas.
    final url = Uri.parse("$baseUrl/reportes/enviar-correo?fromDate=$desde&toDate=$hasta");

    // Realiza una solicitud POST con el correo del usuario.
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"}, // Define el tipo de contenido como JSON.
      body: jsonEncode({"email": email}), // Envía el correo como parte del cuerpo de la solicitud.
    );

    // Si la respuesta es exitosa (código 200), no hace nada (puedes agregar lógica aquí si es necesario).
    if (response.statusCode == 200) {
    } else {
      // Si la solicitud no es exitosa, lanza una excepción.
      throw Exception("Error al enviar el reporte");
    }
  }
}
