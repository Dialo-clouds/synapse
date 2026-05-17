import 'package:flutter/material.dart';
import '../object_detection/detection_service.dart';
import '../gestures/gesture_engine.dart';

class ARController extends ChangeNotifier {
  bool _isScanning = true;
  DetectedObject? _detectedObject;
  bool _isObjectActive = false;

  bool get isScanning => _isScanning;
  DetectedObject? get detectedObject => _detectedObject;
  bool get isObjectActive => _isObjectActive;

  void startScanning() {
    _isScanning = true;
    _detectedObject = null;
    _isObjectActive = false;
    notifyListeners();
  }

  void detectObject() {
    final obj = DetectionService.getObjectAt(DateTime.now().millisecond);
    _detectedObject = obj;
    _isScanning = false;
    _isObjectActive = true;
    notifyListeners();
  }

  void activateObject() {
    _isObjectActive = true;
    notifyListeners();
  }

  void deactivateObject() {
    _isObjectActive = false;
    notifyListeners();
  }

  void handleGesture(RecognizedGesture gesture) {
    switch (gesture.type) {
      case GestureType.point:
        activateObject();
        break;
      case GestureType.flick:
        deactivateObject();
        break;
      default:
        break;
    }
  }
}