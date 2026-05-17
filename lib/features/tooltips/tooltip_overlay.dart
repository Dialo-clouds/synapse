import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class TooltipOverlay extends StatefulWidget {
  final Widget child;
  final List<TooltipStep> steps;
  final VoidCallback? onComplete;

  const TooltipOverlay({
    super.key,
    required this.child,
    required this.steps,
    this.onComplete,
  });

  @override
  State<TooltipOverlay> createState() => _TooltipOverlayState();
}

class _TooltipOverlayState extends State<TooltipOverlay> {
  int _currentStep = 0;
  bool _showTooltip = true;

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      setState(() => _showTooltip = false);
      widget.onComplete?.call();
    }
  }

  void _skipAll() {
    setState(() => _showTooltip = false);
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showTooltip) return widget.child;

    final step = widget.steps[_currentStep];

    return Stack(
      children: [
        widget.child,
        // Dim overlay
        GestureDetector(
          onTap: _nextStep,
          child: Container(color: Colors.black.withOpacity(0.7)),
        ),
        // Tooltip card
        Positioned(
          bottom: step.position == TooltipPosition.bottom ? 100 : null,
          top: step.position == TooltipPosition.top ? 100 : null,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: SynapseTokens.electricBlue.withOpacity(0.3)),
              boxShadow: [BoxShadow(color: SynapseTokens.electricBlue.withOpacity(0.2), blurRadius: 30)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: SynapseTokens.electricBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_currentStep + 1}/${widget.steps.length}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: SynapseTokens.electricBlue),
                      ),
                    ),
                    GestureDetector(
                      onTap: _skipAll,
                      child: Text(
                        'SKIP',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: SynapseTokens.textTertiary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  step.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  step.description,
                  style: TextStyle(fontSize: 13, color: SynapseTokens.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _nextStep,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [SynapseTokens.primaryViolet, SynapseTokens.electricBlue]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        _currentStep == widget.steps.length - 1 ? 'GOT IT' : 'NEXT',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 20, end: 0),
        ),
      ],
    );
  }
}

enum TooltipPosition { top, bottom }

class TooltipStep {
  final String title;
  final String description;
  final TooltipPosition position;

  const TooltipStep({
    required this.title,
    required this.description,
    this.position = TooltipPosition.bottom,
  });
}