import 'package:flutter/services.dart';

class HapticService {
  static void light() {
    HapticFeedback.lightImpact();
  }

  static void medium() {
    HapticFeedback.mediumImpact();
  }

  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  static void success() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 80), HapticFeedback.lightImpact);
  }

  static void toggle(bool isOn) {
    if (isOn) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  static void scan() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 150), HapticFeedback.lightImpact);
    Future.delayed(const Duration(milliseconds: 300), HapticFeedback.lightImpact);
  }

  static void unlock() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 100), HapticFeedback.mediumImpact);
  }
}