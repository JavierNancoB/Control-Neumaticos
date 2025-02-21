import 'package:flutter/material.dart';
import '../../widgets/recuperar_contrasena/recuperar_contrasena_form.dart';


class RecuperarContrasenaPage extends StatelessWidget {
  const RecuperarContrasenaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const RecuperarContrasenaForm(),
    );
  }
}
