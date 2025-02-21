import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart'; // Para abrir archivos
import '../../../widgets/button.dart';
import '../../../services/reporte/generar_reporte_services.dart';

class GenerarReporteScreen extends StatefulWidget {
  const GenerarReporteScreen({super.key});

  @override
  _GenerarReporteScreenState createState() => _GenerarReporteScreenState();
}

class _GenerarReporteScreenState extends State<GenerarReporteScreen> {
  // Controladores para los campos de texto de las fechas
  final TextEditingController _desdeController = TextEditingController();
  final TextEditingController _hastaController = TextEditingController();
  // Clave global para el formulario
  final _formKey = GlobalKey<FormState>();

  // Función para seleccionar una fecha
  Future<void> _selectDate(BuildContext context, TextEditingController controller, {bool isDesde = true}) async {
    // Mostrar el selector de fecha
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // Si se selecciona una fecha
    if (selectedDate != null) {
      // Formatear la fecha seleccionada
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      // Validar y asignar la fecha seleccionada al controlador correspondiente
      if (isDesde) {
        if (_hastaController.text.isNotEmpty &&
            selectedDate.isAfter(DateTime.parse(_hastaController.text))) {
          _showErrorDialog("La fecha 'Desde' no puede ser mayor que 'Hasta'");
          return;
        }
        _desdeController.text = formattedDate;
      } else {
        if (_desdeController.text.isNotEmpty &&
            selectedDate.isBefore(DateTime.parse(_desdeController.text))) {
          _showErrorDialog("La fecha 'Hasta' no puede ser menor que 'Desde'");
          return;
        }
        _hastaController.text = formattedDate;
      }
    }
  }

  // Función para mostrar un cuadro de diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  // Función para descargar el reporte
  Future<void> _downloadReport() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ReportService.downloadReport(_desdeController.text, _hastaController.text);
      _showOpenFileDialog(); // Llamar la alerta sin necesidad de la ruta
    }
  }

  // Función para mostrar un cuadro de diálogo para abrir el archivo descargado
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

  // Función para enviar el reporte por correo electrónico
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
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Ha ocurrido un error al intentar enviar el reporte."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Aceptar"),
                ),
              ],
            );
          },
        );
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
              // Campo de texto para la fecha "Desde"
              TextFormField(
                controller: _desdeController,
                decoration: InputDecoration(
                  labelText: 'Desde',
                  hintText: 'Seleccionar fecha',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _desdeController, isDesde: true),
                  ),
                ),
                readOnly: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, selecciona una fecha desde'
                    : null,
              ),
              SizedBox(height: 10),
              // Campo de texto para la fecha "Hasta"
              TextFormField(
                controller: _hastaController,
                decoration: InputDecoration(
                  labelText: 'Hasta',
                  hintText: 'Seleccionar fecha',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _hastaController, isDesde: false),
                  ),
                ),
                readOnly: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, selecciona una fecha hasta'
                    : null,
              ),
              SizedBox(height: 20),
              // Botón para descargar el reporte
              StandarButton(
                text: 'Descargar Reporte',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (DateTime.parse(_desdeController.text)
                        .isAfter(DateTime.parse(_hastaController.text))) {
                      _showErrorDialog("La fecha 'Desde' no puede ser mayor que 'Hasta'");
                      return;
                    }
                    _downloadReport();
                  }
                },
              ),
              SizedBox(height: 20),
              // Botón para enviar el reporte por correo
              StandarButton(
                text: 'Enviar al Correo',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (DateTime.parse(_desdeController.text)
                        .isAfter(DateTime.parse(_hastaController.text))) {
                      _showErrorDialog("La fecha 'Desde' no puede ser mayor que 'Hasta'");
                      return;
                    }
                    _sendReportByEmail();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
