import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class DeviceScheduler extends StatefulWidget {
  const DeviceScheduler({super.key});

  @override
  State<DeviceScheduler> createState() => _DeviceSchedulerState();
}

class _DeviceSchedulerState extends State<DeviceScheduler> {
  final List<_Schedule> _schedules = [
    _Schedule(device: 'Living Room Light', time: '07:00 AM', action: 'Turn ON', days: 'Mon-Fri', isActive: true),
    _Schedule(device: 'Thermostat', time: '10:00 PM', action: 'Set 18C', days: 'Everyday', isActive: true),
    _Schedule(device: 'Coffee Machine', time: '06:30 AM', action: 'Start Brew', days: 'Mon-Fri', isActive: false),
  ];

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
                    'Device Scheduler',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _schedules.length + 1,
                itemBuilder: (context, index) {
                  if (index == _schedules.length) {
                    return Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.06), style: BorderStyle.solid),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: SynapseTokens.electricBlue, size: 20),
                            SizedBox(width: 8),
                            Text('Add Schedule', style: TextStyle(color: SynapseTokens.electricBlue, fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    );
                  }

                  final schedule = _schedules[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: schedule.isActive ? SynapseTokens.electricBlue.withOpacity(0.05) : Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: schedule.isActive ? SynapseTokens.electricBlue.withOpacity(0.2) : Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: (schedule.isActive ? SynapseTokens.electricBlue : SynapseTokens.textTertiary).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.schedule, color: schedule.isActive ? SynapseTokens.electricBlue : SynapseTokens.textTertiary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(schedule.device, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                              const SizedBox(height: 2),
                              Text('${schedule.time} \u2022 ${schedule.action} \u2022 ${schedule.days}', style: const TextStyle(fontSize: 11, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                            ],
                          ),
                        ),
                        Switch(
                          value: schedule.isActive,
                          onChanged: (v) => setState(() => schedule.isActive = v),
                          activeColor: SynapseTokens.electricBlue,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: Duration(milliseconds: index * 80)).slideX(begin: 10, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Schedule {
  String device;
  String time;
  String action;
  String days;
  bool isActive;

  _Schedule({
    required this.device,
    required this.time,
    required this.action,
    required this.days,
    required this.isActive,
  });
}