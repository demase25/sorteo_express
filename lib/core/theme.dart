import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales - Estilo Graffiti inspirado en el logo
  static const Color primaryColor = Color(0xFF00CED1); // Turquesa vibrante (spray del logo)
  static const Color secondaryColor = Color(0xFFFFD700); // Amarillo dorado ("SORTEO")
  static const Color accentColor = Color(0xFFFF4444); // Rojo intenso ("EXPRESS")
  static const Color errorColor = Color(0xFFE57373); // Rojo suave
  static const Color warningColor = Color(0xFFFFB74D); // Naranja suave

  // Colores adicionales - Paleta Graffiti
  static const Color graffitiYellow = Color(0xFFFFD700); // Amarillo graffiti
  static const Color graffitiRed = Color(0xFFFF4444); // Rojo graffiti
  static const Color graffitiTurquoise = Color(0xFF00CED1); // Turquesa graffiti
  static const Color graffitiBlack = Color(0xFF1A1A1A); // Negro graffiti
  static const Color graffitiWhite = Color(0xFFFFFFFF); // Blanco graffiti
  
  // Colores de fondo - Suaves y elegantes con toque Deep Sky Blue
  static const Color backgroundColor = Color(0xFFF0F8FF); // Blanco con toque Deep Sky Blue muy sutil
  static const Color surfaceColor = Color(0xFFFFFFFF); // Blanco
  static const Color cardColor = Color(0xFFFFFFFF); // Blanco
  
  // Colores de texto
  static const Color textPrimaryColor = Color(0xFF212121); // Negro suave
  static const Color textSecondaryColor = Color(0xFF757575); // Gris medio
  static const Color textLightColor = Color(0xFF9E9E9E); // Gris claro

  // Tema principal - Celeste marino suave
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textLightColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textLightColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(color: textLightColor, fontSize: 16),
        labelStyle: TextStyle(color: textSecondaryColor, fontSize: 16),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textPrimaryColor, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimaryColor, fontSize: 14),
        titleLarge: TextStyle(color: textPrimaryColor, fontSize: 20),
        titleMedium: TextStyle(color: textPrimaryColor, fontSize: 18),
        headlineMedium: TextStyle(color: textPrimaryColor, fontSize: 24),
      ),
    );
  }

  // Tema oscuro - Deep Sky Blue oscuro
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: Color(0xFF1A1F2A),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0F1A), // Fondo oscuro con toque Deep Sky Blue
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1F2A), // Tarjetas oscuras con toque Deep Sky Blue
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2F3A), // Campos con toque Deep Sky Blue
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
        labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
        titleLarge: TextStyle(color: Colors.white, fontSize: 20),
        titleMedium: TextStyle(color: Colors.white, fontSize: 18),
        headlineMedium: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  // Efectos especiales para botones graffiti
  static BoxDecoration get graffitiButtonDecoration {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: graffitiBlack, width: 2),
      boxShadow: [
        BoxShadow(
          color: graffitiBlack.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: primaryColor.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  // Efectos especiales para tarjetas de resultado
  static BoxDecoration get graffitiResultDecoration {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [graffitiYellow, graffitiRed],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: graffitiBlack, width: 3),
      boxShadow: [
        BoxShadow(
          color: graffitiBlack.withOpacity(0.4),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: graffitiYellow.withOpacity(0.3),
          blurRadius: 25,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }
}
