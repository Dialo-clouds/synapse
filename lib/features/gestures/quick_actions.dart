import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class QuickAction {
  final String label;
  final String gesture;
  final IconData icon;

  const QuickAction({required this.label, required this.gesture, required this.icon});
}

class QuickActionsPanel extends StatelessWidget {
  const QuickActionsPanel({super.key});

  static const List<QuickAction> actions = [
    QuickAction(label: 'All Lights', gesture: 'Swipe up', icon: Icons.lightbulb_outline),
    QuickAction(label: 'Lock All', gesture: 'Swipe down', icon: Icons.lock_outline),
    QuickAction(label: 'Energy Save', gesture: 'Swipe left', icon: Icons.bolt_outlined),
    QuickAction(label: 'Morning Scene', gesture: 'Swipe right', icon: Icons.wb_sunny_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'GESTURE SHORTCUTS',
            style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.map((action) {
              return Column(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: SynapseTokens.electricBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SynapseTokens.electricBlue.withOpacity(0.2)),
                    ),
                    child: Icon(action.icon, color: SynapseTokens.electricBlue.withOpacity(0.7), size: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(action.label, style: const TextStyle(fontSize: 8, color: SynapseTokens.textSecondary, decoration: TextDecoration.none)),
                  Text(action.gesture, style: TextStyle(fontSize: 7, color: SynapseTokens.textTertiary.withOpacity(0.6), decoration: TextDecoration.none)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}