import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../core/services/pocketbase_service.dart';

class GlobalSearch extends StatefulWidget {
  const GlobalSearch({super.key});

  @override
  State<GlobalSearch> createState() => _GlobalSearchState();
}

class _GlobalSearchState extends State<GlobalSearch> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _searching = false;

  void _search(String query) {
    if (query.length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() => _searching = true);
    
    final lowerQuery = query.toLowerCase();
    final allItems = <Map<String, dynamic>>[
      {'name': 'Living Room Light', 'type': 'Device', 'status': 'Active'},
      {'name': 'Bedroom Lamp', 'type': 'Device', 'status': 'Standby'},
      {'name': 'Thermostat', 'type': 'Climate', 'status': '22C'},
      {'name': 'TV', 'type': 'Entertainment', 'status': 'Off'},
      {'name': 'Speaker', 'type': 'Audio', 'status': 'Playing'},
      {'name': 'Front Door Lock', 'type': 'Security', 'status': 'Locked'},
      {'name': 'Coffee Machine', 'type': 'Appliance', 'status': 'Ready'},
      {'name': 'Living Room', 'type': 'Room', 'status': '6 devices'},
      {'name': 'Bedroom', 'type': 'Room', 'status': '3 devices'},
      {'name': 'Kitchen', 'type': 'Room', 'status': '4 devices'},
      {'name': 'Office', 'type': 'Room', 'status': '5 devices'},
      {'name': 'Energy Monitor', 'type': 'System', 'status': '3.2 kW'},
      {'name': 'Solar Panels', 'type': 'System', 'status': '4.1 kW'},
      {'name': 'Battery Storage', 'type': 'System', 'status': '72%'},
      {'name': 'AI Assistant', 'type': 'System', 'status': 'Online'},
      {'name': 'Security System', 'type': 'System', 'status': 'Armed'},
      {'name': 'Morning Scene', 'type': 'Scene', 'status': 'Ready'},
      {'name': 'Night Scene', 'type': 'Scene', 'status': 'Ready'},
      {'name': 'Away Mode', 'type': 'Scene', 'status': 'Ready'},
    ];

    setState(() {
      _results = allItems.where((item) {
        return item['name'].toString().toLowerCase().contains(lowerQuery) ||
               item['type'].toString().toLowerCase().contains(lowerQuery);
      }).toList();
      _searching = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(16, 16),
                          painter: _BackArrowPainter(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        onChanged: _search,
                        style: const TextStyle(color: SynapseTokens.textPrimary, fontSize: 15, decoration: TextDecoration.none),
                        decoration: InputDecoration(
                          hintText: 'Search devices, rooms, scenes...',
                          hintStyle: TextStyle(color: SynapseTokens.textTertiary, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: SynapseTokens.textTertiary, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Results
            Expanded(
              child: _controller.text.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.08), width: 2)),
                            child: const Icon(Icons.search, size: 32, color: SynapseTokens.textTertiary),
                          ),
                          const SizedBox(height: 16),
                          const Text('Search anything', style: TextStyle(fontSize: 16, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                          const SizedBox(height: 4),
                          Text('Devices, rooms, scenes, systems...', style: TextStyle(fontSize: 12, color: SynapseTokens.textTertiary.withOpacity(0.5), decoration: TextDecoration.none)),
                        ],
                      ),
                    )
                  : _results.isEmpty
                      ? Center(
                          child: Text('No results found', style: TextStyle(fontSize: 15, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final item = _results[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white.withOpacity(0.06)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40, height: 40,
                                    decoration: BoxDecoration(
                                      color: SynapseTokens.electricBlue.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(item['name'].toString().substring(0, 1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: SynapseTokens.electricBlue, decoration: TextDecoration.none)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                                        Text('${item['type']} \u2022 ${item['status']}', style: const TextStyle(fontSize: 11, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 14, color: SynapseTokens.textTertiary.withOpacity(0.4)),
                                ],
                              ),
                            ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideX(begin: 10, end: 0);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.65, size.height * 0.2)
      ..lineTo(size.width * 0.3, size.height * 0.5)
      ..lineTo(size.width * 0.65, size.height * 0.8);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BackArrowPainter oldDelegate) => false;
}