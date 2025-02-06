import 'package:flutter/material.dart';

class CorreoTextField extends StatelessWidget {
  final TextEditingController controller;

  const CorreoTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Correo Electrónico',
        border: OutlineInputBorder(),
      ),
    );
  }
}
