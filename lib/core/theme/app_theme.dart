import 'package:flutter/material.dart';
import '../tokens/synapse_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF000008),
      colorScheme: const ColorScheme.dark(
        primary: SynapseTokens.primaryViolet,
        secondary: SynapseTokens.electricBlue,
        surface: SynapseTokens.surface,
        error: SynapseTokens.neuralPink,
      ),
      fontFamily: 'Inter',
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF5F5FF),
      colorScheme: const ColorScheme.light(
        primary: SynapseTokens.primaryViolet,
        secondary: SynapseTokens.electricBlue,
        surface: Color(0xFFFFFFFF),
        error: SynapseTokens.neuralPink,
      ),
      fontFamily: 'Inter',
    );
  }
}