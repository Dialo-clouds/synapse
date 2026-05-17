import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../core/services/pocketbase_service.dart';
import '../../shared/services/haptic_service.dart';
import '../object_detection/detection_service.dart';
import '../auth/biometric_screen.dart';
import 'room_selector.dart';
import '../gestures/quick_actions.dart';
import '../../shared/models/room.dart';

class ARView extends StatefulWidget {
  const ARView({super.key});

  @override
  State<ARView> createState() => _ARViewState();
}

class _ARViewState extends State<ARView> with TickerProviderStateMixin {
  bool _isScanning = true;
  DetectedObject? _detectedObject;
  int _objectIndex = 0;
  final Random _random = Random();
  
  bool _deviceOn = true;
  double _deviceValue = 0.7;
  String _currentRoom = 'living';

  late AnimationController _scanController;
  late AnimationController _orbitController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _orbitController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _startScanningSequence();
  }

  void _startScanningSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _scanController.forward();
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) _detectNewObject();
  }

  void _detectNewObject() {
    final obj = DetectionService.getObjectAt(_objectIndex);
    setState(() {
      _detectedObject = obj;
      _isScanning = false;
      _objectIndex++;
      _deviceOn = true;
      _deviceValue = 0.5 + _random.nextDouble() * 0.5;
    });
  }

  void _cycleObject() {
    HapticService.scan();
    _detectNewObject();
  }

  void _onRoomChanged(SmartRoom room) {
    setState(() => _currentRoom = room.id);
    _detectNewObject();
  }

  void _saveDeviceState() async {
    if (_detectedObject == null) return;
    
    try {
      await PocketBaseService.saveDevice({
        'name': _detectedObject!.name,
        'type': _detectedObject!.type,
        'is_on': _deviceOn,
      });
      
      await PocketBaseService.saveInteraction({
        'device_name': _detectedObject!.name,
        'action': _deviceOn ? 'Turned ON' : 'Turned OFF',
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _scanController.dispose();
    _orbitController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color _getDeviceColor(String type) {
    switch (type) {
      case 'light': return SynapseTokens.plasmaAmber;
      case 'climate': return SynapseTokens.auroraTeal;
      case 'entertainment': return SynapseTokens.electricBlue;
      case 'music': return SynapseTokens.neuralPink;
      case 'lock': return SynapseTokens.electricBlue;
      case 'appliance': return SynapseTokens.plasmaAmber;
      case 'blinds': return SynapseTokens.auroraTeal;
      default: return SynapseTokens.primaryViolet;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_orbitController, _pulseController, _scanController]),
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Color(0xFF0A0020),
                Color(0xFF000008),
              ],
            ),
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: _AmbientFieldPainter(
                  progress: _orbitController.value,
                  pulse: _pulseController.value,
                  isActive: !_isScanning,
                ),
              ),

              if (_isScanning) _buildScanningState(),
              if (!_isScanning && _detectedObject != null) _buildActiveState(),

              // Top bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'SYNAPSE',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: SynapseTokens.electricBlue.withOpacity(0.7),
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: SynapseTokens.durationNormal,
                                  pageBuilder: (_, __, ___) => const BiometricScreen(),
                                  transitionsBuilder: (_, animation, __, child) =>
                                      FadeTransition(opacity: animation, child: child),
                                ),
                              );
                            },
                            child: Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Center(
                                child: Container(
                                  width: 10, height: 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 4, height: 4,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5, height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isScanning ? SynapseTokens.auroraTeal : SynapseTokens.electricBlue,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isScanning ? SynapseTokens.auroraTeal : SynapseTokens.electricBlue).withOpacity(0.6),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isScanning ? 'SCANNING' : 'CONNECTED',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: (_isScanning ? SynapseTokens.auroraTeal : SynapseTokens.electricBlue).withOpacity(0.8),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScanningState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: _ScanRingsPainter(progress: _scanController.value, pulse: _pulseController.value),
          ),
          const SizedBox(height: 32),
          Text(
            'Point your camera at any object',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
              letterSpacing: 1,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Synapse will identify and connect',
            style: TextStyle(
              fontSize: 11,
              color: SynapseTokens.textTertiary.withOpacity(0.5),
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 24),
          RoomSelector(
            selectedRoom: _currentRoom,
            onRoomSelected: _onRoomChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveState() {
    final obj = _detectedObject!;
    final color = _getDeviceColor(obj.type);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTap: _cycleObject,
            child: CustomPaint(
              size: Size(screenWidth * 0.7, screenWidth * 0.7),
              painter: _HolographicOrbPainter(
                color: color,
                orbitProgress: _orbitController.value,
                pulse: _pulseController.value,
                deviceType: obj.type,
              ),
            ),
          ),
        ),

        Positioned(
          top: screenHeight * 0.18,
          left: 0, right: 0,
          child: Column(
            children: [
              Text(
                obj.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${obj.type.toUpperCase()} \u2022 ${(obj.confidence * 100).round()}% MATCH',
                style: TextStyle(
                  fontSize: 10,
                  color: color.withOpacity(0.7),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: screenHeight * 0.38,
          left: 20, right: 20,
          child: const QuickActionsPanel(),
        ),

        Positioned(
          bottom: 40, left: 24, right: 24,
          child: _buildControlDock(color),
        ),

        Positioned(
          bottom: 16, left: 0, right: 0,
          child: Center(
            child: Text(
              'TAP ORB TO SCAN NEXT',
              style: TextStyle(
                fontSize: 9,
                color: Colors.white.withOpacity(0.25),
                letterSpacing: 2,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlDock(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 40, spreadRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _deviceOn ? color : Colors.white.withOpacity(0.2),
                          boxShadow: _deviceOn ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)] : [],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _deviceOn ? 'ACTIVE' : 'STANDBY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _deviceOn ? color : Colors.white.withOpacity(0.3),
                      letterSpacing: 1.5,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _deviceOn = !_deviceOn);
                  HapticService.toggle(_deviceOn);
                  _saveDeviceState();
                },
                child: AnimatedContainer(
                  duration: SynapseTokens.durationFast,
                  width: 52, height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: _deviceOn ? color.withOpacity(0.3) : Colors.white.withOpacity(0.05),
                    border: Border.all(color: _deviceOn ? color.withOpacity(0.5) : Colors.white.withOpacity(0.08)),
                    boxShadow: _deviceOn ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12)] : [],
                  ),
                  child: AnimatedAlign(
                    duration: SynapseTokens.durationFast,
                    alignment: _deviceOn ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 24, height: 24,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (_deviceOn) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    '${(_deviceValue * 100).round()}%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color, decoration: TextDecoration.none),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final maxWidth = box.size.width - 56;
                      final newVal = (_deviceValue + details.delta.dx / maxWidth).clamp(0.0, 1.0);
                      setState(() => _deviceValue = newVal);
                    },
                    child: Container(
                      height: 24,
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.white.withOpacity(0.06),
                          ),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                widthFactor: _deviceValue,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    gradient: LinearGradient(colors: [color, color.withOpacity(0.4)]),
                                    boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment(_deviceValue * 2 - 1, 0),
                                child: Container(
                                  width: 14, height: 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6)],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================
// AMBIENT FIELD PAINTER
// ============================================
class _AmbientFieldPainter extends CustomPainter {
  final double progress;
  final double pulse;
  final bool isActive;

  _AmbientFieldPainter({required this.progress, required this.pulse, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final random = Random(42);
    final particleCount = isActive ? 80 : 40;

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * pi + progress * 0.5;
      final dist = size.width * (0.3 + 0.5 * sin(angle * 2 + progress));
      final x = center.dx + cos(angle) * dist;
      final y = center.dy + sin(angle * 0.7) * dist * 0.6;
      final alpha = (0.08 + 0.15 * sin(progress * 3 + i)).clamp(0.0, 1.0);

      canvas.drawCircle(
        Offset(x, y),
        1.0 + random.nextDouble() * 2.0,
        Paint()
          ..color = SynapseTokens.electricBlue.withOpacity(alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }

    if (isActive) {
      final glowShader = RadialGradient(
        colors: [
          SynapseTokens.primaryViolet.withOpacity((0.08 * pulse).clamp(0.0, 1.0)),
          SynapseTokens.electricBlue.withOpacity((0.04 * pulse).clamp(0.0, 1.0)),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.5));
      canvas.drawCircle(center, size.width * 0.5, Paint()..shader = glowShader);
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientFieldPainter oldDelegate) => true;
}

// ============================================
// SCAN RINGS PAINTER
// ============================================
class _ScanRingsPainter extends CustomPainter {
  final double progress;
  final double pulse;

  _ScanRingsPainter({required this.progress, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      final ringProgress = (progress + i * 0.3) % 1.0;
      final radius = size.width * 0.2 + ringProgress * size.width * 0.25;
      final alpha = ((1.0 - ringProgress) * 0.4).clamp(0.0, 1.0);

      canvas.drawCircle(
        center, radius,
        Paint()
          ..color = SynapseTokens.electricBlue.withOpacity(alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 - i * 0.3,
      );
    }

    canvas.drawCircle(center, 3.0, Paint()..color = SynapseTokens.electricBlue.withOpacity(0.8)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawCircle(center, 1.5, Paint()..color = Colors.white);

    final crossPaint = Paint()..color = Colors.white.withOpacity(0.15)..strokeWidth = 0.5;
    final crossSize = size.width * 0.08;
    canvas.drawLine(Offset(center.dx - crossSize, center.dy), Offset(center.dx + crossSize, center.dy), crossPaint);
    canvas.drawLine(Offset(center.dx, center.dy - crossSize), Offset(center.dx, center.dy + crossSize), crossPaint);
  }

  @override
  bool shouldRepaint(covariant _ScanRingsPainter oldDelegate) => true;
}

// ============================================
// HOLOGRAPHIC ORB PAINTER
// ============================================
class _HolographicOrbPainter extends CustomPainter {
  final Color color;
  final double orbitProgress;
  final double pulse;
  final String deviceType;

  _HolographicOrbPainter({required this.color, required this.orbitProgress, required this.pulse, required this.deviceType});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.3;
    final radius = baseRadius * (0.95 + pulse * 0.05);

    final glowShader = RadialGradient(
      colors: [color.withOpacity(0.2), color.withOpacity(0.05), Colors.transparent],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius * 2));
    canvas.drawCircle(center, radius * 2, Paint()..shader = glowShader);

    for (int i = 0; i < 30; i++) {
      final angle = (i / 30) * 2 * pi + orbitProgress * pi;
      final dist = radius * 1.3;
      final x = center.dx + cos(angle) * dist;
      final y = center.dy + sin(angle) * dist * 0.5;
      final alpha = (0.3 + 0.3 * sin(angle * 3 + orbitProgress * 4)).clamp(0.0, 1.0);
      canvas.drawCircle(Offset(x, y), 1.5 + sin(angle + orbitProgress) * 1.0, Paint()..color = color.withOpacity(alpha)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    }

    for (int i = 0; i < 4; i++) {
      final ringRadius = radius * (0.4 + i * 0.2);
      canvas.drawCircle(center, ringRadius, Paint()..color = color.withOpacity(0.15 - i * 0.03)..style = PaintingStyle.stroke..strokeWidth = 1.0 + i * 0.3);
    }

    final arcPaint = Paint()..color = color.withOpacity(0.2)..style = PaintingStyle.stroke..strokeWidth = 1.0;
    for (int i = 0; i < 3; i++) {
      final rotation = i * pi / 2 + orbitProgress;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: radius * 0.85), -pi / 3, 2 * pi / 3, false, arcPaint);
      canvas.restore();
    }

    canvas.drawCircle(center, radius * 0.3, Paint()..color = color.withOpacity(0.1)..style = PaintingStyle.fill);
    canvas.drawCircle(center, radius * 0.3, Paint()..color = color.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    canvas.drawCircle(center, 3.0, Paint()..color = Colors.white.withOpacity(0.9)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawCircle(center, 1.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _HolographicOrbPainter oldDelegate) => true;
}