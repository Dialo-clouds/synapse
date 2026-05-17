import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import 'detection_service.dart';

class ObjectOverlay extends StatelessWidget {
  final DetectedObject object;
  final bool isActive;

  const ObjectOverlay({
    super.key,
    required this.object,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Glowing ring around object
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                  ? SynapseTokens.auroraTeal.withOpacity(0.6)
                  : SynapseTokens.electricBlue.withOpacity(0.3),
              width: isActive ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isActive ? SynapseTokens.auroraTeal : SynapseTokens.electricBlue)
                    .withOpacity(isActive ? 0.3 : 0.1),
                blurRadius: isActive ? 40 : 20,
                spreadRadius: isActive ? 15 : 5,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getIcon(object.type),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Object label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Text(
            object.name,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Confidence badge
        const SizedBox(height: 4),
        Text(
          '${(object.confidence * 100).round()}% match',
          style: TextStyle(
            fontSize: 9,
            color: SynapseTokens.auroraTeal.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  String _getIcon(String type) {
    switch (type) {
      case 'light': return '💡';
      case 'climate': return '🌡️';
      case 'entertainment': return '📺';
      case 'music': return '🔊';
      case 'lock': return '🔒';
      case 'appliance': return '☕';
      case 'blinds': return '🪟';
      default: return '📦';
    }
  }
}