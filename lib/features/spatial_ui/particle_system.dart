import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/tokens/synapse_tokens.dart';

class ParticleSystem extends StatefulWidget {
  final Widget child;
  final int count;
  final Color color;
  final double speed;
  final double spread;

  const ParticleSystem({
    super.key,
    required this.child,
    this.count = 40,
    this.color = SynapseTokens.electricBlue,
    this.speed = 1.0,
    this.spread = 1.0,
  });

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    for (int i = 0; i < widget.count; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: 1.0 + _random.nextDouble() * 4.0,
        speed: 0.3 + _random.nextDouble() * widget.speed,
        angle: _random.nextDouble() * 2 * pi,
        orbitRadius: 0.05 + _random.nextDouble() * widget.spread,
        opacity: 0.2 + _random.nextDouble() * 0.6,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              painter: _ParticlePainter(
                particles: _particles,
                progress: _controller.value,
                color: widget.color,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _Particle {
  double x, y;
  final double size;
  final double speed;
  final double angle;
  final double orbitRadius;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
    required this.orbitRadius,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y + progress * p.speed) % 1.0;
      final x = (p.x + sin(progress * 3 + p.angle) * p.orbitRadius).clamp(0.0, 1.0);
      final alpha = (p.opacity * (1.0 - y) * 0.8 + 0.2).clamp(0.0, 1.0);

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.size * (0.5 + (1.0 - y) * 0.5),
        Paint()
          ..color = color.withOpacity(alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}