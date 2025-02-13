import 'package:flutter/material.dart';
import 'admin_actions_screen.dart';
import '../../../services/admin/admin_menu_service.dart';
import '../../../widgets/button.dart';

class AdminOptions extends StatefulWidget {
  const AdminOptions({super.key});

  @override
  _AdminOptionsState createState() => _AdminOptionsState();
}

class _AdminOptionsState extends State<AdminOptions> {
  int? perfil;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadPerfil();
  }

  Future<void> _loadPerfil() async {
    int? perfilObtenido = await _authService.getPerfil();
    setState(() {
      perfil = perfilObtenido;
    });
  }

  void _navigateToOptions(BuildContext context, String option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptionActions(option: option),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones de Administrador'),
      ),
      body: Center(
        child: perfil == null
            ? const CircularProgressIndicator() // Muestra un loader mientras se obtiene el perfil
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (perfil == 1) _buildButton(context, 'Usuario'), // Se muestra solo si perfil == 1
                  const SizedBox(height: 20),
                  _buildButton(context, 'Movil'),
                  const SizedBox(height: 20),
                  _buildButton(context, 'Neumatico'),
                ],
              ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    // Se reemplaza el ElevatedButton por el widget Button
    return StandarButton(
      text: label,
      onPressed: () => _navigateToOptions(context, label),
    );
  }
}