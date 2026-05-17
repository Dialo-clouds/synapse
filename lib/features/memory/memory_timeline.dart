import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../shared/widgets/glass_container.dart';

class MemoryTimeline extends StatelessWidget {
  const MemoryTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      opacity: 0.05,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MEMORY TIMELINE',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 2,
              color: SynapseTokens.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          _TimelineEvent(
            time: '10:32 AM',
            title: 'Thermostat adjusted',
            detail: 'Temperature set to 22°C',
            color: SynapseTokens.plasmaAmber,
            isLast: false,
          ),
          _TimelineEvent(
            time: '09:15 AM',
            title: 'Lights turned on',
            detail: 'Living Room brightness 80%',
            color: SynapseTokens.electricBlue,
            isLast: false,
          ),
          _TimelineEvent(
            time: '07:00 AM',
            title: 'Morning scene activated',
            detail: 'All lights, coffee started',
            color: SynapseTokens.auroraTeal,
            isLast: false,
          ),
          _TimelineEvent(
            time: '11:30 PM',
            title: 'Goodnight mode',
            detail: 'House secured, energy save',
            color: SynapseTokens.primaryViolet,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineEvent extends StatelessWidget {
  final String time;
  final String title;
  final String detail;
  final Color color;
  final bool isLast;

  const _TimelineEvent({
    required this.time,
    required this.title,
    required this.detail,
    required this.color,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and dot
        SizedBox(
          width: 50,
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 10,
                  color: SynapseTokens.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.white.withOpacity(0.06),
                ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Event details
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SynapseTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 11,
                    color: SynapseTokens.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}