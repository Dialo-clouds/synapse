import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class AuditLog extends StatelessWidget {
  const AuditLog({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = [
      {'time': '10:32 AM', 'user': 'Alex', 'action': 'Toggled Living Room Light ON', 'category': 'Device'},
      {'time': '10:28 AM', 'user': 'Alex', 'action': 'Adjusted Thermostat to 22C', 'category': 'Climate'},
      {'time': '09:15 AM', 'user': 'Alex', 'action': 'Activated Morning Scene', 'category': 'Scene'},
      {'time': '07:00 AM', 'user': 'System', 'action': 'Auto-locked front door', 'category': 'Security'},
      {'time': '11:30 PM', 'user': 'Alex', 'action': 'Signed out', 'category': 'Auth'},
      {'time': '11:30 PM', 'user': 'System', 'action': 'Energy snapshot saved', 'category': 'System'},
    ];

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
                    'Audit Log',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 55,
                          child: Text(log['time']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                        ),
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getCategoryColor(log['category']!),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log['action']!, style: const TextStyle(fontSize: 12, color: SynapseTokens.textSecondary, decoration: TextDecoration.none)),
                              Text(log['user']!, style: const TextStyle(fontSize: 10, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(log['category']!).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(log['category']!, style: TextStyle(fontSize: 8, color: _getCategoryColor(log['category']!), fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: Duration(milliseconds: index * 40));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Device': return SynapseTokens.electricBlue;
      case 'Climate': return SynapseTokens.auroraTeal;
      case 'Scene': return SynapseTokens.primaryViolet;
      case 'Security': return SynapseTokens.plasmaAmber;
      case 'Auth': return SynapseTokens.neuralPink;
      case 'System': return SynapseTokens.textTertiary;
      default: return SynapseTokens.textSecondary;
    }
  }
}