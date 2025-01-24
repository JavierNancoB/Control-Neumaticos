import 'package:flutter/material.dart';
import 'admin_actions_screen.dart';

class AdminOptions extends StatelessWidget {
  const AdminOptions({super.key});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(context, 'Usuario'),
            _buildButton(context, 'Movil'),
            _buildButton(context, 'Neumatico'),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: () => _navigateToOptions(context, label),
        child: Text(label),
      ),
    );
  }
}
