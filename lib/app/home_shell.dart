import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/tokens/synapse_tokens.dart';
import '../shared/widgets/keyboard_shortcuts.dart';
import '../shared/services/notification_service.dart';
import '../shared/widgets/notification_badge.dart';
import '../features/ar_engine/ar_view.dart';
import '../features/memory/room_history.dart';
import '../features/settings/settings_screen.dart';
import '../features/energy_viz/live_energy_screen.dart';
import '../features/assistant/ai_assistant.dart';
import '../features/search/global_search.dart';
import '../features/command_palette/command_palette.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  final NotificationService _notifService = NotificationService();

  final List<Widget> _screens = const [
    ARView(),
    RoomHistory(),
    LiveEnergyScreen(),
    AIAssistant(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _notifService.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _openCommandPalette() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => CommandPalette(
          onCommand: (command) {
            switch (command) {
              case 'Scan Room':
                setState(() => _currentIndex = 0);
                break;
              case 'View Memory':
                setState(() => _currentIndex = 1);
                break;
              case 'Show Energy':
                setState(() => _currentIndex = 2);
                break;
              case 'Open AI Chat':
                setState(() => _currentIndex = 3);
                break;
              case 'Settings':
                setState(() => _currentIndex = 4);
                break;
            }
          },
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: SynapseTokens.durationNormal,
        pageBuilder: (_, __, ___) => const GlobalSearch(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcutHandler(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.digit1): () => setState(() => _currentIndex = 0),
        LogicalKeySet(LogicalKeyboardKey.digit2): () => setState(() => _currentIndex = 1),
        LogicalKeySet(LogicalKeyboardKey.digit3): () => setState(() => _currentIndex = 2),
        LogicalKeySet(LogicalKeyboardKey.digit4): () => setState(() => _currentIndex = 3),
        LogicalKeySet(LogicalKeyboardKey.digit5): () => setState(() => _currentIndex = 4),
        LogicalKeySet(LogicalKeyboardKey.keyK, LogicalKeyboardKey.control): _openCommandPalette,
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF000008),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        floatingActionButton: GestureDetector(
          onTap: _openSearch,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [SynapseTokens.primaryViolet, SynapseTokens.electricBlue],
              ),
              boxShadow: [
                BoxShadow(
                  color: SynapseTokens.electricBlue.withOpacity(0.4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 22),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore,
                    label: 'Scan',
                    isActive: _currentIndex == 0,
                    badgeCount: _notifService.scanAlerts,
                    onTap: () {
                      _notifService.clearTabAlerts(0);
                      setState(() => _currentIndex = 0);
                    },
                  ),
                  _NavItem(
                    icon: Icons.timeline_outlined,
                    activeIcon: Icons.timeline,
                    label: 'Memory',
                    isActive: _currentIndex == 1,
                    badgeCount: _notifService.memoryAlerts,
                    onTap: () {
                      _notifService.clearTabAlerts(1);
                      setState(() => _currentIndex = 1);
                    },
                  ),
                  _NavItem(
                    icon: Icons.bolt_outlined,
                    activeIcon: Icons.bolt,
                    label: 'Energy',
                    isActive: _currentIndex == 2,
                    badgeCount: _notifService.energyAlerts,
                    onTap: () {
                      _notifService.clearTabAlerts(2);
                      setState(() => _currentIndex = 2);
                    },
                  ),
                  _NavItem(
                    icon: Icons.auto_awesome_outlined,
                    activeIcon: Icons.auto_awesome,
                    label: 'AI',
                    isActive: _currentIndex == 3,
                    badgeCount: _notifService.aiAlerts,
                    onTap: () {
                      _notifService.clearTabAlerts(3);
                      setState(() => _currentIndex = 3);
                    },
                  ),
                  _NavItem(
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    label: 'Settings',
                    isActive: _currentIndex == 4,
                    badgeCount: 0,
                    onTap: () => setState(() => _currentIndex = 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: SynapseTokens.durationFast,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? SynapseTokens.electricBlue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NotificationBadge(
              count: badgeCount,
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive
                    ? SynapseTokens.electricBlue
                    : SynapseTokens.textTertiary,
                size: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? SynapseTokens.electricBlue
                    : SynapseTokens.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}