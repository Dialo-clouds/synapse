import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:io';
import '../core/tokens/synapse_tokens.dart';

class FaviconGenerator {
  static Future<void> generate() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = const Size(192, 192);
    
    // Background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0A0020), Color(0xFF000008)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    
    // Orb
    final center = Offset(size.width / 2, size.height / 2);
    final orbPaint = Paint()
      ..shader = RadialGradient(
        colors: [SynapseTokens.electricBlue, SynapseTokens.primaryViolet],
      ).createShader(Rect.fromCircle(center: center, radius: 60));
    canvas.drawCircle(center, 60, orbPaint);
    
    // Inner ring
    canvas.drawCircle(center, 35, Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(center, 8, Paint()..color = Colors.white);
    
    final picture = recorder.endRecording();
    final img = await picture.toImage(192, 192);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    
    final file = File('web/favicon.png');
    await file.writeAsBytes(byteData!.buffer.asUint8List());
    
    // Also create icons folder
    Directory('web/icons').createSync();
    final icon192 = File('web/icons/Icon-192.png');
    await icon192.writeAsBytes(byteData.buffer.asUint8List());
    final icon512 = File('web/icons/Icon-512.png');
    final largeImg = await picture.toImage(512, 512);
    final largeData = await largeImg.toByteData(format: ui.ImageByteFormat.png);
    await icon512.writeAsBytes(largeData!.buffer.asUint8List());
  }
}