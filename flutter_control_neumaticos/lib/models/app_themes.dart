import 'package:flutter/material.dart';
import 'app_colors.dart'; // Importa la paleta de colores

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background, // Fondo global
      primaryColor: AppColors.primary,
      colorScheme: AppColors.colorScheme,
      appBarTheme: AppBarTheme( // 🎨 Personaliza todas las AppBars
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white, // Color del texto y botones
        elevation: 4, // Sombra
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Color de los íconos en la AppBar
        ),
      ),
    );
  }
}
