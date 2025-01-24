import 'package:flutter/material.dart';

class InformacionPage extends StatelessWidget {
  final String patente;
  const InformacionPage({super.key, required this.patente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información del Vehículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Información del Vehículo para la patente:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Patente: $patente',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Aquí podrías agregar más información sobre el vehículo relacionada con la patente
          ],
        ),
      ),
    );
  }
}
