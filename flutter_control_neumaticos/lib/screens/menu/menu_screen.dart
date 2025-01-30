import 'package:flutter/material.dart';
import '../../widgets/button.dart'; 
import '../../screens/nfc/nfc_reader.dart';
import 'stock/stock_page.dart';
import 'patentes/patente_screen.dart';
import 'alertas/alertas_menu.dart';
import 'admin/admin_menu_screen.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona una opción')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StandarButton(
              text: 'Información por patente',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatentePage()),
                );
              },
            ),
            const SizedBox(height: 20),
            StandarButton(
              text: 'Bitácora',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NFCReader(action: 'informacion'),),
                );
              },
            ),
            const SizedBox(height: 20),
            StandarButton(
              text: 'Alertas',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlertasMenu()),
                );
              },
            ),
            const SizedBox(height: 20),
            StandarButton(
              text: 'Stock',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            StandarButton(
              text: 'Administración',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminOptions()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
