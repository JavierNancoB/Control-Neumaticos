import 'package:flutter/material.dart';

class StandarButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const StandarButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, // Ancho fijo para todos los botones
      child: ElevatedButton(
        onPressed: () {
          print("Botón presionado: $text");  // Verificar si el botón fue presionado
          onPressed();
        },
        child: Text(text),
      ),
    );
  }
}
