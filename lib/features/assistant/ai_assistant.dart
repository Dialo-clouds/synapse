import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class AIAssistant extends StatefulWidget {
  const AIAssistant({super.key});

  @override
  State<AIAssistant> createState() => _AIAssistantState();
}

class _AIAssistantState extends State<AIAssistant>
    with TickerProviderStateMixin {
  
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  
  late AnimationController _pulseController;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _smartResponses = [
    {
      'keywords': ['lights', 'light', 'brightness', 'dim', 'brighten'],
      'responses': [
        'I have adjusted the lighting. All lights in the current room are now optimized.',
        'Brightness adjusted. You are currently using 40% less energy than yesterday.',
        'Lights updated. Would you like me to set a schedule for automatic dimming?',
      ]
    },
    {
      'keywords': ['temperature', 'thermostat', 'hot', 'cold', 'warm', 'cool'],
      'responses': [
        'Temperature set to 22C. The room should feel comfortable in about 5 minutes.',
        'Climate control adjusted. I have activated eco mode to save energy.',
        'Your preferred temperature profile has been applied across all rooms.',
      ]
    },
    {
      'keywords': ['energy', 'power', 'consumption', 'bill', 'usage', 'cost'],
      'responses': [
        'Current energy usage: 3.2 kW. You are on track to stay under your monthly budget.',
        'Energy report: Solar is producing 4.1 kW. Your battery is at 72%. Estimated monthly savings: \$34.',
        'Your home is running at 68% efficiency. I have identified 3 devices that could be optimized.',
      ]
    },
    {
      'keywords': ['security', 'lock', 'locked', 'safe', 'secure', 'door'],
      'responses': [
        'All doors are locked. Security system is active. No unusual activity detected.',
        'Security status: Front door locked, garage secured. Last activity was 45 minutes ago.',
        'I have armed the perimeter. Motion sensors are active. You will be alerted if anything unusual occurs.',
      ]
    },
    {
      'keywords': ['sleep', 'goodnight', 'bed', 'night', 'evening'],
      'responses': [
        'Goodnight mode activated. Lights dimming, thermostat adjusting, all doors locking.',
        'Sleep well! I have set your alarm for 7:00 AM and will gradually brighten the lights at 6:30 AM.',
        'House secured for the night. Energy usage minimized. Sweet dreams.',
      ]
    },
    {
      'keywords': ['morning', 'good morning', 'wake', 'coffee', 'breakfast'],
      'responses': [
        'Good morning! Lights are gradually brightening. Coffee machine is preheating.',
        'Morning routine activated. Today is sunny with a high of 24C. Your first meeting is at 10 AM.',
        'Rise and shine! Your morning scene is active. Kitchen lights on, thermostat adjusting.',
      ]
    },
    {
      'keywords': ['scan', 'search', 'find', 'locate', 'where'],
      'responses': [
        'Scanning the room... I detected 6 active devices. 4 lights, 1 thermostat, and 1 speaker.',
        'I found 3 devices that need attention. The bedroom lamp has been on for 6 hours.',
        'Room scan complete. All systems are functioning normally. No issues detected.',
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _messages.add(_ChatMessage(
      text: 'Hello. I am Synapse AI. I can control your entire home. Try saying "Turn on the lights" or "Show energy usage".',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isProcessing = true;
    });
    _controller.clear();
    _scrollToBottom();

    final delayMs = 800 + Random().nextInt(1200);
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            text: _generateResponse(text),
            isUser: false,
          ));
          _isProcessing = false;
        });
        _scrollToBottom();
      }
    });
  }

  String _generateResponse(String query) {
    final lowerQuery = query.toLowerCase();
    final random = Random();

    for (var pattern in _smartResponses) {
      for (var keyword in pattern['keywords']) {
        if (lowerQuery.contains(keyword)) {
          final responses = pattern['responses'] as List<String>;
          return responses[random.nextInt(responses.length)];
        }
      }
    }

    final defaultResponses = [
      'I understand. Let me process that request for you.',
      'I have noted your preference. Is there anything else you would like to adjust?',
      'Processing complete. Your home is optimized based on your request.',
      'I can help with lights, temperature, energy monitoring, security, and more. Just ask!',
      'Command received. I am making the adjustments now.',
    ];

    return defaultResponses[random.nextInt(defaultResponses.length)];
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
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
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Synapse AI',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none),
                      ),
                      Text(
                        'Always listening',
                        style: TextStyle(fontSize: 11, color: SynapseTokens.auroraTeal.withOpacity(0.7), decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: SynapseTokens.auroraTeal.withOpacity((0.5 + _pulseController.value * 0.5).clamp(0.0, 1.0)),
                          boxShadow: [BoxShadow(color: SynapseTokens.auroraTeal.withOpacity(0.3), blurRadius: 8)],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Container(height: 1, color: Colors.white.withOpacity(0.04)),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isProcessing ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return const _TypingIndicator();
                  }
                  final message = _messages[index];
                  return _MessageBubble(message: message);
                },
              ),
            ),

            // Input bar
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: SynapseTokens.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: TextStyle(color: SynapseTokens.textTertiary),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_controller.text),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [SynapseTokens.primaryViolet, SynapseTokens.electricBlue]),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // Suggestions
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _SuggestionChip(label: 'Turn on all lights', onTap: () => _sendMessage('Turn on all lights')),
                  _SuggestionChip(label: 'Show energy usage', onTap: () => _sendMessage('Show energy usage')),
                  _SuggestionChip(label: 'Is the house secure?', onTap: () => _sendMessage('Is the house secure?')),
                  _SuggestionChip(label: 'Goodnight', onTap: () => _sendMessage('Goodnight')),
                  _SuggestionChip(label: 'Good morning', onTap: () => _sendMessage('Good morning')),
                  _SuggestionChip(label: 'Set temperature to 22', onTap: () => _sendMessage('Set temperature to 22')),
                ],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [SynapseTokens.electricBlue, SynapseTokens.auroraTeal]),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none))),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? SynapseTokens.electricBlue.withOpacity(0.15) 
                    : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: message.isUser 
                      ? SynapseTokens.electricBlue.withOpacity(0.2) 
                      : Colors.white.withOpacity(0.06),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 13.5,
                  color: message.isUser ? Colors.white : SynapseTokens.textSecondary,
                  height: 1.4,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: SynapseTokens.primaryViolet.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('U', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12, decoration: TextDecoration.none))),
            ),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: 10, end: 0);
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [SynapseTokens.electricBlue, SynapseTokens.auroraTeal]),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none))),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(), SizedBox(width: 4),
                _Dot(), SizedBox(width: 4),
                _Dot(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6, height: 6,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: SynapseTokens.textTertiary,
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
      .fadeOut(duration: const Duration(milliseconds: 600));
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, color: SynapseTokens.textSecondary, decoration: TextDecoration.none),
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