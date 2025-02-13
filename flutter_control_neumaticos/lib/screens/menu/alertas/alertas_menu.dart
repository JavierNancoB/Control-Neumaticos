import 'package:flutter/material.dart'; // Importa el paquete de Flutter para usar widgets de Material Design
import 'alertas_listas.dart'; // Importa el archivo alertas_listas.dart
import '../../../widgets/button.dart'; // Importa el archivo button.dart desde la carpeta widgets

// Define una clase StatelessWidget llamada AlertasMenu
class AlertasMenu extends StatelessWidget {
  const AlertasMenu({super.key}); // Constructor de la clase

  @override
  Widget build(BuildContext context) {
    // Método build que describe cómo se debe construir la interfaz de usuario
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertas Menu'), // Título de la AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra los hijos en el eje principal
          children: <Widget>[
            // Se reemplazan los botones por StandarButton
            StandarButton(
              text: 'Alertas Pendientes', 
              onPressed: () {
                // Navega a la página AlertListPage con el endpoint especificado
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlertListPage(endpoint: "GetAlertasByEstadoAlerta1&2")),
                );
              }
            ),
            // Se agrega separación entre botones
            SizedBox(height: 16), // Espacio entre los botones
            StandarButton(
              text: 'Alertas Atendidas', 
              onPressed: () {
                // Navega a la página AlertListPage con el endpoint especificado
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlertListPage(endpoint: "GetAlertasByEstadoAlerta3")),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}