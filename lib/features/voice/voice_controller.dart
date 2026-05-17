import 'dart:async';

class VoiceCommand {
  final String raw;
  final String action;
  final String? target;
  final double? value;

  VoiceCommand({
    required this.raw,
    required this.action,
    this.target,
    this.value,
  });
}

class VoiceController {
  static final List<Map<String, dynamic>> _commandPatterns = [
    {'patterns': ['turn on', 'switch on', 'activate'], 'action': 'toggle_on'},
    {'patterns': ['turn off', 'switch off', 'deactivate', 'shut down'], 'action': 'toggle_off'},
    {'patterns': ['brightness', 'dim', 'brighten'], 'action': 'set_brightness'},
    {'patterns': ['temperature', 'warmer', 'cooler'], 'action': 'set_temperature'},
    {'patterns': ['lock', 'secure'], 'action': 'lock'},
    {'patterns': ['unlock', 'open'], 'action': 'unlock'},
    {'patterns': ['scan', 'search', 'find'], 'action': 'scan'},
    {'patterns': ['goodnight', 'good night', 'sleep'], 'action': 'scene_night'},
    {'patterns': ['good morning', 'wake up'], 'action': 'scene_morning'},
    {'patterns': ['energy', 'power', 'consumption'], 'action': 'show_energy'},
    {'patterns': ['what is', 'whats', 'status'], 'action': 'status'},
  ];

  static final List<String> _responses = [
    'Got it.',
    'Done.',
    'Executing.',
    'On it.',
    'Synapse confirmed.',
    'Command received.',
    'Processing.',
  ];

  static VoiceCommand? parseCommand(String text) {
    final lower = text.toLowerCase().trim();
    
    for (var pattern in _commandPatterns) {
      for (var phrase in pattern['patterns']) {
        if (lower.contains(phrase)) {
          double? value;
          
          final percentMatch = RegExp(r'(\d+)%');
          final degreesMatch = RegExp(r'(\d+)\s*(degrees|°|celsius|c)');
          
          if (percentMatch.hasMatch(lower)) {
            value = int.parse(percentMatch.firstMatch(lower)!.group(1)!) / 100.0;
          } else if (degreesMatch.hasMatch(lower)) {
            value = int.parse(degreesMatch.firstMatch(lower)!.group(1)!).toDouble();
          }

          return VoiceCommand(
            raw: text,
            action: pattern['action'],
            target: null,
            value: value,
          );
        }
      }
    }
    return null;
  }

  static String getRandomResponse() {
    _responses.shuffle();
    return _responses.first;
  }

  static List<String> getSuggestions() {
    return [
      'Turn on the lights',
      'Set brightness to 50%',
      'What is the temperature?',
      'Lock the front door',
      'Show energy usage',
      'Goodnight',
      'Scan the room',
      'Turn off everything',
    ];
  }
}