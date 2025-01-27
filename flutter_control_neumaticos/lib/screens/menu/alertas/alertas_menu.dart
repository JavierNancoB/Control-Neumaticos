import 'package:flutter/material.dart';
import 'alertas_pendientes.dart';
import 'alertas_atendidas.dart';

class AlertasMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertas Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlertasPendientesScreen()),
                );
              },
              child: Text('Alertas Pendientes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlertasAtendidasScreen()),
                );
              },
              child: Text('Alertas Atendidas'),
            ),
          ],
        ),
      ),
    );
  }
}