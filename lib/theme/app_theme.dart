import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales - Thème sombre premium (Barber)
  static const Color primaryColor = Color(0xFFD4AF37); // Or premium
  static const Color backgroundColor = Color(0xFF121212); // Noir profond
  static const Color surfaceColor = Color(0xFF1E1E1E); // Gris très foncé
  static const Color cardColor = Color(0xFF242424); // Carte légèrement plus claire
  static const Color accentColor = Color(0xFFF3E5AB); // Or clair
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Colors.white70;
  static const Color dangerColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);
  // Couleur par défaut des boutons (violet)
  static const Color defaultButtonColor = Color(0xFF5E54A4);

  /// Génère le thème sombre avec une couleur de bouton dynamique
  static ThemeData darkTheme({Color buttonColor = defaultButtonColor}) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: dangerColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textPrimaryColor,
        tertiary: buttonColor, // couleur bouton accessible via colorScheme.tertiary
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: buttonColor),
        ),
        labelStyle: const TextStyle(color: textSecondaryColor),
        hintStyle: const TextStyle(color: textSecondaryColor),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimaryColor),
        bodyMedium: TextStyle(color: textSecondaryColor),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Color(0x555E54A4),
        selectionHandleColor: Colors.white,
      ),
    );
  }

  /// Génère le thème clair avec une couleur de bouton dynamique
  static ThemeData lightTheme({Color buttonColor = defaultButtonColor}) {
    const Color lightBackgroundColor = Color(0xFFF5F5F5);
    const Color lightSurfaceColor = Colors.white;
    const Color lightCardColor = Color(0xFFF0F0F0);
    const Color lightTextPrimaryColor = Colors.black87;
    const Color lightTextSecondaryColor = Colors.black54;

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: lightSurfaceColor,
        error: dangerColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: lightTextPrimaryColor,
        tertiary: buttonColor, // couleur bouton accessible via colorScheme.tertiary
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurfaceColor,
        elevation: 1,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightCardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: buttonColor),
        ),
        labelStyle: const TextStyle(color: lightTextSecondaryColor),
        hintStyle: const TextStyle(color: lightTextSecondaryColor),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: lightTextPrimaryColor, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: lightTextPrimaryColor, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: lightTextPrimaryColor, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: lightTextPrimaryColor, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: lightTextPrimaryColor, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: lightTextPrimaryColor),
        bodyMedium: TextStyle(color: lightTextSecondaryColor),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black87,
        selectionColor: Color(0x335E54A4),
        selectionHandleColor: Colors.black87,
      ),
    );
  }
}
