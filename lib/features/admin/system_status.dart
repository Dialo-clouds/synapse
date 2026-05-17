import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class SystemStatus extends StatefulWidget {
  const SystemStatus({super.key});

  @override
  State<SystemStatus> createState() => _SystemStatusState();
}

class _SystemStatusState extends State<SystemStatus>
    with TickerProviderStateMixin {
  
  late AnimationController _pulseController;
  final Random _random = Random();

  double _cpuUsage = 34;
  double _memoryUsage = 62;
  double _diskUsage = 45;
  int _uptimeHours = 342;
  int _apiRequests = 12847;
  double _apiLatency = 45;
  bool _databaseOnline = true;
  bool _authOnline = true;
  bool _storageOnline = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('System Status', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                          Row(
                            children: [
                              Container(
                                width: 6, height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SynapseTokens.auroraTeal,
                                  boxShadow: [BoxShadow(color: SynapseTokens.auroraTeal.withOpacity(0.6), blurRadius: 4)],
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text('All Systems Operational', style: TextStyle(fontSize: 11, color: SynapseTokens.auroraTeal, decoration: TextDecoration.none)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Uptime card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [SynapseTokens.primaryViolet.withOpacity(0.2), SynapseTokens.electricBlue.withOpacity(0.05)]),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: SynapseTokens.electricBlue.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: SynapseTokens.electricBlue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.timer, color: SynapseTokens.electricBlue, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_uptimeHours}h', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white, decoration: TextDecoration.none)),
                            Text('Uptime (14 days)', style: TextStyle(fontSize: 11, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                          ],
                        ),
                        const Spacer(),
                        Text('${_apiRequests.toString()} API calls', style: TextStyle(fontSize: 11, color: SynapseTokens.electricBlue, decoration: TextDecoration.none)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Resource usage
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.06))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RESOURCES', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                        const SizedBox(height: 20),
                        _ResourceBar(label: 'CPU', value: _cpuUsage, color: SynapseTokens.electricBlue),
                        const SizedBox(height: 12),
                        _ResourceBar(label: 'Memory', value: _memoryUsage, color: SynapseTokens.plasmaAmber),
                        const SizedBox(height: 12),
                        _ResourceBar(label: 'Disk', value: _diskUsage, color: SynapseTokens.primaryViolet),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // API Performance
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.06))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('API PERFORMANCE', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MetricBadge(label: 'Latency', value: '${_apiLatency.toStringAsFixed(0)}ms', color: SynapseTokens.auroraTeal),
                            _MetricBadge(label: 'Requests', value: '${_apiRequests}', color: SynapseTokens.electricBlue),
                            _MetricBadge(label: 'Error Rate', value: '0.02%', color: SynapseTokens.plasmaAmber),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Service health
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.06))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SERVICE HEALTH', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                        const SizedBox(height: 16),
                        _ServiceRow(name: 'Database', online: _databaseOnline),
                        const _Divider(),
                        _ServiceRow(name: 'Authentication', online: _authOnline),
                        const _Divider(),
                        _ServiceRow(name: 'Storage', online: _storageOnline),
                        const _Divider(),
                        _ServiceRow(name: 'Real-time Sync', online: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ResourceBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ResourceBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: SynapseTokens.textSecondary, decoration: TextDecoration.none)),
            Text('${value.toStringAsFixed(0)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.white.withOpacity(0.05),
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final String label, value;
  final Color color;

  const _MetricBadge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color, decoration: TextDecoration.none)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final String name;
  final bool online;

  const _ServiceRow({required this.name, required this.online});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: const TextStyle(fontSize: 13, color: SynapseTokens.textSecondary, decoration: TextDecoration.none)),
        Row(
          children: [
            Container(
              width: 6, height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: online ? SynapseTokens.auroraTeal : SynapseTokens.neuralPink,
                boxShadow: [BoxShadow(color: (online ? SynapseTokens.auroraTeal : SynapseTokens.neuralPink).withOpacity(0.5), blurRadius: 4)],
              ),
            ),
            const SizedBox(width: 6),
            Text(online ? 'Online' : 'Offline', style: TextStyle(fontSize: 11, color: online ? SynapseTokens.auroraTeal : SynapseTokens.neuralPink)),
          ],
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(height: 0.5, color: Colors.white.withOpacity(0.06)),
    );
  }
}