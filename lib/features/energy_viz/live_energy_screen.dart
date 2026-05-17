import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../shared/services/energy_tracker.dart';
import 'energy_forecast.dart';

class LiveEnergyScreen extends StatefulWidget {
  const LiveEnergyScreen({super.key});

  @override
  State<LiveEnergyScreen> createState() => _LiveEnergyScreenState();
}

class _LiveEnergyScreenState extends State<LiveEnergyScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _flowController;
  late AnimationController _dataController;
  
  double _currentUsage = 3.2;
  double _solarInput = 4.1;
  double _batteryLevel = 72;
  List<double> _historyData = [2.1, 3.4, 2.8, 4.2, 3.9, 5.1, 3.2];
  List<double> _solarData = [1.2, 2.1, 3.4, 4.2, 3.8, 2.9, 4.1];
  
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    _flowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    _dataController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _dataController.addListener(() {
      if (_dataController.value > 0.95) {
        _updateData();
      }
    });
  }

  void _updateData() {
    setState(() {
      _currentUsage = EnergyTracker.currentUsage;
      _solarInput = EnergyTracker.solarProduction;
      _batteryLevel = EnergyTracker.batteryLevel;
      
      _historyData.add(_currentUsage);
      _solarData.add(_solarInput);
      if (_historyData.length > 24) _historyData.removeAt(0);
      if (_solarData.length > 24) _solarData.removeAt(0);
    });
    EnergyTracker.saveEnergySnapshot();
  }

  Future<void> _onRefresh() async {
    _updateData();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _flowController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: SynapseTokens.electricBlue,
          backgroundColor: const Color(0xFF000008),
          child: AnimatedBuilder(
            animation: Listenable.merge([_flowController, _dataController]),
            builder: (context, child) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Live Energy',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, letterSpacing: -0.5, decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 4),
                    Text('Real-time consumption monitoring', style: TextStyle(fontSize: 14, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),

                    const SizedBox(height: 24),

                    // Live Flow Orb
                    Center(
                      child: CustomPaint(
                        size: const Size(220, 220),
                        painter: _LiveFlowPainter(
                          usage: _currentUsage / 10,
                          solar: _solarInput / 10,
                          battery: _batteryLevel / 100,
                          progress: _flowController.value,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '${_currentUsage.toStringAsFixed(1)} kW',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w200, color: Colors.white, letterSpacing: 2, decoration: TextDecoration.none),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quick stats
                    Row(
                      children: [
                        Expanded(child: _StatCard(label: 'SOLAR', value: '${_solarInput.toStringAsFixed(1)} kW', color: SynapseTokens.auroraTeal)),
                        const SizedBox(width: 12),
                        Expanded(child: _StatCard(label: 'BATTERY', value: '${_batteryLevel.toStringAsFixed(0)}%', color: SynapseTokens.electricBlue)),
                        const SizedBox(width: 12),
                        Expanded(child: _StatCard(label: 'GRID', value: '${(_currentUsage - _solarInput).toStringAsFixed(1)} kW', color: SynapseTokens.plasmaAmber)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Usage chart
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.06))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('24H USAGE', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            child: CustomPaint(
                              size: Size.infinite,
                              painter: _ChartPainter(data: _historyData, color: SynapseTokens.electricBlue),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Solar chart
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.06))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SOLAR PRODUCTION', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            child: CustomPaint(
                              size: Size.infinite,
                              painter: _ChartPainter(data: _solarData, color: SynapseTokens.auroraTeal),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Energy Forecast
                    const EnergyForecast(),

                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.06))),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color, decoration: TextDecoration.none)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: SynapseTokens.textTertiary, letterSpacing: 1, decoration: TextDecoration.none)),
        ],
      ),
    );
  }
}

class _LiveFlowPainter extends CustomPainter {
  final double usage, solar, battery, progress;
  _LiveFlowPainter({required this.usage, required this.solar, required this.battery, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.35;

    canvas.drawCircle(center, r, Paint()..color = Colors.white.withOpacity(0.05)..style = PaintingStyle.stroke..strokeWidth = 6);
    canvas.drawCircle(center, r - 15, Paint()..color = Colors.white.withOpacity(0.05)..style = PaintingStyle.stroke..strokeWidth = 3);

    canvas.drawArc(Rect.fromCircle(center: center, radius: r), -pi / 2, 2 * pi * usage.clamp(0.0, 1.0), false, Paint()..shader = SweepGradient(colors: [SynapseTokens.plasmaAmber, SynapseTokens.neuralPink]).createShader(Rect.fromCircle(center: center, radius: r))..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round);
    canvas.drawArc(Rect.fromCircle(center: center, radius: r - 15), -pi / 2, 2 * pi * solar.clamp(0.0, 1.0), false, Paint()..color = SynapseTokens.auroraTeal..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round);

    for (int i = 0; i < 25; i++) {
      final angle = (i / 25) * 2 * pi + progress * pi;
      final dist = r * 1.2;
      final x = center.dx + cos(angle) * dist;
      final y = center.dy + sin(angle) * dist * 0.5;
      canvas.drawCircle(Offset(x, y), 1.5, Paint()..color = SynapseTokens.electricBlue.withOpacity((0.3 + 0.3 * sin(angle + progress * 3)).clamp(0.0, 1.0))..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
    }

    canvas.drawCircle(center, 2.0, Paint()..color = Colors.white.withOpacity(0.8)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
  }

  @override
  bool shouldRepaint(covariant _LiveFlowPainter oldDelegate) => true;
}

class _ChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  _ChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || size.isEmpty) return;
    final maxVal = data.reduce(max);
    final minVal = data.reduce(min);
    final range = (maxVal - minVal).clamp(0.1, 100);
    final stepX = size.width / (data.length - 1).clamp(1, 100);

    final fillPath = Path()..moveTo(0, size.height);
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - ((data[i] - minVal) / range * (size.height - 10) + 5);
      fillPath.lineTo(x, y);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, Paint()..shader = LinearGradient(colors: [color.withOpacity(0.2), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    final linePath = Path();
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - ((data[i] - minVal) / range * (size.height - 10) + 5);
      i == 0 ? linePath.moveTo(x, y) : linePath.lineTo(x, y);
    }
    canvas.drawPath(linePath, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => true;
}