import 'package:flutter/material.dart';
import 'funciones/nfc_reader_page.dart'; // Importa la página de lectura NFC
import 'funciones/patente_page.dart';  // Importa la página de ingreso de patente
import 'funciones/alertas_page.dart';  // Importa la página de alertas
import 'funciones/options_stock.dart';  // Importa la página de stock
import 'funciones/admin.dart';  // Importa la página de administración

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona una opción')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botón para información detallada por patente
            SizedBox(
              width: 250,  // Ancho fijo para todos los botones
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatentePage()),
                  );
                  // Lógica para buscar por patente (aún por implementar)
                },
                child: const Text('Información por patente'),
              ),
            ),
            const SizedBox(height: 20),
            // Botón para leer chips NFC
            SizedBox(
              width: 250,  // Ancho fijo para todos los botones
              child: ElevatedButton(
                onPressed: () {
                  // Redirige a la página de lectura NFC
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NFCReader()),
                  );
                },
                child: const Text('Bitacora'),
              ),
            ),
            const SizedBox(height: 20),
            // Botón para alertas
            SizedBox(
              width: 250,  // Ancho fijo para todos los botones
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlertasPage()),
                  );
                  // Lógica para mostrar alertas (por implementar)
                },
                child: const Text('Alertas'),
              ),
            ),
            const SizedBox(height: 20),
            // Botón para stock
            SizedBox(
              width: 250,  // Ancho fijo para todos los botones
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para manejar stock (por implementar)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StockPage()),
                  );
                },
                child: const Text('Stock'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,  // Ancho fijo para todos los botones
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para manejar stock (por implementar)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminOptions()),
                  );
                },
                child: const Text('Administrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
