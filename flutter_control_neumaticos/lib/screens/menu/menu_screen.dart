import 'package:flutter/material.dart';
import '../../widgets/button.dart';
import '../../screens/nfc/nfc_reader.dart';
import 'stock/stock_page.dart';
import 'patentes/buscar_movil_screen.dart';
import 'alertas/alertas_menu.dart';
import 'admin/admin_menu_screen.dart';
import 'admin/usuario/reestablecer_passw_page.dart';
import 'Reportes/generar_reporte_screen.dart';
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
  String? username;
  String nombres = ''; // Aquí mantienes la variable 'nombres' para el nombre de la persona
  bool isDisabled = false;
  String errorMessage = '';
  String warningMessage = '';

  @override
  void initState() {
    super.initState();
    _checkAlertaPendiente();
    _loadUserData();
  }

  void _checkAlertaPendiente() {
    checkAlertaPendiente().then((isAlertaPendiente) {
      setState(() {
        alertaColor = isAlertaPendiente ? Colors.yellow : Colors.grey[10];
      });
    }).catchError((e) {});
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dateString = prefs.getString('date');
    final String? username = prefs.getString('username'); // Esto sigue siendo para el email
    final String contrasenaTemporal = prefs.getString('contrasenaTemporal') ?? '';
    final String nombres = prefs.getString('nombres') ?? ''; // Aquí obtienes el nombre de la persona

    setState(() {
      this.nombres = nombres; // Aquí se actualiza la variable de instancia 'nombres'
      userEmail = username; // Solo actualizas 'userEmail' si es necesario
    });

    DateTime now = DateTime.now();
    if (dateString != null) {
      DateTime fechaClave = DateTime.parse(dateString);
      int difference = now.difference(fechaClave).inDays;
      
      if (difference > 70) {
        setState(() {
          warningMessage = 'Te quedan ${80 - difference} días para cambiar tu contraseña.';
        });
      }
    }

    if (contrasenaTemporal.isNotEmpty) {
      setState(() {
        isDisabled = true;
        errorMessage = 'Debes cambiar tu contraseña temporal antes de acceder a otras opciones.';
      });
    }
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page)).then((_) {
      setState(() {
        _checkAlertaPendiente();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido $nombres')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Usamos un Spacer aquí para centrar los mensajes en la parte superior
              if (errorMessage.isNotEmpty || warningMessage.isNotEmpty || (errorMessage.isEmpty && warningMessage.isEmpty))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        if (errorMessage.isNotEmpty)
                          Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        if (warningMessage.isNotEmpty)
                          Text(
                            warningMessage,
                            style: TextStyle(color: Colors.orange, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        if (errorMessage.isEmpty && warningMessage.isEmpty)
                          Text(
                            'Selecciona una opción',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20), // Espacio entre los mensajes y los botones
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
                text: 'Generar Reporte',
                onPressed: isDisabled ? null : () => _navigateTo(context, GenerarReporteScreen()),
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
            ],
          ),
        ),
      ),
    );
  }

}