import 'package:flutter/material.dart';

class SynapseTokens {
  SynapseTokens._();

  // Deep void with aurora
  static const Color background = Color(0xFF000008);
  static const Color surface = Color(0xFF0A0A14);
  static const Color surfaceGlass = Color(0x0DFFFFFF);
  
  // Aurora palette
  static const Color primaryViolet = Color(0xFF7B2FFF);
  static const Color electricBlue = Color(0xFF00D4FF);
  static const Color auroraTeal = Color(0xFF00FFC8);
  static const Color plasmaAmber = Color(0xFFFF6B35);
  static const Color neuralPink = Color(0xFFFF2D95);
  
  // Functional
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color textTertiary = Color(0xFF444466);
  
  // Gradients
  static const LinearGradient auroraGradient = LinearGradient(
    colors: [Color(0xFF7B2FFF), Color(0xFF00D4FF), Color(0xFF00FFC8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient plasmaGradient = LinearGradient(
    colors: [Color(0xFFFF2D95), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double space2XL = 48.0;
  
  // Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 24.0;
  static const double radiusFull = 999.0;
  
  // Shadows
  static BoxShadow glow(Color color, {double opacity = 0.4, double blur = 30}) {
    return BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
      spreadRadius: 0,
    );
  }
  
  // Animation
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 700);
  static const Duration durationGlacial = Duration(milliseconds: 1200);
  
  static const Curve easeOutExpo = Cubic(0.16, 1, 0.3, 1);
  
  // Typography
  static const double fontSizeDisplay = 56.0;
  static const double fontSizeH1 = 40.0;
  static const double fontSizeH2 = 30.0;
  static const double fontSizeBody = 16.0;
  static const double fontSizeCaption = 12.0;
  static const double fontSizeOverline = 10.0;
}