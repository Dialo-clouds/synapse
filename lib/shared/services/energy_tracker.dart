import 'dart:math';
import '../../core/services/pocketbase_service.dart';

class EnergyTracker {
  static final Random _random = Random();
  
  static double get currentUsage => 2.0 + _random.nextDouble() * 4.0;
  static double get solarProduction => 3.0 + _random.nextDouble() * 3.0;
  static double get batteryLevel => 50 + _random.nextDouble() * 40;
  
  static Future<void> saveEnergySnapshot() async {
    await PocketBaseService.saveInteraction({
      'device_name': 'Energy System',
      'action': 'Snapshot: ${currentUsage.toStringAsFixed(1)}kW | Solar: ${solarProduction.toStringAsFixed(1)}kW | Battery: ${batteryLevel.toStringAsFixed(0)}%',
    });
  }
}