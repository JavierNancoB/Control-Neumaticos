import 'package:flutter/material.dart';
import '../../nfc/nfc_reader.dart';
import 'usuario/ingresar_correo.dart';
import 'usuario/deshabilitar_usuario_screen.dart';
import 'usuario/añadir_usuario_screen.dart';
import 'movil/añadir_movil_screen.dart';
import 'movil/deshabilitar_movil_screen.dart';
import 'ingresar_patente.dart';


class OptionActions extends StatelessWidget {
  final String option;

  const OptionActions({super.key, required this.option});

  void _navigateToAction(BuildContext context, String action) {
    late Widget page;

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

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _getUsuarioPage(String action) {
    switch (action) {
      
      case 'Añadir':
        return AnadirUsuarioPage();
      case 'Modificar':
        return IngresarCorreoPage();
      case 'Deshabilitar':
        return InhabilitarUsuarioPage();
      default:
        throw Exception('Acción no válida para Usuario');
    }
  }

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
            _buildButton(context, 'Añadir'),
            _buildButton(context, 'Modificar'),
            _buildButton(context, 'Deshabilitar'),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String action) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: () => _navigateToAction(context, action),
        child: Text('$action $option'),
      ),
    );
  }
}
