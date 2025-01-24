import 'package:flutter/material.dart';
import 'correo_text_field.dart';
import 'enviar_button.dart';

class RecuperarContrasenaForm extends StatelessWidget {
  const RecuperarContrasenaForm({super.key});

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
          const CorreoTextField(),
          const SizedBox(height: 20),
          const EnviarButton(),
        ],
      ),
    );
  }
}
