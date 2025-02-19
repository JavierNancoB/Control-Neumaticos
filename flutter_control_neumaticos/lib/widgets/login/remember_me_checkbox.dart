import 'package:flutter/material.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onChanged;
  const RememberMeCheckbox({super.key, required this.rememberMe, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.translate(
          offset: Offset(10, 0), // Mueve el checkbox 4 píxeles a la izquierda (puedes poner un valor negativo)
          child: Checkbox(
            value: rememberMe,
            onChanged: onChanged,
          ),
        ),
        const Text('Recordar correo y contraseña'),
      ],
    );
  }
}
