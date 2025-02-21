import 'package:flutter/material.dart';

// Función para mostrar un SnackBar personalizado
void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  // Determina el color de fondo basado en si es un error o no
  final backgroundColor = isError ? Colors.redAccent : Colors.green;
  
  // Muestra el SnackBar en el ScaffoldMessenger del contexto proporcionado
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // Contenido del SnackBar, que es un texto con el mensaje proporcionado
      content: Text(
        message,
        style: const TextStyle(color: Colors.white), // Letras siempre blancas
      ),
      // Color de fondo del SnackBar
      backgroundColor: backgroundColor,
    ),
  );
}
