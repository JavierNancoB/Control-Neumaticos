import 'package:flutter/material.dart';
import 'reestablecer_passw_page.dart'; // Asegúrate de importar la página de restablecimiento de contraseña
import '../../../../widgets/button.dart';

class SeleccionarRestablecimientoPage extends StatelessWidget {
  final String email;

  // Constructor de la clase, recibe el correo electrónico como parámetro
  const SeleccionarRestablecimientoPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de la aplicación con el título
      appBar: AppBar(
        title: Text('Reestablecer Contraseña'),
      ),
      // Cuerpo de la página con padding
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Texto que pregunta cómo se prefiere restablecer la contraseña
            Text(
              '¿Cómo prefieres restablecer la contraseña para el correo $email?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20), // Espacio entre el texto y el primer botón
            // Botón para restablecer la contraseña automáticamente
            StandarButton(
              onPressed: () {
                // Redirigir al endpoint de clave automática
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReestablecerPasswPage(
                      email: email,
                      autoGenerada: true, // Método automático
                      admin: true,
                    ),
                  ),
                );
              },
              text: 'Restablecer Automáticamente',
            ),
            SizedBox(height: 20), // Espacio entre los dos botones
            // Botón para ingresar la clave manualmente
            StandarButton(
              onPressed: () {
                // Redirigir al endpoint de clave manual
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReestablecerPasswPage(
                      email: email,
                      autoGenerada: false, // Método manual
                      admin: true,
                    ),
                  ),
                );
              },
              text: 'Ingresar Clave Manualmente',
            ),
          ],
        ),
      ),
    );
  }
}
