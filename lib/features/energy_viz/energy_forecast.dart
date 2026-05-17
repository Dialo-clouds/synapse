import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class EnergyForecast extends StatelessWidget {
  const EnergyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    final tomorrow = _generateForecast();
    final savings = (Random().nextDouble() * 20 + 5).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOMORROW FORECAST',
                style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: SynapseTokens.auroraTeal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'SAVE \$$savings',
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: SynapseTokens.auroraTeal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ForecastItem(label: 'Usage', value: tomorrow['usage']!, unit: 'kWh', icon: Icons.bolt),
              _ForecastItem(label: 'Solar', value: tomorrow['solar']!, unit: 'kWh', icon: Icons.wb_sunny),
              _ForecastItem(label: 'Cost', value: '\$${tomorrow['cost']!}', unit: '', icon: Icons.attach_money),
              _ForecastItem(label: 'Efficiency', value: tomorrow['efficiency']!, unit: '%', icon: Icons.trending_up),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SynapseTokens.plasmaAmber.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SynapseTokens.plasmaAmber.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.tips_and_updates, color: SynapseTokens.plasmaAmber, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Peak usage expected at 6:30 PM. Run dishwasher before 4 PM to save \$2.40.',
                    style: TextStyle(fontSize: 11, color: SynapseTokens.plasmaAmber.withOpacity(0.8), decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _generateForecast() {
    return {
      'usage': '${(15 + Random().nextDouble() * 10).toStringAsFixed(1)}',
      'solar': '${(3 + Random().nextDouble() * 5).toStringAsFixed(1)}',
      'cost': '${(3 + Random().nextDouble() * 5).toStringAsFixed(2)}',
      'efficiency': '${(65 + Random().nextDouble() * 20).toStringAsFixed(0)}',
    };
  }
}

class _ForecastItem extends StatelessWidget {
  final String label, value, unit;
  final IconData icon;

  const _ForecastItem({required this.label, required this.value, required this.unit, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: SynapseTokens.electricBlue.withOpacity(0.6), size: 18),
        const SizedBox(height: 6),
        Text('$value $unit', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
      ],
    );
  }
}