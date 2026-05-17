import 'package:flutter/material.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../shared/widgets/glass_container.dart';

class GlassPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback? onClose;
  final bool showGlow;

  const GlassPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.onClose,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      opacity: 0.06,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: SynapseTokens.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: SynapseTokens.textTertiary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                if (onClose != null)
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(12, 12),
                          painter: _CloseIconPainter(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: child,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _CloseIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CloseIconPainter oldDelegate) => false;
}