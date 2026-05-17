import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../app/home_shell.dart';
import '../../features/auth/login_screen.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000008), Color(0xFF0A0020), Color(0xFF000008)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Text(
                    'SYNAPSE',
                    style: TextStyle(
                      fontSize: isMobile ? 32 : 48,
                      fontWeight: FontWeight.w200,
                      color: SynapseTokens.electricBlue.withOpacity(0.9),
                      letterSpacing: 12,
                    ),
                  ).animate().fadeIn().scale(),
                  
                  const SizedBox(height: 8),
                  Text(
                    'SPATIAL INTELLIGENCE PLATFORM',
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.w600,
                      color: SynapseTokens.primaryViolet.withOpacity(0.7),
                      letterSpacing: 4,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 200)),

                  const SizedBox(height: 48),

                  // Tagline
                  Text(
                    'Point. Detect. Control.',
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 1,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 400)),

                  const SizedBox(height: 8),
                  Text(
                    'Your home, intelligently connected.',
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 16,
                      color: SynapseTokens.textTertiary,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 600)),

                  const SizedBox(height: 48),

                  // QR Code section (for mobile download)
                  if (!isMobile) ...[
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: SynapseTokens.electricBlue.withOpacity(0.3), blurRadius: 30)],
                      ),
                      child: Column(
                        children: [
                          // Simulated QR code
                          CustomPaint(
                            size: const Size(160, 160),
                            painter: _QRCodePainter(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Scan to download',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: const Duration(milliseconds: 800)).scale(),
                  ],

                  const SizedBox(height: 32),

                  // Platform buttons
                  if (isMobile) ...[
                    _PlatformButton(
                      icon: Icons.android,
                      label: 'Download for Android',
                      color: const Color(0xFF3DDC84),
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _PlatformButton(
                      icon: Icons.apple,
                      label: 'Download for iOS',
                      color: Colors.white,
                      onTap: () {},
                    ),
                  ] else ...[
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _PlatformButton(
                          icon: Icons.android,
                          label: 'Android',
                          color: const Color(0xFF3DDC84),
                          onTap: () {},
                        ),
                        _PlatformButton(
                          icon: Icons.apple,
                          label: 'iOS',
                          color: Colors.white,
                          onTap: () {},
                        ),
                        _PlatformButton(
                          icon: Icons.language,
                          label: 'Web App',
                          color: SynapseTokens.electricBlue,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const LoginScreen(),
                                transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                              ),
                            );
                          },
                        ),
                        _PlatformButton(
                          icon: Icons.desktop_windows,
                          label: 'Desktop',
                          color: SynapseTokens.primaryViolet,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Version
                  Text(
                    'v1.0.0 • Available on all platforms',
                    style: TextStyle(fontSize: 11, color: SynapseTokens.textTertiary.withOpacity(0.5)),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 1200)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlatformButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PlatformButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 1000)).slideY(begin: 10, end: 0);
  }
}

class _QRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final squareSize = size.width / 25;
    
    // QR code pattern (simplified)
    final pattern = [
      [1,1,1,1,1,1,1,0,1,0,1,0,0,0,1,1,1,1,1,1,1,0,0,0,0],
      [1,0,0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0],
      [1,0,1,1,1,0,1,0,1,1,1,1,0,0,0,1,1,0,1,0,0,0,0,0,0],
      [1,0,1,1,1,0,1,0,0,0,1,1,0,0,0,1,1,0,1,0,0,0,0,0,0],
      [1,0,1,1,1,0,1,0,1,0,0,0,0,0,0,1,1,0,1,0,0,0,0,0,0],
      [1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,1,0,1,0,0,0,0,0,0],
      [1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0],
      [1,0,0,1,0,0,0,0,1,1,1,0,0,1,0,1,0,0,1,0,1,0,0,0,0],
      [0,1,0,1,1,0,1,0,0,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0],
      [0,1,1,0,0,1,0,1,1,0,1,1,0,1,1,1,0,0,1,0,0,0,0,0,0],
      [0,0,1,1,1,0,0,0,1,1,0,1,0,0,1,0,1,1,0,0,0,0,0,0,0],
      [1,1,0,0,0,1,1,1,0,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,1,0,1,1,0,1,0,0,0,1,1,0,0,0,0,0],
      [1,1,1,1,1,1,1,0,1,1,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0],
      [1,0,0,0,0,0,1,0,1,1,1,1,0,1,1,0,0,0,1,0,0,0,0,0,0],
      [1,0,1,1,1,0,1,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0],
      [1,0,1,1,1,0,1,0,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0],
      [1,0,1,1,1,0,1,0,0,1,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0],
      [1,0,0,0,0,0,1,0,1,0,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0],
      [1,1,1,1,1,1,1,0,0,1,1,0,0,1,0,0,0,0,1,0,0,0,0,0,0],
    ];

    for (int row = 0; row < pattern.length; row++) {
      for (int col = 0; col < pattern[row].length; col++) {
        if (pattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(col * squareSize, row * squareSize, squareSize, squareSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QRCodePainter oldDelegate) => false;
}