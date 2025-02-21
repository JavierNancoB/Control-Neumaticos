import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  final backgroundColor = isError ? Colors.redAccent : Colors.green;
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white), // Letras siempre blancas
      ),
      backgroundColor: backgroundColor,
    ),
  );
}
