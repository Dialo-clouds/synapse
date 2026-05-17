import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../core/services/pocketbase_service.dart';
import '../core/services/theme_service.dart';
import '../features/auth/biometric_screen.dart';
import '../features/landing/download_page.dart';
import 'home_shell.dart';

class SynapseApp extends StatefulWidget {
  const SynapseApp({super.key});

  @override
  State<SynapseApp> createState() => _SynapseAppState();
}

class _SynapseAppState extends State<SynapseApp> {
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _themeService.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SYNAPSE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeService.themeMode,
      home: PocketBaseService.isLoggedIn 
          ? const BiometricScreen()
          : const DownloadPage(),
    );
  }
}