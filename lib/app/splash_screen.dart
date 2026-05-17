import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/tokens/synapse_tokens.dart';
import '../features/auth/biometric_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _neuralController;
  late AnimationController _revealController;
  
  @override
  void initState() {
    super.initState();
    
    _neuralController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _revealController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: SynapseTokens.durationSlow,
            pageBuilder: (_, __, ___) => const BiometricScreen(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    });
  }
  
  @override
  void dispose() {
    _neuralController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000008), Color(0xFF0A0020), Color(0xFF000008)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background particles
            CustomPaint(
              size: Size.infinite,
              painter: _BackgroundParticlesPainter(progress: _neuralController.value),
            ),
            
            // Center logo
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_neuralController, _revealController]),
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(300, 300),
                        painter: _NeuralLogoPainter(
                          progress: _neuralController.value,
                          reveal: _revealController.value,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Opacity(
                        opacity: _revealController.value.clamp(0.0, 1.0),
                        child: Column(
                          children: [
                            Text(
                              'SYNAPSE',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w200,
                                color: SynapseTokens.electricBlue.withOpacity(0.9),
                                letterSpacing: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'SPATIAL INTELLIGENCE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: SynapseTokens.primaryViolet.withOpacity(0.7),
                                letterSpacing: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeuralLogoPainter extends CustomPainter {
  final double progress;
  final double reveal;
  
  _NeuralLogoPainter({required this.progress, required this.reveal});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.35 * reveal;
    
    // Outer glow
    final glowShader = RadialGradient(
      colors: [
        SynapseTokens.electricBlue.withOpacity((0.4 * reveal).clamp(0.0, 1.0)),
        SynapseTokens.primaryViolet.withOpacity((0.15 * reveal).clamp(0.0, 1.0)),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: center, radius: r * 2));
    canvas.drawCircle(center, r * 2, Paint()..shader = glowShader);
    
    // Neural network nodes
    final nodePaint = Paint()
      ..color = SynapseTokens.electricBlue.withOpacity((0.8 * reveal).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    final nodes = 12;
    final nodePositions = <Offset>[];
    
    for (int i = 0; i < nodes; i++) {
      final angle = (i / nodes) * 2 * pi + progress * pi;
      final nodeR = r * (0.3 + 0.4 * sin(angle * 3 + progress * 2));
      final x = center.dx + cos(angle) * nodeR;
      final y = center.dy + sin(angle) * nodeR;
      nodePositions.add(Offset(x, y));
      canvas.drawCircle(Offset(x, y), 3.0, nodePaint);
    }
    
    // Connecting lines between nodes
    final linePaint = Paint()
      ..color = SynapseTokens.primaryViolet.withOpacity((0.3 * reveal).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    for (int i = 0; i < nodePositions.length; i++) {
      for (int j = i + 1; j < nodePositions.length; j++) {
        if ((i + j) % 3 == 0) {
          canvas.drawLine(nodePositions[i], nodePositions[j], linePaint);
        }
      }
    }
    
    // Orbiting ring
    final ringPaint = Paint()
      ..color = SynapseTokens.auroraTeal.withOpacity((0.3 * reveal).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, r * 0.8, ringPaint);
    
    // Center bright dot
    canvas.drawCircle(
      center,
      4.0 * reveal,
      Paint()
        ..color = Colors.white
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(center, 2.0 * reveal, Paint()..color = Colors.white);
  }
  
  @override
  bool shouldRepaint(covariant _NeuralLogoPainter oldDelegate) => true;
}

class _BackgroundParticlesPainter extends CustomPainter {
  final double progress;
  
  _BackgroundParticlesPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    
    // Blue particles
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress * 0.3) % 1.0 * size.height;
      final alpha = (0.15 + 0.3 * sin(progress * 5 + i)).clamp(0.0, 1.0);
      
      canvas.drawCircle(
        Offset(x, y),
        1.5 + random.nextDouble() * 2.5,
        Paint()
          ..color = SynapseTokens.electricBlue.withOpacity(alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
    
    // Brighter teal accent particles
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress * 0.5) % 1.0 * size.height;
      
      canvas.drawCircle(
        Offset(x, y),
        1.0 + random.nextDouble() * 2.0,
        Paint()
          ..color = SynapseTokens.auroraTeal.withOpacity((0.5 + 0.3 * sin(progress * 8 + i)).clamp(0.0, 1.0))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant _BackgroundParticlesPainter oldDelegate) => true;
}