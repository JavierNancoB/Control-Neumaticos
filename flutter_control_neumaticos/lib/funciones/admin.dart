import 'package:flutter/material.dart';
import 'admin/usuario/añadir_usuario.dart';
import 'admin/movil/añadir_movil.dart';
import 'admin/neumatico/nfc_neumatico.dart'; // Página única para manejar neumáticos
import 'admin/usuario/ingresar_correo.dart';
import 'admin/movil/modificar_movil.dart';
import 'admin/usuario/inhabilitar_usuario.dart';
import 'admin/movil/inhabilitar_movil.dart';

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
            // Botón de "Usuario"
            Container(
              width: 250, // Ancho del botón             
              margin: const EdgeInsets.only(bottom: 20), // Separación de 20 píxeles
              child: ElevatedButton(
                onPressed: () => _navigateToOptions(context, 'Usuario'),
                child: const Text('Usuario'),
              ),
            ),
            // Botón de "Movil"
            Container(
              width: 250, // Ancho del botón              
              margin: const EdgeInsets.only(bottom: 20), // Separación de 20 píxeles
              child: ElevatedButton(
                onPressed: () => _navigateToOptions(context, 'Movil'),
                child: const Text('Movil'),
              ),
            ),
            // Botón de "Neumatico"
            Container(
              width: 250, // Ancho del botón
              margin: const EdgeInsets.only(bottom: 20), // Separación de 20 píxeles
              child: ElevatedButton(
                onPressed: () => _navigateToOptions(context, 'Neumatico'),
                child: const Text('Neumatico'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionActions extends StatelessWidget {
  final String option;

  const OptionActions({super.key, required this.option});

  void _navigateToAction(BuildContext context, String action) {
    late Widget page;

    switch (option) {
      case 'Usuario':
        if (action == 'Añadir') {
          page = AnadirUsuarioPage();
        } else if (action == 'Modificar') {
          page = IngresarCorreoPage();
        } else if (action == 'Inhabilitar/Habilitar') {
          page = InhabilitarUsuarioPage();
        }
        break;
      case 'Movil':
        if (action == 'Añadir') {
          page = AnadirMovilPage();
        } else if (action == 'Modificar') {
          // Mantén esto tal cual hasta que lo implementes
        } else {
          page = CambiarEstadoMovilPage();
        }
        break;
      case 'Neumatico':
        // Para todas las acciones de neumáticos, redirige a NfcNeumaticoPage
        page = NfcNeumaticoPage(action: action);
        break;
      default:
        return; // Salimos si no hay coincidencia
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar $option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botón de "Añadir"
            Container(
              width: 250, // Ancho del botón
              margin: const EdgeInsets.only(bottom: 20), // Separación de 20 píxeles
              child: ElevatedButton(
                onPressed: () => _navigateToAction(context, 'Añadir'),
                child: Text('Añadir $option'),
              ),
            ),
            // Botón de "Modificar"
            Container(
              width: 250, // Ancho del botón
              margin: const EdgeInsets.only(bottom: 20), // Separación de 20 píxeles
              child: ElevatedButton(
                onPressed: () => _navigateToAction(context, 'Modificar'),
                child: Text('Modificar $option'),
              ),
            ),
            // Botón de "Inhabilitar/Habilitar"
            Container(
              width: 250, // Ancho del botón
              margin: const EdgeInsets.only(bottom: 20), // Separación de 20 píxeles
              child: ElevatedButton(
                onPressed: () => _navigateToAction(context, 'Inhabilitar/Habilitar'),
                child: Text('Inhabilitar/Habilitar $option'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}