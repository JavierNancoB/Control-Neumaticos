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
          return;
        }
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        Directory directory = Directory('/storage/emulated/0/Download'); // Carpeta Descargas

        if (!directory.existsSync()) {
          return;
        }

        String filePath = '${directory.path}/reporte.xlsx';

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
      }
    } catch (e) {
        await Future.delayed(Duration(seconds: 1));
    }
  }

  static Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    PermissionStatus status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> sendReportByEmail(String desde, String hasta) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('correo');

    if (email == null || email.isEmpty) {
      throw Exception("No hay un correo registrado.");
    }

    final url = Uri.parse("http://localhost:5062/api/reportes/enviar-correo?fromDate=$desde&toDate=$hasta");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception("Error al enviar el reporte");
    }
  }
}
