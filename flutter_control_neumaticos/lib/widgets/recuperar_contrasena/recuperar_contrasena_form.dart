import 'package:flutter/material.dart';
import 'correo_text_field.dart';
import '../../services/contrasena/recover_password_service.dart'; // Importar el servicio
import '../button.dart';
import '../../utils/snackbar_util.dart'; // Importar el CustomScaffold

class RecuperarContrasenaForm extends StatefulWidget {
  const RecuperarContrasenaForm({super.key});

  @override
  _RecuperarContrasenaFormState createState() => _RecuperarContrasenaFormState();
}

class _RecuperarContrasenaFormState extends State<RecuperarContrasenaForm> {
  final TextEditingController _correoController = TextEditingController();
  final RecoverPasswordService _recoverPasswordService = RecoverPasswordService();

  Future<void> _enviarSolicitud() async {
    final correo = _correoController.text;

    if (correo.isEmpty) {
      showCustomSnackBar(context, 'Por favor, ingresa tu correo electrónico.', isError: true);
      return;
    }

    try {
      await _recoverPasswordService.enviarSolicitud(correo);
      showCustomSnackBar(context, 'Solicitud de recuperación enviada con éxito.');
    } catch (e) {
      showCustomSnackBar(context, e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 100),
          const Text(
            'Recuperar Contraseña',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CorreoTextField(controller: _correoController), // Usar el controller
          const SizedBox(height: 20),
          StandarButton(
            text: 'Enviar Solicitud',
            onPressed: _enviarSolicitud,
          ) // Pasar la lógica de envío
        ],
      ),
    );
  }
}
