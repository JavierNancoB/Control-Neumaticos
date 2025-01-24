import 'package:flutter/material.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onChanged;
  const RememberMeCheckbox({super.key, required this.rememberMe, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: onChanged,
        ),
        const Text('Recordar correo y contraseña'),
      ],
    );
  }
}
