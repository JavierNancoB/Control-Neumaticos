import 'package:flutter/material.dart';
import '../button.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return StandarButton(
      onPressed: onPressed,
      text: 'Añadir Bitácora',
    );
  }
}
