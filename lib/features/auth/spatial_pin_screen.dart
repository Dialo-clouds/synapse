import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../app/home_shell.dart';

class SpatialPinScreen extends StatefulWidget {
  const SpatialPinScreen({super.key});

  @override
  State<SpatialPinScreen> createState() => _SpatialPinScreenState();
}

class _SpatialPinScreenState extends State<SpatialPinScreen>
    with TickerProviderStateMixin {
  
  final List<int> _enteredPin = [];
  final List<int> _correctPin = [2, 7, 4, 1];
  bool _showError = false;
  bool _unlocked = false;
  
  late AnimationController _orbitController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  void _onNumberPressed(int number) {
    if (_unlocked || _showError) return;
    
    setState(() {
      _enteredPin.add(number);
      
      if (_enteredPin.length == 4) {
        if (_enteredPin.toString() == _correctPin.toString()) {
          _unlocked = true;
          Future.delayed(const Duration(milliseconds: 600), () {
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
        } else {
          _showError = true;
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _enteredPin.clear();
                _showError = false;
              });
            }
          });
        }
      }
    });
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() => _enteredPin.removeLast());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _orbitController,
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spatial orb
                  CustomPaint(
                    size: const Size(160, 160),
                    painter: _SpatialOrbPainter(
                      progress: _orbitController.value,
                      enteredCount: _enteredPin.length,
                      showError: _showError,
                      unlocked: _unlocked,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    _unlocked ? 'Unlocked' : 'Spatial PIN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: _unlocked
                          ? SynapseTokens.auroraTeal
                          : _showError
                              ? SynapseTokens.neuralPink
                              : Colors.white.withOpacity(0.8),
                      letterSpacing: 1,
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _showError
                        ? 'Incorrect pattern'
                        : 'Enter your spatial sequence',
                    style: TextStyle(
                      fontSize: 13,
                      color: _showError
                          ? SynapseTokens.neuralPink.withOpacity(0.7)
                          : SynapseTokens.textTertiary,
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // PIN dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      final filled = i < _enteredPin.length;
                      return AnimatedContainer(
                        duration: SynapseTokens.durationFast,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _showError
                              ? SynapseTokens.neuralPink.withOpacity(0.6)
                              : _unlocked
                                  ? SynapseTokens.auroraTeal.withOpacity(0.8)
                                  : filled
                                      ? SynapseTokens.electricBlue.withOpacity(0.8)
                                      : Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: _showError
                                ? SynapseTokens.neuralPink.withOpacity(0.4)
                                : _unlocked
                                    ? SynapseTokens.auroraTeal.withOpacity(0.4)
                                    : filled
                                        ? SynapseTokens.electricBlue.withOpacity(0.4)
                                        : Colors.white.withOpacity(0.15),
                          ),
                          boxShadow: filled
                              ? [
                                  BoxShadow(
                                    color: (_showError
                                            ? SynapseTokens.neuralPink
                                            : _unlocked
                                                ? SynapseTokens.auroraTeal
                                                : SynapseTokens.electricBlue)
                                        .withOpacity(0.4),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 40),

                  // Number pad
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NumberButton(number: 1, onTap: () => _onNumberPressed(1)),
                          const SizedBox(width: 20),
                          _NumberButton(number: 2, onTap: () => _onNumberPressed(2)),
                          const SizedBox(width: 20),
                          _NumberButton(number: 3, onTap: () => _onNumberPressed(3)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NumberButton(number: 4, onTap: () => _onNumberPressed(4)),
                          const SizedBox(width: 20),
                          _NumberButton(number: 5, onTap: () => _onNumberPressed(5)),
                          const SizedBox(width: 20),
                          _NumberButton(number: 6, onTap: () => _onNumberPressed(6)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NumberButton(number: 7, onTap: () => _onNumberPressed(7)),
                          const SizedBox(width: 20),
                          _NumberButton(number: 8, onTap: () => _onNumberPressed(8)),
                          const SizedBox(width: 20),
                          _NumberButton(number: 9, onTap: () => _onNumberPressed(9)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 64),
                          _NumberButton(number: 0, onTap: () => _onNumberPressed(0)),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: _onDelete,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'DEL',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: SynapseTokens.textTertiary,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _NumberButton extends StatelessWidget {
  final int number;
  final VoidCallback onTap;

  const _NumberButton({required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: SynapseTokens.durationFast,
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpatialOrbPainter extends CustomPainter {
  final double progress;
  final int enteredCount;
  final bool showError;
  final bool unlocked;

  _SpatialOrbPainter({
    required this.progress,
    required this.enteredCount,
    required this.showError,
    required this.unlocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.35;

    final color = unlocked
        ? SynapseTokens.auroraTeal
        : showError
            ? SynapseTokens.neuralPink
            : SynapseTokens.electricBlue;

    // Outer glow
    final glowShader = RadialGradient(
      colors: [
        color.withOpacity(0.3),
        color.withOpacity(0.05),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: center, radius: r * 1.5));
    canvas.drawCircle(center, r * 1.5, Paint()..shader = glowShader);

    // Rings
    for (int i = 0; i < 4; i++) {
      final ringOpacity = i < enteredCount ? 0.4 : 0.08;
      canvas.drawCircle(
        center,
        r * (0.4 + i * 0.2),
        Paint()
          ..color = color.withOpacity(ringOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Orbiting nodes
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi + progress * pi;
      final dist = r * (0.7 + 0.3 * sin(angle * 2 + progress));
      final x = center.dx + cos(angle) * dist;
      final y = center.dy + sin(angle) * dist;

      final nodeOpacity = i < enteredCount * 2 ? 0.8 : 0.2;
      canvas.drawCircle(
        Offset(x, y),
        2.5,
        Paint()
          ..color = color.withOpacity(nodeOpacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }

    // Center
    canvas.drawCircle(center, 3.0, Paint()..color = Colors.white.withOpacity(0.8)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawCircle(center, 1.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _SpatialOrbPainter oldDelegate) => true;
}