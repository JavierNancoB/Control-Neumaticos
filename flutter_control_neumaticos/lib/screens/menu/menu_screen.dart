import 'package:flutter/material.dart';
import '../../widgets/button.dart';
import '../../screens/nfc/nfc_reader.dart';
import 'stock/stock_page.dart';
import 'patentes/patente_screen.dart';
import 'alertas/alertas_menu.dart';
import 'admin/admin_menu_screen.dart';
import 'admin/usuario/reestablecer_passw_page.dart';
import '../../services/menu_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Color? alertaColor = Colors.grey[10];
  String? userEmail;
  bool isDisabled = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkAlertaPendiente();
    _loadUserData(); // Cargar el correo y fecha del usuario después de loguearse
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

  // Método para cargar el correo y la fecha del usuario autenticado
  void _loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final String? dateString = prefs.getString('date');
  final String? username = prefs.getString('username');

  print('Fecha guardada en preferencias: $dateString');
  print('Usuario guardado en preferencias: $username');

  if (dateString != null && username != null) {
    setState(() {
      userEmail = username;
    });

    // Convertir la fecha guardada de string a DateTime
    DateTime fechaClave = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    int difference = now.difference(fechaClave).inDays;

    print('Fecha actual: $now');
    print('Fecha clave almacenada: $fechaClave');
    print('Diferencia en días: $difference');

    // Si la diferencia es mayor a 70, deshabilitamos las opciones
    if (difference > 70) {
      setState(() {
        isDisabled = true;
        errorMessage = 'Te quedan ${80 - difference} días para cambiar tu contraseña. Se deshabilitarán opciones, en caso de exceder el tiempo se bloqueará tu cuenta.';
      });
      print('Usuario deshabilitado. Mensaje de error: $errorMessage');
    }
  }
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (isDisabled)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center, // Asegura que el texto esté centrado
                  ),
                ),
              ),
              StandarButton(
                text: 'Información por patente',
                onPressed: isDisabled ? null : () => _navigateTo(context, PatentePage()),
                color: isDisabled ? Colors.grey[400] : null,
              ),
              const SizedBox(height: 20),
              StandarButton(
                text: 'Bitácora',
                onPressed: isDisabled ? null : () => _navigateTo(context, NFCReader(action: 'informacion')),
                color: isDisabled ? Colors.grey[400] : null,
              ),
              const SizedBox(height: 20),
              StandarButton(
                text: alertaColor == Colors.yellow ? 'Existen alertas pendientes' : 'Alertas',
                onPressed: isDisabled ? null : () => _navigateTo(context, AlertasMenu()),
                color: isDisabled ? Colors.grey[400] : alertaColor,
              ),
              const SizedBox(height: 20),
              StandarButton(
                text: 'Stock',
                onPressed: isDisabled ? null : () => _navigateTo(context, StockPage()),
                color: isDisabled ? Colors.grey[400] : null,
              ),
              const SizedBox(height: 20),
              StandarButton(
                text: 'Administración',
                onPressed: isDisabled ? null : () => _navigateTo(context, const AdminOptions()),
                color: isDisabled ? Colors.grey[400] : null,
              ),
              const SizedBox(height: 20),
              StandarButton(
                text: 'Reestablecer Contraseña',
                onPressed: () {
                  if (userEmail != null) {
                    _navigateTo(
                      context,
                      ReestablecerPasswPage(
                        email: userEmail!,
                        autoGenerada: false,
                        admin: false,
                      ),
                    );
                  }
                },
              ),
            ]
          ),
        ),
      ),
    );
  }
}
