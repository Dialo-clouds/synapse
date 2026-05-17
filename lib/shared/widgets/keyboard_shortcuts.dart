import 'package:flutter/material.dart';

class KeyboardShortcutHandler extends StatelessWidget {
  final Widget child;
  final Map<LogicalKeySet, VoidCallback> shortcuts;

  const KeyboardShortcutHandler({
    super.key,
    required this.child,
    required this.shortcuts,
  });

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: shortcuts.map((keySet, callback) => MapEntry(keySet, callback)),
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}