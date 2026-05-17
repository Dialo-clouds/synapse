import 'package:flutter/material.dart';
import '../../core/tokens/synapse_tokens.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: SynapseTokens.neuralPink.withOpacity(0.3), width: 2),
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(30, 30),
                  painter: _ErrorIconPainter(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: SynapseTokens.textTertiary, height: 1.4, decoration: TextDecoration.none),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: SynapseTokens.electricBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: SynapseTokens.electricBlue.withOpacity(0.3)),
                ),
                child: const Text('Try Again', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: SynapseTokens.electricBlue, decoration: TextDecoration.none)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SynapseTokens.neuralPink.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.35, paint);
    canvas.drawLine(
      Offset(center.dx, center.dy - size.height * 0.15),
      Offset(center.dx, center.dy + size.height * 0.1),
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy + size.height * 0.25),
      size.width * 0.05,
      Paint()..color = SynapseTokens.neuralPink.withOpacity(0.7)..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _ErrorIconPainter oldDelegate) => false;
}