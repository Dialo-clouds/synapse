import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/tokens/synapse_tokens.dart';

class EnergyParticleStreams extends StatefulWidget {
  final double energyLevel;
  final Widget child;

  const EnergyParticleStreams({
    super.key,
    this.energyLevel = 0.5,
    required this.child,
  });

  @override
  State<EnergyParticleStreams> createState() => _EnergyParticleStreamsState();
}

class _EnergyParticleStreamsState extends State<EnergyParticleStreams>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final List<_StreamParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    for (int i = 0; i < 60; i++) {
      _particles.add(_StreamParticle(
        startX: _random.nextDouble(),
        speed: 0.4 + _random.nextDouble() * 0.8,
        size: 1.5 + _random.nextDouble() * 3.0,
        opacity: 0.2 + _random.nextDouble() * 0.5,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getEnergyColor(double level) {
    if (level < 0.4) return SynapseTokens.auroraTeal;
    if (level < 0.7) return SynapseTokens.plasmaAmber;
    return SynapseTokens.neuralPink;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _StreamPainter(
                particles: _particles,
                progress: _controller.value,
                color: _getEnergyColor(widget.energyLevel),
                intensity: widget.energyLevel,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _StreamParticle {
  final double startX;
  final double speed;
  final double size;
  final double opacity;

  _StreamParticle({
    required this.startX,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class _StreamPainter extends CustomPainter {
  final List<_StreamParticle> particles;
  final double progress;
  final Color color;
  final double intensity;

  _StreamPainter({
    required this.particles,
    required this.progress,
    required this.color,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (final p in particles) {
      final y = (progress * p.speed) % 1.0;
      final x = p.startX + sin(y * 10 + progress * 5) * 0.15 * intensity;

      final alpha = (p.opacity * (1.0 - y) * intensity * 2).clamp(0.0, 1.0);

      // Main particle
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.size,
        Paint()
          ..color = color.withOpacity(alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Trail
      for (int i = 1; i <= 3; i++) {
        final trailY = y - (i * 0.02);
        if (trailY < 0) continue;
        final trailX = x + sin(trailY * 10 + progress * 5) * 0.1 * intensity;

        canvas.drawCircle(
          Offset(trailX * size.width, trailY * size.height),
          p.size * (1.0 - i * 0.25),
          Paint()
            ..color = color.withOpacity(alpha * (1.0 - i * 0.3))
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StreamPainter oldDelegate) => true;
}