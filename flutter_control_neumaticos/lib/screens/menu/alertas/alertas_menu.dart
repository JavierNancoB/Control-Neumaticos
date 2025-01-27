import 'package:flutter/material.dart';
import 'alertas_listas.dart';

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
                  MaterialPageRoute(builder: (context) => AlertListPage(endpoint:  "GetAlertasByEstadoAlerta1&2")),
                );
              },
              child: Text('Alertas Pendientes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlertListPage(endpoint: "GetAlertasByEstadoAlerta3")),
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