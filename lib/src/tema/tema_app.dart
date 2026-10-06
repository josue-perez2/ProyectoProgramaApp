import 'package:flutter/material.dart';

abstract final class Colores {
  static const fondo = Color(0xFFFFFFFF);
  static const fondoAlto = Color(0xFFF1F7F4);
  static const verdePrimario = Color(0xFF015443);
  static const verdeSecundario = Color(0xFF0B7A5E);
  static const verdeProfundo = Color(0xFF00382D);
  static const verdeBoton = Color(0xFF015443);
  static const textoPrimario = Color(0xFF015443);
  static const textoSecundario = Color(0xFF015443);
  static const textoTarjeta = Color(0xFF055242);
  static const azulTarjeta = Color(0xFF1D4ED8);
  static const rojoError = Color(0xFFC82909);
}

abstract final class TemaApp {
  static ThemeData get claro {
    final esquema = ColorScheme.fromSeed(
      seedColor: Colores.verdePrimario,
      brightness: Brightness.light,
    ).copyWith(
      surface: Colores.fondo,
      onSurface: Colores.textoPrimario,
      primary: Colores.verdePrimario,
      onPrimary: Colors.white,
      error: Colores.rojoError,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: Colores.fondo,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colores.textoPrimario,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: Colores.textoPrimario),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colores.verdePrimario.withValues(alpha: 0.09),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: const TextStyle(color: Colores.textoSecundario),
        labelStyle: const TextStyle(color: Colores.textoSecundario),
        prefixIconColor: Colores.verdeBoton,
        suffixIconColor: Colores.verdeBoton,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colores.verdePrimario.withValues(alpha: 0.45),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colores.verdeBoton, width: 2.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colores.rojoError, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colores.rojoError, width: 2.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colores.verdeBoton,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colores.verdePrimario.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white70,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: const BorderSide(color: Colores.verdeBoton, width: 1.8),
          foregroundColor: Colores.verdeBoton,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colores.verdeProfundo,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Colores.textoPrimario,
          fontSize: 28,
          fontWeight: FontWeight.w800,
        ),
        bodyMedium: TextStyle(color: Colores.textoPrimario, fontSize: 15),
      ),
    );
  }
}
