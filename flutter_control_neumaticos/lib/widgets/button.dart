import 'package:flutter/material.dart';

class StandarButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color; // Agregar el color como parámetro opcional

  const StandarButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color, // Color es opcional
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, // Ancho fijo para todos los botones
      child: ElevatedButton(
        onPressed: () {
          print("Botón presionado: $text");  // Verificar si el botón fue presionado
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.grey[10], // Cambiado 'primary' por 'backgroundColor'
        ),
        child: Text(text),
      ),
    );
  }
}

