import 'package:flutter/material.dart';

class StandarButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  const StandarButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed, // Deshabilitar completamente el botón
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey[400] : (color ?? Colors.grey[10]),
          elevation: isDisabled ? 0 : 2, // Sin sombra cuando está deshabilitado
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}
