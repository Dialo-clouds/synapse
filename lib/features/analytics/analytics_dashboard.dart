import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard>
    with TickerProviderStateMixin {
  
  late AnimationController _chartController;
  final Random _random = Random();

  final List<double> _weeklyUsage = [18, 22, 15, 28, 20, 25, 19];
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  
  final Map<String, double> _deviceBreakdown = {
    'Lighting': 35,
    'Climate': 28,
    'Entertainment': 18,
    'Appliances': 12,
    'Other': 7,
  };

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _chartController,
          builder: (context, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: const Center(child: Icon(Icons.arrow_back, color: SynapseTokens.textSecondary, size: 20)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Analytics',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Weekly Usage Bar Chart
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('WEEKLY ENERGY USAGE', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 180,
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _BarChartPainter(data: _weeklyUsage, labels: _days, progress: _chartController.value),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Device Breakdown Pie
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('DEVICE BREAKDOWN', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _PieChartPainter(data: _deviceBreakdown, progress: _chartController.value),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Quick Stats
                  Row(
                    children: [
                      Expanded(child: _AnalyticsStat(label: 'Total Devices', value: '18', change: '+2', positive: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _AnalyticsStat(label: 'Avg Usage', value: '21 kWh', change: '-8%', positive: true)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _AnalyticsStat(label: 'Efficiency', value: '78%', change: '+12%', positive: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _AnalyticsStat(label: 'Savings', value: '\$34', change: '+5%', positive: true)),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnalyticsStat extends StatelessWidget {
  final String label, value, change;
  final bool positive;

  const _AnalyticsStat({required this.label, required this.value, required this.change, required this.positive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
              const SizedBox(width: 6),
              Text(change, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: positive ? SynapseTokens.auroraTeal : SynapseTokens.neuralPink)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double progress;

  _BarChartPainter({required this.data, required this.labels, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || size.isEmpty) return;
    final maxVal = data.reduce(max).clamp(1.0, 1000.0);
    final barWidth = (size.width / data.length) * 0.6;
    final spacing = size.width / data.length;

    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxVal) * (size.height - 30) * progress;
      final x = i * spacing + (spacing - barWidth) / 2;
      final y = size.height - barHeight - 20;

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [SynapseTokens.electricBlue, SynapseTokens.primaryViolet.withOpacity(0.3)],
      );

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          topLeft: const Radius.circular(6),
          topRight: const Radius.circular(6),
        ),
        Paint()..shader = gradient.createShader(Rect.fromLTWH(x, y, barWidth, barHeight)),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(fontSize: 9, color: SynapseTokens.textTertiary),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x + barWidth / 2 - textPainter.width / 2, size.height - 16));
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) => true;
}

class _PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final double progress;

  _PieChartPainter({required this.data, required this.progress});

  static const List<Color> _colors = [
    SynapseTokens.electricBlue,
    SynapseTokens.auroraTeal,
    SynapseTokens.plasmaAmber,
    SynapseTokens.neuralPink,
    SynapseTokens.primaryViolet,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || size.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.35;
    final total = data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return;

    double startAngle = -pi / 2;
    int colorIndex = 0;

    for (var entry in data.entries) {
      final sweepAngle = (entry.value / total) * 2 * pi * progress;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        Paint()..color = _colors[colorIndex % _colors.length],
      );

      final midAngle = startAngle + sweepAngle / 2;
      final labelX = center.dx + cos(midAngle) * radius * 1.3;
      final labelY = center.dy + sin(midAngle) * radius * 1.3;

      if (progress > 0.5) {
        final label = TextPainter(
          text: TextSpan(
            text: '${entry.key}\n${entry.value.toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 9, color: SynapseTokens.textSecondary, height: 1.3),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout();
        label.paint(canvas, Offset(labelX - label.width / 2, labelY - label.height / 2));
      }

      startAngle += sweepAngle;
      colorIndex++;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) => true;
}