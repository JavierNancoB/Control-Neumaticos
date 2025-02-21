import 'package:flutter/material.dart';
import '../../widgets/recuperar_contrasena/recuperar_contrasena_form.dart';

// Clase que representa la página de recuperación de contraseña
class RecuperarContrasenaPage extends StatelessWidget {
  const RecuperarContrasenaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de aplicación en la parte superior de la pantalla
      appBar: AppBar(),
      // Cuerpo de la página que contiene el formulario de recuperación de contraseña
      body: const RecuperarContrasenaForm(),
    );
  }
}
