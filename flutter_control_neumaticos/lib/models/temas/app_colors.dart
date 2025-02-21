import 'package:flutter/material.dart';

class AppColors {
  static final Color? background = Colors.grey[50]; // Color de fondo
  static final Color primary = Color.fromRGBO(88, 83, 163, 1); // Color primario
  static const Color secondary = Colors.orangeAccent;
  static const Color surface = Colors.white; // Color para tarjetas, diálogos
  static const Color error = Colors.redAccent; // Color de error
  static const Color onPrimary = Colors.white; // Texto sobre color primario
  static const Color onSecondary = Colors.black; // Texto sobre color secundario
  static const Color onBackground = Colors.black; // Texto sobre fondo
  static final Color onSurface = Color.fromRGBO(88, 83, 163, 1); // Texto sobre superficies
  static const Color onError = Colors.white; // Texto sobre errores

  // ColorScheme personalizado
  static final ColorScheme colorScheme = ColorScheme(
    primary: primary,
    secondary: secondary,
    surface: surface,
    error: error,
    onPrimary: onPrimary,
    onSecondary: onSecondary,
    onSurface: onSurface,
    onError: onError,
    brightness: Brightness.light, // Cambia a Brightness.dark si es un tema oscuro
  );
}
