import 'package:flutter/material.dart';

class StandarButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Gradient? gradient;
  final double borderRadius; // Ahora sí definimos el parámetro

  const StandarButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.gradient,
    this.borderRadius = 8.0, // Valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    final Color textColor = color == Colors.yellow ? Colors.black : Colors.white;

    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey[400] : (color ?? Colors.lightBlueAccent),
          elevation: isDisabled ? 0 : 2,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
