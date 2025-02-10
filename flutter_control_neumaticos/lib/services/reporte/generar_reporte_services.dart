import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportService {
  static Future<void> downloadReport(String fromDate, String toDate) async {
    final url = Uri.parse('http://localhost:5062/api/reportes/descargar/?fromDate=$fromDate&toDate=$toDate');

    try {
      if (Platform.isAndroid) {
        bool hasPermission = await requestStoragePermission();
        if (!hasPermission) {
          print('🚨 No se puede guardar sin permiso');
          return;
        }
      }

      final response = await http.get(url);
      print('Realizando solicitud GET a la API, Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        Directory directory = Directory('/storage/emulated/0/Download'); // Carpeta Descargas

        if (!directory.existsSync()) {
          print('🚨 La carpeta de descargas no existe');
          return;
        }

        String filePath = '${directory.path}/reporte.xlsx';
        print('Guardando archivo en: $filePath');

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('✅ Reporte guardado correctamente en: $filePath');
      } else {
        print('❌ Error al descargar el reporte: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error al descargar el archivo: $e');
    }
  }

  static Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    PermissionStatus status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      print('✅ Permiso de almacenamiento concedido');
      return true;
    } else {
      print('❌ Permiso de almacenamiento denegado');
      return false;
    }
  }

  static Future<void> sendReportByEmail(String desde, String hasta) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('correo');

    if (email == null || email.isEmpty) {
      print("❌ No se encontró un correo guardado.");
      throw Exception("No hay un correo registrado.");
    }

    final url = Uri.parse("http://localhost:5062/api/reportes/enviar-correo?fromDate=$desde&toDate=$hasta");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      print("✅ Reporte enviado correctamente a $email");
    } else {
      print("❌ Error al enviar el reporte: ${response.body}");
      throw Exception("Error al enviar el reporte");
    }
  }
}
