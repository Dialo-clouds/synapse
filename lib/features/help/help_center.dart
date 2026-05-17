import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                      child: const Center(child: Icon(Icons.arrow_back, color: SynapseTokens.textSecondary, size: 20)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text('Help Center', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                ],
              ),

              const SizedBox(height: 24),

              // Search
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search help articles...',
                    hintStyle: TextStyle(color: SynapseTokens.textTertiary),
                    prefixIcon: Icon(Icons.search, color: SynapseTokens.textTertiary, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // FAQ
              const Text('FREQUENTLY ASKED', style: TextStyle(fontSize: 10, letterSpacing: 2, color: SynapseTokens.textTertiary, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
              const SizedBox(height: 12),
              _FaqCard(question: 'How do I add a new device?', answer: 'Point your camera at the device and Synapse will automatically detect it. You can also manually add devices from Settings.'),
              _FaqCard(question: 'How does energy monitoring work?', answer: 'Synapse tracks energy usage across all connected devices in real-time. Go to the Energy tab for detailed analytics.'),
              _FaqCard(question: 'Can multiple users control devices?', answer: 'Yes! Go to Admin Tools > User Management to add team members with different permission levels.'),
              _FaqCard(question: 'Is my data secure?', answer: 'All data is encrypted end-to-end. You can export or delete your data anytime from Settings.'),
              _FaqCard(question: 'How do I set up schedules?', answer: 'Go to Device Scheduler from Settings. You can automate lights, thermostat, and appliances.'),
              _FaqCard(question: 'What voice commands work?', answer: 'Try saying "Turn on lights", "Set temperature to 22", "Show energy usage", or "Goodnight".'),

              const SizedBox(height: 24),

              // Contact
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [SynapseTokens.primaryViolet.withOpacity(0.2), SynapseTokens.electricBlue.withOpacity(0.05)]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: SynapseTokens.electricBlue.withOpacity(0.15)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.support_agent, color: SynapseTokens.electricBlue, size: 32),
                    const SizedBox(height: 12),
                    const Text('Need more help?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, decoration: TextDecoration.none)),
                    const SizedBox(height: 4),
                    Text('Our support team is available 24/7', style: TextStyle(fontSize: 12, color: SynapseTokens.textTertiary, decoration: TextDecoration.none)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ContactButton(label: 'Email', icon: Icons.email),
                        const SizedBox(width: 12),
                        _ContactButton(label: 'Chat', icon: Icons.chat),
                        const SizedBox(width: 12),
                        _ContactButton(label: 'Docs', icon: Icons.menu_book),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqCard extends StatefulWidget {
  final String question, answer;
  const _FaqCard({required this.question, required this.answer});

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: SynapseTokens.durationFast,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_expanded ? 0.04 : 0.02),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(_expanded ? 0.08 : 0.04)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(widget.question, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _expanded ? SynapseTokens.electricBlue : SynapseTokens.textPrimary, decoration: TextDecoration.none)),
                ),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: SynapseTokens.textTertiary, size: 20),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 10),
              Text(widget.answer, style: TextStyle(fontSize: 13, color: SynapseTokens.textSecondary, height: 1.5, decoration: TextDecoration.none)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ContactButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: SynapseTokens.electricBlue, size: 16),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: SynapseTokens.textPrimary, decoration: TextDecoration.none)),
          ],
        ),
      ),
    );
  }
}