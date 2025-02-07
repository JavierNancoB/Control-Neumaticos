import 'package:flutter/material.dart';
import 'reestablecer_passw_page.dart'; // Asegúrate de importar la página de restablecimiento de contraseña

class SeleccionarRestablecimientoPage extends StatelessWidget {
  final String email;

  const SeleccionarRestablecimientoPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Método de Restablecimiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Selecciona cómo deseas restablecer la contraseña para el correo: $email',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
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
              child: Text('Restablecer Automáticamente'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
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
              child: Text('Ingresar Clave Manualmente'),
            ),
          ],
        ),
      ),
    );
  }
}
