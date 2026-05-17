import 'package:flutter/material.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../core/services/pocketbase_service.dart';
import '../../core/services/theme_service.dart';
import '../../shared/services/export_service.dart';
import '../../features/auth/biometric_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/scheduler/device_scheduler.dart';
import '../../features/activity/activity_feed.dart';
import '../../features/audit/audit_log.dart';
import '../../features/admin/user_management.dart';
import '../../features/analytics/analytics_dashboard.dart';
import '../../features/admin/system_status.dart';
import '../../features/help/help_center.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ThemeService _themeService = ThemeService();
  bool _darkMode = true;
  bool _notifications = true;
  bool _spatialAudio = true;
  bool _energyAlerts = false;
  bool _autoScan = true;

  @override
  void initState() {
    super.initState();
    _themeService.addListener(() {
      if (mounted) setState(() => _darkMode = _themeService.isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = PocketBaseService.pb.authStore.model?.getStringValue('email') ?? 'user@synapse.app';
    final userName = PocketBaseService.pb.authStore.model?.getStringValue('name') ?? 'Synapse User';

    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, letterSpacing: -0.5, decoration: TextDecoration.none),
              ),
              const SizedBox(height: 4),
              Text(
                'Configure your Synapse',
                style: TextStyle(fontSize: 14, color: SynapseTokens.textTertiary, decoration: TextDecoration.none),
              ),

              const SizedBox(height: 24),

              // Profile Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(colors: [SynapseTokens.primaryViolet, SynapseTokens.electricBlue]),
                      ),
                      child: Center(
                        child: Text(
                          userName[0].toUpperCase(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                          const SizedBox(height: 2),
                          Text(userEmail, style: const TextStyle(fontSize: 12, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Preferences
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PREFERENCES', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                    const SizedBox(height: 16),
                    _ToggleRow(label: 'Dark Mode', subtitle: 'Switch between dark and light theme', value: _darkMode, onChanged: (v) => _themeService.toggleTheme()),
                    const _Divider(),
                    _ToggleRow(label: 'Push Notifications', subtitle: 'Device alerts and updates', value: _notifications, onChanged: (v) => setState(() => _notifications = v)),
                    const _Divider(),
                    _ToggleRow(label: 'Spatial Audio', subtitle: '3D sound feedback', value: _spatialAudio, onChanged: (v) => setState(() => _spatialAudio = v)),
                    const _Divider(),
                    _ToggleRow(label: 'Energy Alerts', subtitle: 'High consumption warnings', value: _energyAlerts, onChanged: (v) => setState(() => _energyAlerts = v)),
                    const _Divider(),
                    _ToggleRow(label: 'Auto-Scan', subtitle: 'Continuously detect objects', value: _autoScan, onChanged: (v) => setState(() => _autoScan = v)),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Security
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SECURITY', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: SynapseTokens.durationNormal,
                            pageBuilder: (_, __, ___) => const BiometricScreen(),
                            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Change Auth Method', style: TextStyle(fontSize: 14, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                          Icon(Icons.arrow_forward_ios, size: 14, color: SynapseTokens.textTertiary.withOpacity(0.4)),
                        ],
                      ),
                    ),
                    const _Divider(),
                    GestureDetector(
                      onTap: () async {
                        final report = await ExportService.exportEnergyReport();
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: const Color(0xFF0A0A14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: const Text('Energy Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                              content: SingleChildScrollView(
                                child: Text(report, style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace', height: 1.5, decoration: TextDecoration.none)),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close', style: TextStyle(color: SynapseTokens.electricBlue))),
                              ],
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Export Report', style: TextStyle(fontSize: 14, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                          Icon(Icons.download, size: 16, color: SynapseTokens.textTertiary.withOpacity(0.6)),
                        ],
                      ),
                    ),
                    const _Divider(),
                    GestureDetector(
                      onTap: () async {
                        final jsonData = await ExportService.exportAsJson();
                        final jsonString = ExportService.formatJson(jsonData);
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: const Color(0xFF0A0A14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: const Text('JSON Export', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                              content: SingleChildScrollView(
                                child: Text(jsonString, style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace', height: 1.5, decoration: TextDecoration.none)),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close', style: TextStyle(color: SynapseTokens.electricBlue))),
                              ],
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Export JSON', style: TextStyle(fontSize: 14, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                          Icon(Icons.code, size: 16, color: SynapseTokens.textTertiary.withOpacity(0.6)),
                        ],
                      ),
                    ),
                    const _Divider(),
                    GestureDetector(
                      onTap: () async {
                        await PocketBaseService.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                              transitionDuration: SynapseTokens.durationNormal,
                              pageBuilder: (_, __, ___) => const LoginScreen(),
                              transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sign Out', style: TextStyle(fontSize: 14, color: SynapseTokens.neuralPink, decoration: TextDecoration.none)),
                          Icon(Icons.logout, size: 16, color: SynapseTokens.neuralPink.withOpacity(0.6)),
                        ],
                      ),
                    ),
                    const _Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('App Version', style: TextStyle(fontSize: 14, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                        Text('1.0.0', style: TextStyle(fontSize: 14, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Scheduler
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.5),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: SynapseTokens.durationNormal,
                        pageBuilder: (_, __, ___) => const DeviceScheduler(),
                        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: SynapseTokens.plasmaAmber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.schedule, color: SynapseTokens.plasmaAmber, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Device Scheduler', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                              Text('Automate your devices', style: TextStyle(fontSize: 11, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14, color: SynapseTokens.textTertiary.withOpacity(0.4)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Activity & Audit
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.5),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: SynapseTokens.durationNormal,
                            pageBuilder: (_, __, ___) => const ActivityFeed(),
                            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: SynapseTokens.electricBlue.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.receipt_long, color: SynapseTokens.electricBlue, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Text('Activity Feed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 14, color: SynapseTokens.textTertiary.withOpacity(0.4)),
                        ],
                      ),
                    ),
                    const _Divider(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: SynapseTokens.durationNormal,
                            pageBuilder: (_, __, ___) => const AuditLog(),
                            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: SynapseTokens.plasmaAmber.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.security, color: SynapseTokens.plasmaAmber, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Text('Audit Log', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 14, color: SynapseTokens.textTertiary.withOpacity(0.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Admin Tools
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ADMIN TOOLS', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: SynapseTokens.durationNormal,
                            pageBuilder: (_, __, ___) => const UserManagement(),
                            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: SynapseTokens.neuralPink.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.group, color: SynapseTokens.neuralPink, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Text('User Management', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 14, color: SynapseTokens.textTertiary.withOpacity(0.4)),
                        ],
                      ),
                    ),
                    const _Divider(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: SynapseTokens.durationNormal,
                            pageBuilder: (_, __, ___) => const AnalyticsDashboard(),
                            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: SynapseTokens.primaryViolet.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.insights, color: SynapseTokens.primaryViolet, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Text('Analytics Dashboard', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 14, color: SynapseTokens.textTertiary.withOpacity(0.4)),
                        ],
                      ),
                    ),
                    const _Divider(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: SynapseTokens.durationNormal,
                            pageBuilder: (_, __, ___) => const SystemStatus(),
                            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: SynapseTokens.auroraTeal.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.monitor_heart, color: SynapseTokens.auroraTeal, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Text('System Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 14, color: SynapseTokens.textTertiary.withOpacity(0.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Help
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.5),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: SynapseTokens.durationNormal,
                        pageBuilder: (_, __, ___) => const HelpCenter(),
                        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: SynapseTokens.primaryViolet.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.help_outline, color: SynapseTokens.primaryViolet, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Help Center', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                              Text('FAQs and support', style: TextStyle(fontSize: 11, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14, color: SynapseTokens.textTertiary.withOpacity(0.4)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({required this.label, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: SynapseTokens.durationFast,
            width: 48, height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: value ? SynapseTokens.electricBlue.withOpacity(0.4) : Colors.white.withOpacity(0.06),
              border: Border.all(color: value ? SynapseTokens.electricBlue.withOpacity(0.5) : Colors.white.withOpacity(0.08)),
              boxShadow: value ? [BoxShadow(color: SynapseTokens.electricBlue.withOpacity(0.3), blurRadius: 10)] : [],
            ),
            child: AnimatedAlign(
              duration: SynapseTokens.durationFast,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(width: 22, height: 22, margin: const EdgeInsets.symmetric(horizontal: 3), decoration: BoxDecoration(shape: BoxShape.circle, color: value ? Colors.white : SynapseTokens.textTertiary)),
            ),
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(height: 0.5, color: Colors.white.withOpacity(0.06)),
    );
  }
}