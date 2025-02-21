import 'package:flutter/material.dart';
import 'admin_actions_screen.dart';
import '../../../services/admin/admin_menu_service.dart';
import '../../../widgets/button.dart';

// Clase principal que define el widget AdminOptions
class AdminOptions extends StatefulWidget {
  const AdminOptions({super.key});

  @override
  _AdminOptionsState createState() => _AdminOptionsState();
}

// Estado asociado al widget AdminOptions
class _AdminOptionsState extends State<AdminOptions> {
  int? perfil; // Variable para almacenar el perfil del usuario
  final AuthService _authService = AuthService(); // Instancia del servicio de autenticación

  @override
  void initState() {
    super.initState();
    _loadPerfil(); // Carga el perfil del usuario al inicializar el estado
  }

  // Método para cargar el perfil del usuario de manera asíncrona
  Future<void> _loadPerfil() async {
    int? perfilObtenido = await _authService.getPerfil(); // Obtiene el perfil del usuario
    setState(() {
      perfil = perfilObtenido; // Actualiza el estado con el perfil obtenido
    });
  }

  // Método para navegar a la pantalla de opciones según la opción seleccionada
  void _navigateToOptions(BuildContext context, String option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptionActions(option: option), // Navega a la pantalla de acciones con la opción seleccionada
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones de Administrador'), // Título de la AppBar
      ),
      body: Center(
        child: perfil == null
            ? const CircularProgressIndicator() // Muestra un loader mientras se obtiene el perfil
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (perfil == 1) _buildButton(context, 'Usuario'), // Muestra el botón solo si el perfil es 1
                  const SizedBox(height: 20), // Espacio entre botones
                  _buildButton(context, 'Movil'), // Botón para la opción "Movil"
                  const SizedBox(height: 20), // Espacio entre botones
                  _buildButton(context, 'Neumatico'), // Botón para la opción "Neumatico"
                ],
              ),
      ),
    );
  }

  // Método para construir un botón personalizado
  Widget _buildButton(BuildContext context, String label) {
    return StandarButton(
      text: label, // Texto del botón
      onPressed: () => _navigateToOptions(context, label), // Acción al presionar el botón
    );
  }
}