import 'package:flutter/material.dart';

class EnviarButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EnviarButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Llamar a la función pasada
      child: const Text('Enviar'),
    );
  }
}
