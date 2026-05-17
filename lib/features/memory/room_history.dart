import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../core/services/pocketbase_service.dart';
import '../../shared/widgets/empty_state.dart';

class RoomHistory extends StatefulWidget {
  const RoomHistory({super.key});

  @override
  State<RoomHistory> createState() => _RoomHistoryState();
}

class _RoomHistoryState extends State<RoomHistory>
    with TickerProviderStateMixin {
  
  late AnimationController _particleController;
  List<Map<String, dynamic>> _events = [];
  bool _loading = true;

  final Map<String, Map<String, dynamic>> _energySummary = {
    'today': {'usage': '18.5 kWh', 'cost': '\$4.44', 'peak': '6:30 PM'},
    'week': {'usage': '124.3 kWh', 'cost': '\$29.83', 'peak': 'Wednesday'},
    'month': {'usage': '487.2 kWh', 'cost': '\$116.93', 'peak': 'Week 2'},
  };

  String _selectedPeriod = 'today';

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    _loadFromBackend();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  Future<void> _loadFromBackend() async {
    setState(() => _loading = true);
    try {
      final records = await PocketBaseService.getDevices();
      if (mounted) {
        setState(() {
          _events = records.map((r) => {
            'id': r.id,
            'time': r.created.substring(11, 16),
            'device': r.data['name'] ?? 'Unknown',
            'action': r.data['is_on'] == true ? 'Turned ON' : 'Turned OFF',
            'value': r.data['type'] ?? 'device',
            'type': r.data['type'] ?? 'light',
          }).toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteItem(int index) async {
    final item = _events[index];
    setState(() => _events.removeAt(index));
    try {
      await PocketBaseService.pb.collection('devices').delete(item['id']);
    } catch (_) {}
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'light': return SynapseTokens.plasmaAmber;
      case 'climate': return SynapseTokens.auroraTeal;
      case 'appliance': return SynapseTokens.electricBlue;
      case 'scene': return SynapseTokens.primaryViolet;
      case 'lock': return SynapseTokens.auroraTeal;
      case 'entertainment': return SynapseTokens.neuralPink;
      case 'blinds': return SynapseTokens.electricBlue;
      default: return SynapseTokens.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final energy = _energySummary[_selectedPeriod]!;

    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: _HistoryBgPainter(progress: _particleController.value),
              child: RefreshIndicator(
                onRefresh: _loadFromBackend,
                color: SynapseTokens.electricBlue,
                backgroundColor: const Color(0xFF000008),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Memory',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, letterSpacing: -0.5, decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 4),
                      Text('Your space remembers everything', style: TextStyle(fontSize: 14, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),

                      const SizedBox(height: 24),

                      // Energy Summary Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.06))),
                        child: Column(
                          children: [
                            Row(
                              children: ['today', 'week', 'month'].map((period) {
                                final isSelected = _selectedPeriod == period;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedPeriod = period),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? SynapseTokens.electricBlue.withOpacity(0.15) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: isSelected ? SynapseTokens.electricBlue.withOpacity(0.3) : Colors.white.withOpacity(0.06)),
                                    ),
                                    child: Text(period.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isSelected ? SynapseTokens.electricBlue : SynapseTokens.textTertiary, letterSpacing: 1.5, decoration: TextDecoration.none)),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _EnergyStat(label: 'Usage', value: energy['usage']!, color: SynapseTokens.electricBlue),
                                _EnergyStat(label: 'Cost', value: energy['cost']!, color: SynapseTokens.auroraTeal),
                                _EnergyStat(label: 'Peak', value: energy['peak']!, color: SynapseTokens.plasmaAmber),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text('TIMELINE', style: TextStyle(fontSize: 11, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                      const SizedBox(height: 16),

                      if (_loading)
                        const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: SynapseTokens.electricBlue)))
                      else if (_events.isEmpty)
                        EmptyState(
                          title: 'No interactions yet',
                          subtitle: 'Device activity will appear here when you start controlling your smart home.',
                          icon: Icons.timeline_outlined,
                          onAction: _loadFromBackend,
                          actionLabel: 'Refresh',
                        )
                      else
                        ..._events.asMap().entries.map((entry) {
                          final index = entry.key;
                          final event = entry.value;
                          return Dismissible(
                            key: Key('${event['time']}_$index'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: SynapseTokens.neuralPink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.delete, color: SynapseTokens.neuralPink.withOpacity(0.8)),
                            ),
                            onDismissed: (_) => _deleteItem(index),
                            child: _TimelineCard(
                              time: event['time']!,
                              device: event['device']!,
                              action: event['action']!,
                              value: event['value']!,
                              color: _getTypeColor(event['type']!),
                            ),
                          );
                        }).toList(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EnergyStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _EnergyStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color, decoration: TextDecoration.none)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: SynapseTokens.textTertiary, letterSpacing: 1, decoration: TextDecoration.none)),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final String time, device, action, value;
  final Color color;
  const _TimelineCard({required this.time, required this.device, required this.action, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 55,
          child: Column(
            children: [
              Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: SynapseTokens.textSecondary, decoration: TextDecoration.none)),
              const SizedBox(height: 6),
              Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.8), boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 6)])),
              Container(width: 1.5, height: 50, color: Colors.white.withOpacity(0.04)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.04))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                      const SizedBox(height: 2),
                      Text(action, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8), decoration: TextDecoration.none)),
                    ],
                  ),
                ),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color, decoration: TextDecoration.none))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryBgPainter extends CustomPainter {
  final double progress;
  _HistoryBgPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    for (int i = 0; i < 30; i++) {
      final y = (random.nextDouble() + progress * 0.2) % 1.0 * size.height;
      final x = random.nextDouble() * size.width;
      canvas.drawCircle(Offset(x, y), 1.0 + random.nextDouble(), Paint()..color = SynapseTokens.electricBlue.withOpacity((0.03 + 0.05 * sin(progress * 3 + i)).clamp(0.0, 1.0))..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
    }
  }

  @override
  bool shouldRepaint(covariant _HistoryBgPainter oldDelegate) => true;
}