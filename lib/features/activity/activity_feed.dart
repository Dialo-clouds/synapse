import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../core/services/pocketbase_service.dart';

class ActivityFeed extends StatefulWidget {
  const ActivityFeed({super.key});

  @override
  State<ActivityFeed> createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  List<Map<String, dynamic>> _activities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() => _loading = true);
    try {
      final records = await PocketBaseService.getDevices();
      if (mounted) {
        setState(() {
          _activities = records.map((r) => {
            'id': r.id,
            'user': PocketBaseService.pb.authStore.model?.getStringValue('name') ?? 'User',
            'action': r.data['is_on'] == true ? 'turned on' : 'turned off',
            'device': r.data['name'] ?? 'Unknown Device',
            'time': _formatTime(r.created),
            'type': r.data['type'] ?? 'device',
          }).toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatTime(String iso) {
    try {
      final date = DateTime.parse(iso);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'light': return SynapseTokens.plasmaAmber;
      case 'climate': return SynapseTokens.auroraTeal;
      case 'entertainment': return SynapseTokens.electricBlue;
      case 'music': return SynapseTokens.neuralPink;
      case 'lock': return SynapseTokens.auroraTeal;
      case 'appliance': return SynapseTokens.plasmaAmber;
      default: return SynapseTokens.primaryViolet;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'light': return Icons.lightbulb_outline;
      case 'climate': return Icons.thermostat_outlined;
      case 'entertainment': return Icons.tv;
      case 'music': return Icons.speaker;
      case 'lock': return Icons.lock_outline;
      case 'appliance': return Icons.coffee;
      default: return Icons.devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: const Center(child: Icon(Icons.arrow_back, color: SynapseTokens.textSecondary, size: 20)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Activity Feed',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _loadActivities,
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: SynapseTokens.electricBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Icon(Icons.refresh, color: SynapseTokens.electricBlue, size: 20)),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: SynapseTokens.electricBlue))
                  : _activities.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.08), width: 2)),
                                child: const Icon(Icons.history, size: 32, color: SynapseTokens.textTertiary),
                              ),
                              const SizedBox(height: 16),
                              const Text('No activity yet', style: TextStyle(fontSize: 16, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                              const SizedBox(height: 4),
                              Text('Device interactions will appear here', style: TextStyle(fontSize: 12, color: SynapseTokens.textTertiary.withOpacity(0.5), decoration: TextDecoration.none)),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadActivities,
                          color: SynapseTokens.electricBlue,
                          backgroundColor: const Color(0xFF000008),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _activities.length,
                            itemBuilder: (context, index) {
                              final activity = _activities[index];
                              final color = _getTypeColor(activity['type']!);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.02),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36, height: 36,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Icon(_getTypeIcon(activity['type']!), color: color, size: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(fontSize: 13, color: SynapseTokens.textSecondary, height: 1.4, decoration: TextDecoration.none),
                                          children: [
                                            TextSpan(text: activity['user'], style: const TextStyle(fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary)),
                                            TextSpan(text: ' ${activity['action']} '),
                                            TextSpan(text: activity['device'], style: const TextStyle(fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(activity['time'], style: const TextStyle(fontSize: 10, color: SynapseTokens.textTertiary)),
                                  ],
                                ),
                              ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideX(begin: 10, end: 0);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}