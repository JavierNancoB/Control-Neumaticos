import 'package:flutter/material.dart';
import '../../widgets/button.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return StandarButton(
      text: 'Ingresar a CHiP-iT',
      onPressed: isLoading ? null : onPressed,
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(6, 192, 238, 1),
          Color.fromRGBO(57, 192, 191, 1),
        ],
      ),
      borderRadius: 15.0, // Ahora sí lo pasamos correctamente
    );
  }
}
