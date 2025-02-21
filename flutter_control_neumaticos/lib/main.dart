import 'package:flutter/material.dart'; // Importa el paquete de Flutter para usar widgets de Material Design
import 'package:pentacrom_neumaticos_2/screens/splash/splash_screen.dart'; // Importa la pantalla de splash
import 'models/temas/app_themes.dart'; // Importa los temas de la aplicación

void main() {
  runApp(const MyApp()); // Ejecuta la aplicación MyApp
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor de la clase MyApp

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de modo debug
      theme: AppTheme.theme, // Usa el tema global definido en AppTheme
      home: const SplashScreen(), // Establece SplashScreen como la pantalla inicial
    );
  }
}
