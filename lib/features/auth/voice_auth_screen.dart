import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../app/home_shell.dart';

class VoiceAuthScreen extends StatefulWidget {
  const VoiceAuthScreen({super.key});

  @override
  State<VoiceAuthScreen> createState() => _VoiceAuthScreenState();
}

class _VoiceAuthScreenState extends State<VoiceAuthScreen>
    with TickerProviderStateMixin {
  
  bool _listening = false;
  bool _processing = false;
  bool _complete = false;
  String _displayText = 'Say "Hey Synapse" to unlock';
  double _voiceLevel = 0.0;
  
  late AnimationController _pulseController;
  late AnimationController _waveController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _listening = true;
      _displayText = 'Listening...';
    });
    
    _waveController.repeat();
    
    // Simulate voice detection
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && _listening) {
        setState(() => _voiceLevel = 0.3);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && _listening) {
        setState(() => _voiceLevel = 0.7);
      }
    });
    
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted && _listening) {
        setState(() {
          _listening = false;
          _processing = true;
          _voiceLevel = 1.0;
          _displayText = 'Voice recognized';
        });
        _waveController.stop();
        
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              _processing = false;
              _complete = true;
              _displayText = 'Access Granted';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _waveController]),
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Voice orb
                  GestureDetector(
                    onTap: _listening || _processing ? null : _startListening,
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: _VoiceOrbPainter(
                        pulse: _pulseController.value,
                        waveProgress: _waveController.value,
                        voiceLevel: _voiceLevel,
                        isListening: _listening,
                        isProcessing: _processing,
                        isComplete: _complete,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Status
                  AnimatedSwitcher(
                    duration: SynapseTokens.durationFast,
                    child: Text(
                      _displayText,
                      key: ValueKey(_displayText),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: _complete
                            ? SynapseTokens.auroraTeal
                            : _processing
                                ? SynapseTokens.electricBlue
                                : _listening
                                    ? SynapseTokens.neuralPink.withOpacity(0.8)
                                    : Colors.white.withOpacity(0.7),
                        letterSpacing: 1,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (!_listening && !_processing && !_complete)
                    Text(
                      'Tap the orb to activate',
                      style: TextStyle(
                        fontSize: 13,
                        color: SynapseTokens.textTertiary,
                        decoration: TextDecoration.none,
                      ),
                    ),

                  if (_listening)
                    // Voice level bars
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          final barHeight = (_voiceLevel * (1.0 - i * 0.15) * 30).clamp(3.0, 30.0);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 4,
                            height: barHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  SynapseTokens.electricBlue.withOpacity(0.3),
                                  SynapseTokens.neuralPink.withOpacity(0.8),
                                ],
                              ),
                            ),
                          );
                        }),
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

class _VoiceOrbPainter extends CustomPainter {
  final double pulse;
  final double waveProgress;
  final double voiceLevel;
  final bool isListening;
  final bool isProcessing;
  final bool isComplete;

  _VoiceOrbPainter({
    required this.pulse,
    required this.waveProgress,
    required this.voiceLevel,
    required this.isListening,
    required this.isProcessing,
    required this.isComplete,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.35;

    Color activeColor;
    if (isComplete) {
      activeColor = SynapseTokens.auroraTeal;
    } else if (isProcessing) {
      activeColor = SynapseTokens.electricBlue;
    } else if (isListening) {
      activeColor = SynapseTokens.neuralPink;
    } else {
      activeColor = SynapseTokens.primaryViolet;
    }

    // Outer glow
    final glowRadius = r * 1.5 + voiceLevel * r * 0.5;
    final glowShader = RadialGradient(
      colors: [
        activeColor.withOpacity(0.3),
        activeColor.withOpacity(0.05),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
    canvas.drawCircle(center, glowRadius, Paint()..shader = glowShader);

    // Main orb
    final orbShader = RadialGradient(
      colors: [
        activeColor.withOpacity(0.2),
        activeColor.withOpacity(0.05),
        const Color(0xFF000008).withOpacity(0.8),
      ],
    ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, Paint()..shader = orbShader);

    // Orb border
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = activeColor.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Sound waves when listening
    if (isListening || isProcessing) {
      for (int i = 0; i < 4; i++) {
        final waveRadius = r * (1.2 + i * 0.3 + voiceLevel * 0.4);
        final waveAlpha = ((1.0 - waveProgress * 0.3) * (1.0 - i * 0.2) * voiceLevel).clamp(0.0, 1.0);
        
        canvas.drawCircle(
          center,
          waveRadius,
          Paint()
            ..color = activeColor.withOpacity(waveAlpha * 0.4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0 + voiceLevel,
        );
      }
    }

    // Mic icon in center
    final micPaint = Paint()
      ..color = Colors.white.withOpacity(isListening ? 0.9 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final micCenter = Offset(center.dx, center.dy - r * 0.1);
    final micR = r * 0.25;

    // Mic body
    final micRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: micCenter, width: micR * 0.6, height: micR * 0.9),
      Radius.circular(micR * 0.3),
    );
    canvas.drawRRect(micRect, micPaint);

    // Mic base
    canvas.drawLine(
      Offset(micCenter.dx - micR * 0.4, micCenter.dy + micR * 0.5),
      Offset(micCenter.dx + micR * 0.4, micCenter.dy + micR * 0.5),
      micPaint,
    );

    // Stand
    canvas.drawLine(
      Offset(micCenter.dx, micCenter.dy + micR * 0.5),
      Offset(micCenter.dx, micCenter.dy + micR * 0.9),
      micPaint,
    );

    // Center dot pulse
    canvas.drawCircle(
      center,
      2.0 + pulse,
      Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(covariant _VoiceOrbPainter oldDelegate) => true;
}