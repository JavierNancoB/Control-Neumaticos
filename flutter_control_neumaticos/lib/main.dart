import 'package:flutter/material.dart';
import 'package:pentacrom_neumaticos_2/screens/splash/splash_screen.dart';
import 'models/temas/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme, // Usa el tema global
      home: const SplashScreen(), // Mostramos el SplashScreen primero
    );
  }
}
