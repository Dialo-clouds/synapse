import 'dart:math';

class DetectedObject {
  final String id;
  final String name;
  final String type;
  final double confidence;
  final double x;
  final double y;

  DetectedObject({
    required this.id,
    required this.name,
    required this.type,
    required this.confidence,
    required this.x,
    required this.y,
  });
}

class DetectionService {
  static final Random _random = Random();

  static final List<Map<String, dynamic>> _knownObjects = [
    {'name': 'Living Room Light', 'type': 'light', 'id': 'light_1'},
    {'name': 'Bedroom Lamp', 'type': 'light', 'id': 'light_2'},
    {'name': 'Thermostat', 'type': 'climate', 'id': 'thermo_1'},
    {'name': 'TV', 'type': 'entertainment', 'id': 'tv_1'},
    {'name': 'Speaker', 'type': 'music', 'id': 'speaker_1'},
    {'name': 'Front Door Lock', 'type': 'lock', 'id': 'lock_1'},
    {'name': 'Coffee Machine', 'type': 'appliance', 'id': 'coffee_1'},
    {'name': 'Window Blinds', 'type': 'blinds', 'id': 'blinds_1'},
  ];

  static DetectedObject? detect() {
    if (_random.nextDouble() > 0.85) {
      final obj = _knownObjects[_random.nextInt(_knownObjects.length)];
      return DetectedObject(
        id: obj['id'],
        name: obj['name'],
        type: obj['type'],
        confidence: 0.75 + _random.nextDouble() * 0.25,
        x: 0.3 + _random.nextDouble() * 0.4,
        y: 0.3 + _random.nextDouble() * 0.4,
      );
    }
    return null;
  }

  static DetectedObject getObjectAt(int index) {
    final obj = _knownObjects[index % _knownObjects.length];
    return DetectedObject(
      id: obj['id'],
      name: obj['name'],
      type: obj['type'],
      confidence: 0.85 + _random.nextDouble() * 0.15,
      x: 0.4 + _random.nextDouble() * 0.2,
      y: 0.4 + _random.nextDouble() * 0.2,
    );
  }
}