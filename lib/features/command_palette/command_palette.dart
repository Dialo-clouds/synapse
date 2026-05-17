import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class CommandPalette extends StatefulWidget {
  final Function(String command)? onCommand;

  const CommandPalette({super.key, this.onCommand});

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  final TextEditingController _controller = TextEditingController();
  final List<_Command> _commands = [
    _Command(name: 'Scan Room', shortcut: 'Ctrl+1', icon: Icons.explore),
    _Command(name: 'View Memory', shortcut: 'Ctrl+2', icon: Icons.timeline),
    _Command(name: 'Show Energy', shortcut: 'Ctrl+3', icon: Icons.bolt),
    _Command(name: 'Open AI Chat', shortcut: 'Ctrl+4', icon: Icons.auto_awesome),
    _Command(name: 'Settings', shortcut: 'Ctrl+5', icon: Icons.settings),
    _Command(name: 'Search', shortcut: 'Ctrl+K', icon: Icons.search),
    _Command(name: 'Toggle Dark Mode', shortcut: 'Ctrl+D', icon: Icons.dark_mode),
    _Command(name: 'Export Data', shortcut: 'Ctrl+E', icon: Icons.download),
    _Command(name: 'Lock Screen', shortcut: 'Ctrl+L', icon: Icons.lock),
    _Command(name: 'Sign Out', shortcut: 'Ctrl+Q', icon: Icons.logout),
  ];

  List<_Command> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = _commands;
    _controller.addListener(_filter);
  }

  void _filter() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filtered = _commands.where((c) => c.name.toLowerCase().contains(query)).toList();
    });
  }

  void _execute(_Command command) {
    widget.onCommand?.call(command.name);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.none),
                    decoration: InputDecoration(
                      hintText: 'Type a command...',
                      hintStyle: TextStyle(color: SynapseTokens.textTertiary, fontSize: 15),
                      prefixIcon: const Icon(Icons.search, color: SynapseTokens.textTertiary, size: 20),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                Container(height: 1, color: Colors.white.withOpacity(0.06)),

                // Commands
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final command = _filtered[index];
                      return GestureDetector(
                        onTap: () => _execute(command),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: index == 0 ? SynapseTokens.electricBlue.withOpacity(0.1) : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(command.icon, color: SynapseTokens.electricBlue, size: 18),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(command.name, style: const TextStyle(fontSize: 14, color: Colors.white, decoration: TextDecoration.none)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(command.shortcut, style: TextStyle(fontSize: 10, color: SynapseTokens.textTertiary)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ).animate().scaleXY(begin: 0.95, end: 1.0).fadeIn(),
        ),
      ),
    );
  }
}

class _Command {
  final String name;
  final String shortcut;
  final IconData icon;
  const _Command({required this.name, required this.shortcut, required this.icon});
}