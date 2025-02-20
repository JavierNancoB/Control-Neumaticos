import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; // Importa la paleta de colores

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background, // Fondo global
      primaryColor: AppColors.primary,
      colorScheme: AppColors.colorScheme,
      textTheme: GoogleFonts.figtreeTextTheme(
        ThemeData.light().textTheme, // Aplica Figtree a todo el texto
      ).apply(
        bodyColor: AppColors.primary, // Mantén el color primario para el texto
        displayColor: AppColors.primary, // Mantén el color primario para el texto
      ),
      appBarTheme: AppBarTheme( // 🎨 Personaliza todas las AppBars
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white, // Color del texto y botones
        elevation: 4, // Sombra
        centerTitle: true,
        titleTextStyle: GoogleFonts.figtree( // Usa Figtree en el título
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
