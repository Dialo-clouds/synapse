import 'package:flutter/material.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../shared/widgets/glass_container.dart';
import 'particle_streams.dart';

class EnergyField extends StatefulWidget {
  const EnergyField({super.key});

  @override
  State<EnergyField> createState() => _EnergyFieldState();
}

class _EnergyFieldState extends State<EnergyField> {
  double _energyLevel = 0.45;
  double _solarInput = 0.3;
  double _batteryLevel = 0.72;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      opacity: 0.05,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              const Flexible(
                child: Text(
                  'ENERGY FIELD',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: SynapseTokens.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: SynapseTokens.auroraTeal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 8,
                    color: SynapseTokens.auroraTeal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Energy particle streams
          SizedBox(
            height: 120,
            child: EnergyParticleStreams(
              energyLevel: _energyLevel,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(_energyLevel * 8).toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const Text(
                      'kW',
                      style: TextStyle(
                        fontSize: 11,
                        color: SynapseTokens.textTertiary,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _EnergyStat(
                label: 'Solar',
                value: '${(_solarInput * 5).toStringAsFixed(1)}',
                unit: 'kW',
                color: SynapseTokens.auroraTeal,
              ),
              _EnergyStat(
                label: 'Battery',
                value: '${(_batteryLevel * 100).round()}',
                unit: '%',
                color: SynapseTokens.electricBlue,
              ),
              _EnergyStat(
                label: 'Grid',
                value: '${(_energyLevel * 3).toStringAsFixed(1)}',
                unit: 'kW',
                color: SynapseTokens.plasmaAmber,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EnergyStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _EnergyStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$value $unit',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: SynapseTokens.textTertiary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}