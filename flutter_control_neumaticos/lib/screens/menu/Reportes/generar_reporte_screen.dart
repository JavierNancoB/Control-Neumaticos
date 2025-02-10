import 'package:flutter/material.dart';
import '../../../widgets/button.dart';

class GenerarReporteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StandarButton(
                text: 'Descargar Reporte',
              onPressed: () {
                // Lógica para descargar el reporte
              },
            ),
            SizedBox(height: 20),
            StandarButton(
              text: 'Enviar al Correo',
              onPressed: () {
                // Lógica para enviar el reporte por correo
              },
            ),
          ],
        ),
      ),
    );
  }
}