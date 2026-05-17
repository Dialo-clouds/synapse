import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../shared/widgets/glass_container.dart';
import 'voice_controller.dart';

class VoiceUI extends StatefulWidget {
  final Function(VoiceCommand)? onCommand;

  const VoiceUI({super.key, this.onCommand});

  @override
  State<VoiceUI> createState() => _VoiceUIState();
}

class _VoiceUIState extends State<VoiceUI> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _isListening = false;
  bool _showResponse = false;
  String _responseText = '';
  VoiceCommand? _lastCommand;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (!_isListening && _textController.text.isNotEmpty) {
        _processCommand(_textController.text);
      }
    });
  }

  void _processCommand(String text) {
    final command = VoiceController.parseCommand(text);
    if (command != null) {
      _lastCommand = command;
      _responseText = VoiceController.getRandomResponse();
      widget.onCommand?.call(command);
    } else {
      _responseText = "I didn't catch that. Try again.";
    }
    setState(() => _showResponse = true);
    _textController.clear();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showResponse = false);
    });
  }

  void _useSuggestion(String suggestion) {
    _textController.text = suggestion;
    _processCommand(suggestion);
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      opacity: 0.05,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'VOICE CONTROL',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: SynapseTokens.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Listening indicator
              if (_isListening)
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: SynapseTokens.neuralPink.withOpacity(
                          (0.5 + _pulseController.value * 0.5).clamp(0.0, 1.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: SynapseTokens.neuralPink.withOpacity(0.4),
                            blurRadius: 8 * _pulseController.value,
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Voice orb
          GestureDetector(
            onTap: _toggleListening,
            child: AnimatedContainer(
              duration: SynapseTokens.durationFast,
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: _isListening
                      ? [
                          SynapseTokens.neuralPink.withOpacity(0.3),
                          SynapseTokens.primaryViolet.withOpacity(0.1),
                        ]
                      : [
                          SynapseTokens.electricBlue.withOpacity(0.15),
                          SynapseTokens.primaryViolet.withOpacity(0.05),
                        ],
                ),
                border: Border.all(
                  color: _isListening
                      ? SynapseTokens.neuralPink.withOpacity(0.5)
                      : SynapseTokens.electricBlue.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: _isListening
                    ? [
                        BoxShadow(
                          color: SynapseTokens.neuralPink.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(32, 32),
                  painter: _MicIconPainter(isActive: _isListening),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            _isListening ? 'Listening...' : 'Tap to speak',
            style: TextStyle(
              fontSize: 13,
              color: _isListening
                  ? SynapseTokens.neuralPink
                  : SynapseTokens.textTertiary,
            ),
          ),

          // Response
          if (_showResponse)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: SynapseTokens.auroraTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: SynapseTokens.auroraTeal.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _responseText,
                  style: TextStyle(
                    fontSize: 13,
                    color: SynapseTokens.auroraTeal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Suggestions
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: VoiceController.getSuggestions().take(4).map((suggestion) {
              return GestureDetector(
                onTap: () => _useSuggestion(suggestion),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 10,
                      color: SynapseTokens.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MicIconPainter extends CustomPainter {
  final bool isActive;

  _MicIconPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(isActive ? 0.9 : 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.3;

    // Mic body
    final micRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - r * 0.3),
        width: r * 0.8,
        height: r * 1.2,
      ),
      Radius.circular(r * 0.4),
    );
    canvas.drawRRect(micRect, paint);

    // Mic base
    canvas.drawLine(
      Offset(center.dx - r * 0.6, center.dy + r * 0.4),
      Offset(center.dx + r * 0.6, center.dy + r * 0.4),
      paint,
    );

    // Stand
    canvas.drawLine(
      Offset(center.dx, center.dy + r * 0.4),
      Offset(center.dx, center.dy + r * 0.8),
      paint,
    );

    // Base arc
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + r * 0.8),
        width: r * 1.2,
        height: r * 0.4,
      ),
      3.14,
      3.14,
      false,
      paint,
    );

    if (isActive) {
      // Sound waves
      for (int i = 0; i < 2; i++) {
        canvas.drawArc(
          Rect.fromCenter(
            center: center,
            width: r * (1.8 + i * 0.6),
            height: r * (1.8 + i * 0.6),
          ),
          -0.8,
          1.6,
          false,
          Paint()
            ..color = SynapseTokens.neuralPink.withOpacity((0.4 - i * 0.15).clamp(0.0, 1.0))
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MicIconPainter oldDelegate) =>
      isActive != oldDelegate.isActive;
}