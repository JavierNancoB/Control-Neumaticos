import 'package:flutter/material.dart';
import 'correo_text_field.dart';
import 'enviar_button.dart';
import '../../services/contrasena/recover_password_service.dart'; // Importar el servicio

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu correo electrónico.')),
      );
      return;
    }

    try {
      await _recoverPasswordService.enviarSolicitud(correo);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud de recuperación enviada con éxito.')),
      );
    } catch (e) {
      // Mostrar el error obtenido del servicio
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
          EnviarButton(onPressed: _enviarSolicitud), // Pasar la lógica de envío
        ],
      ),
    );
  }
}
