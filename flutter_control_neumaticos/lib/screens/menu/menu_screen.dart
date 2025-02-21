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

// Clase principal que representa la pantalla del menú
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

// Estado de la clase MenuScreen
class _MenuScreenState extends State<MenuScreen> {
  // Variables de estado
  Color? alertaColor = Colors.grey[10]; // Color para indicar alertas pendientes
  String? userEmail; // Email del usuario
  String? username; // Nombre de usuario
  String nombres = ''; // Nombre completo del usuario
  bool isDisabled = false; // Indica si los botones están deshabilitados
  String errorMessage = ''; // Mensaje de error
  String warningMessage = ''; // Mensaje de advertencia

  @override
  void initState() {
    super.initState();
    _checkAlertaPendiente(); // Verifica si hay alertas pendientes
    _loadUserData(); // Carga los datos del usuario
  }

  // Verifica si hay alertas pendientes
  void _checkAlertaPendiente() {
    checkAlertaPendiente().then((isAlertaPendiente) {
      setState(() {
        alertaColor = isAlertaPendiente ? Colors.yellow : Colors.grey[10];
      });
    }).catchError((e) {});
  }

  // Carga los datos del usuario desde SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dateString = prefs.getString('date');
    final String? username = prefs.getString('username'); // Email del usuario
    final String contrasenaTemporal = prefs.getString('contrasenaTemporal') ?? '';
    final String nombres = prefs.getString('nombres') ?? ''; // Nombre completo del usuario

    setState(() {
      this.nombres = nombres; // Actualiza el nombre del usuario
      userEmail = username; // Actualiza el email del usuario
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

  // Navega a una nueva página
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page)).then((_) {
      setState(() {
        _checkAlertaPendiente(); // Verifica alertas pendientes al regresar
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido $nombres')), // Título de la AppBar
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Mensajes de error o advertencia
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
              // Botón para información por patente
              StandarButton(
                text: 'Información por patente',
                onPressed: isDisabled ? null : () => _navigateTo(context, PatentePage()),
                color: isDisabled ? Colors.grey[400] : null,
              ),
              const SizedBox(height: 20),
              // Botón para bitácora
              StandarButton(
                text: 'Bitácora',
                onPressed: isDisabled ? null : () => _navigateTo(context, NFCReader(action: 'informacion')),
                color: isDisabled ? Colors.grey[400] : null,
              ),
              const SizedBox(height: 20),
              // Botón para alertas
              StandarButton(
                text: alertaColor == Colors.yellow ? 'Existen alertas pendientes' : 'Alertas',
                onPressed: isDisabled ? null : () => _navigateTo(context, AlertasMenu()),
                color: isDisabled ? Colors.grey[400] : alertaColor,
              ),
              const SizedBox(height: 20),
              // Botón para stock
              StandarButton(
                text: 'Stock',
                onPressed: isDisabled ? null : () => _navigateTo(context, StockPage()),
                color: isDisabled ? Colors.grey[400] : null,
              ),
              const SizedBox(height: 20),
              // Botón para administración
              StandarButton(
                text: 'Administración',
                onPressed: isDisabled ? null : () => _navigateTo(context, const AdminOptions()),
                color: isDisabled ? Colors.grey[400] : null,
              ),
              const SizedBox(height: 20),
              // Botón para generar reporte
              StandarButton(
                text: 'Generar Reporte',
                onPressed: isDisabled ? null : () => _navigateTo(context, GenerarReporteScreen()),
                color: isDisabled ? Colors.grey[400] : null,
              ),
              const SizedBox(height: 20),
              // Botón para reestablecer contraseña
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