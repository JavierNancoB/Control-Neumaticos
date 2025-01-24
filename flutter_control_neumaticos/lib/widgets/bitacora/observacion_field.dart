import 'package:flutter/material.dart';

class ObservacionField extends StatelessWidget {
  final TextEditingController controller;

  const ObservacionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Observación'),
      maxLength: 250,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese una observación';
        }
        return null;
      },
    );
  }
}
