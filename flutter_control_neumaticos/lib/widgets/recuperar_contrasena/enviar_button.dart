import 'package:flutter/material.dart';

class EnviarButton extends StatelessWidget {
  const EnviarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Lógica de recuperación de contraseña aquí
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Función de recuperación de contraseña no implementada'),
          ),
        );
      },
      child: const Text('Enviar'),
    );
  }
}
