import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../app/home_shell.dart';
import 'spatial_pin_screen.dart';
import 'voice_auth_screen.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _scanController;
  late AnimationController _pulseController;
  bool _scanning = false;
  bool _complete = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _scanning = true;
    });
    _scanController.forward(from: 0);
    
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _scanning = false;
          _complete = true;
        });
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                transitionDuration: SynapseTokens.durationSlow,
                pageBuilder: (_, __, ___) => const HomeShell(),
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_scanController, _pulseController]),
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Face outline
                  GestureDetector(
                    onTap: _scanning ? null : _startScan,
                    child: Container(
                      width: 200,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _complete
                              ? SynapseTokens.auroraTeal.withOpacity(0.6)
                              : SynapseTokens.electricBlue.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: _scanning
                            ? [
                                BoxShadow(
                                  color: SynapseTokens.electricBlue.withOpacity(0.2),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ]
                            : _complete
                                ? [
                                    BoxShadow(
                                      color: SynapseTokens.auroraTeal.withOpacity(0.3),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ]
                                : [],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(120, 160),
                            painter: _FaceSilhouettePainter(
                              color: _complete
                                  ? SynapseTokens.auroraTeal
                                  : SynapseTokens.electricBlue,
                              opacity: _scanning ? 0.5 : 0.2,
                            ),
                          ),
                          if (_scanning)
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: _scanController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: _ScanLinePainter(
                                      progress: _scanController.value,
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (_scanning)
                            ...List.generate(20, (i) {
                              final angle = (i / 20) * 2 * pi;
                              final dist = 100.0 + _scanController.value * 40;
                              return Positioned(
                                left: 100 + cos(angle) * dist - 2,
                                top: 120 + sin(angle) * dist - 2,
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: SynapseTokens.electricBlue.withOpacity(
                                      (0.6 - _scanController.value * 0.4).clamp(0.0, 1.0),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Status text
                  AnimatedSwitcher(
                    duration: SynapseTokens.durationFast,
                    child: _complete
                        ? Column(
                            key: const ValueKey('complete'),
                            children: [
                              Text(
                                'Access Granted',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: SynapseTokens.auroraTeal,
                                  letterSpacing: 1,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Welcome back',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: SynapseTokens.textTertiary,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          )
                        : _scanning
                            ? Column(
                                key: const ValueKey('scanning'),
                                children: [
                                  Text(
                                    'Scanning',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: SynapseTokens.electricBlue.withOpacity(0.9),
                                      letterSpacing: 2,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    width: 200,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1),
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: _scanController.value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(1),
                                          gradient: const LinearGradient(
                                            colors: [SynapseTokens.electricBlue, SynapseTokens.auroraTeal],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                key: const ValueKey('idle'),
                                children: [
                                  Text(
                                    'Identity Required',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.7),
                                      letterSpacing: 1,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to scan',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: SynapseTokens.textTertiary,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                  ),

                  const SizedBox(height: 60),

                  // Switch to PIN
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          transitionDuration: SynapseTokens.durationNormal,
                          pageBuilder: (_, __, ___) => const SpatialPinScreen(),
                          transitionsBuilder: (_, animation, __, child) =>
                              FadeTransition(opacity: animation, child: child),
                        ),
                      );
                    },
                    child: Text(
                      'Use PIN instead',
                      style: TextStyle(
                        fontSize: 12,
                        color: SynapseTokens.textTertiary.withOpacity(0.6),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Switch to Voice
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          transitionDuration: SynapseTokens.durationNormal,
                          pageBuilder: (_, __, ___) => const VoiceAuthScreen(),
                          transitionsBuilder: (_, animation, __, child) =>
                              FadeTransition(opacity: animation, child: child),
                        ),
                      );
                    },
                    child: Text(
                      'Use Voice instead',
                      style: TextStyle(
                        fontSize: 12,
                        color: SynapseTokens.textTertiary.withOpacity(0.6),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FaceSilhouettePainter extends CustomPainter {
  final Color color;
  final double opacity;

  _FaceSilhouettePainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.35;

    canvas.drawCircle(Offset(center.dx, center.dy - r * 0.3), r * 0.6, paint);

    final path = Path()
      ..moveTo(center.dx - r * 0.8, center.dy + r * 0.3)
      ..quadraticBezierTo(center.dx - r * 0.4, center.dy + r * 0.1, center.dx, center.dy + r * 0.1)
      ..quadraticBezierTo(center.dx + r * 0.4, center.dy + r * 0.1, center.dx + r * 0.8, center.dy + r * 0.3);
    canvas.drawPath(path, paint);

    canvas.drawCircle(Offset(center.dx - r * 0.2, center.dy - r * 0.35), 2.0, Paint()..color = color.withOpacity(opacity * 1.5)..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(center.dx + r * 0.2, center.dy - r * 0.35), 2.0, Paint()..color = color.withOpacity(opacity * 1.5)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _FaceSilhouettePainter oldDelegate) => true;
}

class _ScanLinePainter extends CustomPainter {
  final double progress;

  _ScanLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          SynapseTokens.electricBlue.withOpacity(0.6),
          SynapseTokens.electricBlue.withOpacity(0.8),
          SynapseTokens.electricBlue.withOpacity(0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, y - 20, size.width, 40));

    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) => true;
}