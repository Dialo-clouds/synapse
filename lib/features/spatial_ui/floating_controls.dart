import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import 'glass_panel.dart';

class FloatingControls extends StatefulWidget {
  final String deviceName;
  final String deviceType;
  final bool isOn;
  final double value;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double>? onValueChanged;
  final VoidCallback? onClose;

  const FloatingControls({
    super.key,
    required this.deviceName,
    required this.deviceType,
    required this.isOn,
    required this.value,
    required this.onToggle,
    this.onValueChanged,
    this.onClose,
  });

  @override
  State<FloatingControls> createState() => _FloatingControlsState();
}

class _FloatingControlsState extends State<FloatingControls> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      title: widget.deviceName,
      subtitle: widget.deviceType.toUpperCase(),
      onClose: widget.onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Power toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Power',
                style: TextStyle(
                  fontSize: 14,
                  color: SynapseTokens.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => widget.onToggle(!widget.isOn),
                child: AnimatedContainer(
                  duration: SynapseTokens.durationFast,
                  width: 48,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: widget.isOn
                        ? SynapseTokens.electricBlue.withOpacity(0.3)
                        : Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: widget.isOn
                          ? SynapseTokens.electricBlue.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                    ),
                    boxShadow: widget.isOn
                        ? [
                            SynapseTokens.glow(
                              SynapseTokens.electricBlue,
                              opacity: 0.3,
                              blur: 15,
                            )
                          ]
                        : [],
                  ),
                  child: AnimatedAlign(
                    duration: SynapseTokens.durationFast,
                    alignment: widget.isOn
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isOn
                            ? Colors.white
                            : SynapseTokens.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Value slider
          if (widget.isOn) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    '${(_currentValue * 100).round()}%',
                    style: TextStyle(
                      fontSize: 13,
                      color: SynapseTokens.electricBlue.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GlassSlider(
                    value: _currentValue,
                    activeColor: widget.deviceType == 'light'
                        ? SynapseTokens.plasmaAmber
                        : SynapseTokens.electricBlue,
                    onChanged: (val) {
                      setState(() => _currentValue = val);
                      widget.onValueChanged?.call(val);
                    },
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

class _GlassSlider extends StatelessWidget {
  final double value;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const _GlassSlider({
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            final newVal =
                (value + details.delta.dx / constraints.maxWidth).clamp(0.0, 1.0);
            onChanged(newVal);
          },
          child: Container(
            height: 24,
            color: Colors.transparent,
            child: Center(
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth * value,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: LinearGradient(
                          colors: [activeColor, activeColor.withOpacity(0.5)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment(value * 2 - 1, 0),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: activeColor.withOpacity(0.6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}