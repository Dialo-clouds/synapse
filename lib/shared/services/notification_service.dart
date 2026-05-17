import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  int _scanAlerts = 0;
  int _memoryAlerts = 0;
  int _energyAlerts = 0;
  int _aiAlerts = 0;

  int get scanAlerts => _scanAlerts;
  int get memoryAlerts => _memoryAlerts;
  int get energyAlerts => _energyAlerts;
  int get aiAlerts => _aiAlerts;

  int getTabAlerts(int tabIndex) {
    switch (tabIndex) {
      case 0: return _scanAlerts;
      case 1: return _memoryAlerts;
      case 2: return _energyAlerts;
      case 3: return _aiAlerts;
      default: return 0;
    }
  }

  void addScanAlert() {
    _scanAlerts++;
    notifyListeners();
  }

  void addMemoryAlert() {
    _memoryAlerts++;
    notifyListeners();
  }

  void addEnergyAlert() {
    _energyAlerts++;
    notifyListeners();
  }

  void addAIAlert() {
    _aiAlerts++;
    notifyListeners();
  }

  void clearTabAlerts(int tabIndex) {
    switch (tabIndex) {
      case 0: _scanAlerts = 0; break;
      case 1: _memoryAlerts = 0; break;
      case 2: _energyAlerts = 0; break;
      case 3: _aiAlerts = 0; break;
    }
    notifyListeners();
  }
}