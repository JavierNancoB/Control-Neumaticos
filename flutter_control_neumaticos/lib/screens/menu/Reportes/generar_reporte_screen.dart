import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart'; // Para abrir archivos
import '../../../widgets/button.dart';
import '../../../services/reporte/generar_reporte_services.dart';

class GenerarReporteScreen extends StatefulWidget {
  @override
  _GenerarReporteScreenState createState() => _GenerarReporteScreenState();
}

class _GenerarReporteScreenState extends State<GenerarReporteScreen> {
  TextEditingController _desdeController = TextEditingController();
  TextEditingController _hastaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  Future<void> _downloadReport() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ReportService.downloadReport(_desdeController.text, _hastaController.text);
      _showOpenFileDialog(); // Llamar la alerta sin necesidad de la ruta
    }
  }

  void _showOpenFileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reporte descargado"),
          content: Text("Reporte guardado correctamente. ¿Desea abrirlo?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                OpenFile.open("/storage/emulated/0/Download/reporte.xlsx"); // Ruta fija
              },
              child: Text("Sí"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendReportByEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ReportService.sendReportByEmail(_desdeController.text, _hastaController.text);

        // Mostrar alerta de confirmación
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Reporte enviado"),
              content: Text("El reporte ha sido enviado correctamente."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Aceptar"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Error: $e");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generar Reporte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _desdeController,
                decoration: InputDecoration(
                  labelText: 'Desde',
                  hintText: 'Seleccionar fecha',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _desdeController),
                  ),
                ),
                readOnly: true,
                validator: (value) => value == null || value.isEmpty ? 'Por favor, selecciona una fecha desde' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _hastaController,
                decoration: InputDecoration(
                  labelText: 'Hasta',
                  hintText: 'Seleccionar fecha',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _hastaController),
                  ),
                ),
                readOnly: true,
                validator: (value) => value == null || value.isEmpty ? 'Por favor, selecciona una fecha hasta' : null,
              ),
              SizedBox(height: 20),
              StandarButton(
                text: 'Descargar Reporte',
                onPressed: _downloadReport,
              ),
              SizedBox(height: 20),
              // Botón Enviar al Correo (sin funcionalidad por ahora)
              StandarButton(
                text: 'Enviar al Correo',
                onPressed: _sendReportByEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
