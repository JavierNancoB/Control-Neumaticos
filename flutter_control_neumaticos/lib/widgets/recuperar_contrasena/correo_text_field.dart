import 'package:flutter/material.dart';

class CorreoTextField extends StatelessWidget {
  const CorreoTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        border: OutlineInputBorder(),
      ),
    );
  }
}
