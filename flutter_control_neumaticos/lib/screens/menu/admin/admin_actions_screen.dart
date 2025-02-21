import 'package:flutter/material.dart';
import '../../nfc/nfc_reader.dart';
import 'usuario/ingresar_correo.dart';
import 'usuario/deshabilitar_usuario_screen.dart';
import 'usuario/anadir_usuario_screen.dart';
import 'movil/anadir_movil_screen.dart';
import 'movil/deshabilitar_movil_screen.dart';
import 'ingresar_patente.dart';
import '../../../widgets/button.dart';

// Clase que representa las acciones disponibles para una opción específica
class OptionActions extends StatelessWidget {
  final String option;

  // Constructor que recibe la opción seleccionada
  const OptionActions({super.key, required this.option});

  // Método que navega a la pantalla correspondiente según la acción y opción seleccionada
  void _navigateToAction(BuildContext context, String action) {
    late Widget page;

    // Selecciona la página correspondiente según la opción
    switch (option) {
      case 'Usuario':
        page = _getUsuarioPage(action);
        break;
      case 'Movil':
        page = _getMovilPage(action);
        break;
      case 'Neumatico':
        page = NFCReader(action: action);
        break;
      default:
        return;
    }

    // Navega a la página seleccionada
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Método que devuelve la página correspondiente para las acciones de usuario
  Widget _getUsuarioPage(String action) {
    switch (action) {
      case 'Añadir':
        return AnadirUsuarioPage();
      case 'Modificar':
        return IngresarCorreoPage(actionType: 'usuario');
      case 'Deshabilitar':
        return InhabilitarUsuarioPage();
      case 'Restablecer Contraseña':
        // Aquí luego añadiremos la página correspondiente
        return IngresarCorreoPage(actionType: 'contraseña'); 
      default:
        throw Exception('Acción no válida para Usuario');
    }
  }

  // Método que devuelve la página correspondiente para las acciones de móvil
  Widget _getMovilPage(String action) {
    switch (action) {
      case 'Añadir':
        return AnadirMovilPage();
      case 'Modificar':
        return IngresarPatentePage(tipo: 'movil', codigo: '');
      case 'Deshabilitar':
        return CambiarEstadoMovilPage();
      default:
        throw Exception('Acción no válida para Móvil');
    }
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
            // Si la opción no es 'Neumatico', muestra el botón de añadir
            if (option != 'Neumatico') _buildButton(context, 'Añadir'),
            // Muestra el botón de gestionar (modificar)
            _buildButton(context, 'Gestionar'),
            // Muestra el botón de deshabilitar
            _buildButton(context, 'Deshabilitar'),
            // Si la opción es 'Usuario', muestra el botón de restablecer contraseña
            if (option == 'Usuario') _buildButton(context, 'Restablecer Contraseña'),
          ],
        ),
      ),
    );
  }

  // Método que construye un botón con la acción correspondiente
  Widget _buildButton(BuildContext context, String action) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(bottom: 20),
      child: StandarButton(
        text: '$action $option',
        // Si la acción es 'Gestionar', se interpreta como 'Modificar'
        onPressed: () => _navigateToAction(context, action == 'Gestionar' ? 'Modificar' : action),
      ),
    );
  }
}
