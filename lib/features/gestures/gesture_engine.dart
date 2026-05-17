import 'package:flutter/material.dart';
import '../../core/tokens/synapse_tokens.dart';

enum GestureType {
  point,
  pinch,
  swipe,
  rotate,
  flick,
  circle,
  cross,
  hold,
}

class RecognizedGesture {
  final GestureType type;
  final Offset position;
  final double value;
  final double scale;

  RecognizedGesture({
    required this.type,
    this.position = Offset.zero,
    this.value = 0.0,
    this.scale = 1.0,
  });
}

class GestureEngine {
  static RecognizedGesture? recognize(DragUpdateDetails details) {
    final delta = details.delta;
    final distance = delta.distance;

    if (distance < 2) {
      return RecognizedGesture(type: GestureType.point, position: details.localPosition);
    } else if (distance < 10) {
      return RecognizedGesture(type: GestureType.swipe, position: details.localPosition, value: delta.dx);
    } else if (distance < 30) {
      return RecognizedGesture(type: GestureType.pinch, scale: 1.0 + delta.dy * 0.01);
    } else {
      return RecognizedGesture(type: GestureType.flick, position: details.localPosition);
    }
  }
}