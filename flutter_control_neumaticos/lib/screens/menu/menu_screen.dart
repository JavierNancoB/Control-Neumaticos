import 'package:flutter/material.dart';
import '../../widgets/button.dart'; 
import '../../screens/nfc/nfc_reader.dart';
import 'stock/stock_page.dart';
import 'patentes/patente_screen.dart';
import 'alertas/alertas_menu.dart';
import 'admin/admin_menu_screen.dart';
import '../../services/menu_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Color? alertaColor = Colors.grey[10];

  @override
  void initState() {
    super.initState();
    _checkAlertaPendiente();
  }

  void _checkAlertaPendiente() {
    checkAlertaPendiente().then((isAlertaPendiente) {
      setState(() {
        alertaColor = isAlertaPendiente ? Colors.yellow : Colors.grey[10];
      });
    }).catchError((e) {
      print('Error al verificar alertas: $e');
    });
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page))
        .then((_) {
      // Cuando volvemos de la pantalla, recargamos el menú
      setState(() {
        _checkAlertaPendiente();
      });
    });
  }

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
              onPressed: () => _navigateTo(context, PatentePage()),
            ),
            const SizedBox(height: 20),
            StandarButton(
              text: 'Bitácora',
              onPressed: () => _navigateTo(context, NFCReader(action: 'informacion')),
            ),
            const SizedBox(height: 20),
            StandarButton(
              text: alertaColor == Colors.yellow ? 'Existen alertas pendientes' : 'Alertas',
              onPressed: () => _navigateTo(context, AlertasMenu()),
              color: alertaColor,
            ),
            const SizedBox(height: 20),
            StandarButton(
              text: 'Stock',
              onPressed: () => _navigateTo(context, StockPage()),
            ),
            const SizedBox(height: 20),
            StandarButton(
              text: 'Administración',
              onPressed: () => _navigateTo(context, const AdminOptions()),
            ),
          ],
        ),
      ),
    );
  }
}
