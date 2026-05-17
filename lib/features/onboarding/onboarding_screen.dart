import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../features/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      title: 'Point. Detect. Control.',
      subtitle: 'Point your camera at any object and Synapse instantly recognizes it, giving you full control.',
      gradient: const LinearGradient(colors: [SynapseTokens.primaryViolet, SynapseTokens.electricBlue]),
    ),
    _OnboardingSlide(
      title: 'Spatial Intelligence',
      subtitle: 'Your home becomes an interactive interface. Every room, every device responds to your presence.',
      gradient: const LinearGradient(colors: [SynapseTokens.electricBlue, SynapseTokens.auroraTeal]),
    ),
    _OnboardingSlide(
      title: 'Energy Aware',
      subtitle: 'See energy flowing through your home in real-time. Optimize usage and save money automatically.',
      gradient: const LinearGradient(colors: [SynapseTokens.auroraTeal, SynapseTokens.plasmaAmber]),
    ),
    _OnboardingSlide(
      title: 'AI Powered',
      subtitle: 'Talk to Synapse AI. Control everything with natural language. Your home understands you.',
      gradient: const LinearGradient(colors: [SynapseTokens.neuralPink, SynapseTokens.primaryViolet]),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onComplete() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: SynapseTokens.durationSlow,
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000008), Color(0xFF0A0020), Color(0xFF000008)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: _onComplete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Text(
                        'SKIP',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: SynapseTokens.textTertiary, letterSpacing: 1.5, decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ),
              ),

              // Slides
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) => _buildSlide(_slides[index], index),
                ),
              ),

              // Bottom
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slides.length, (index) {
                        return AnimatedContainer(
                          duration: SynapseTokens.durationFast,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: _currentPage == index ? _slides[index].gradient : null,
                            color: _currentPage == index ? null : Colors.white.withOpacity(0.1),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    // Button
                    GestureDetector(
                      onTap: () {
                        if (_currentPage < _slides.length - 1) {
                          _pageController.nextPage(
                            duration: SynapseTokens.durationNormal,
                            curve: SynapseTokens.easeOutExpo,
                          );
                        } else {
                          _onComplete();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: _slides[_currentPage].gradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: _slides[_currentPage].gradient.colors.first.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)],
                        ),
                        child: Center(
                          child: Text(
                            _currentPage == _slides.length - 1 ? 'GET STARTED' : 'NEXT',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.5, decoration: TextDecoration.none),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(_OnboardingSlide slide, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated orb
          Container(
            width: 160, height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [slide.gradient.colors.first.withOpacity(0.3), slide.gradient.colors.first.withOpacity(0.05), Colors.transparent]),
              boxShadow: [BoxShadow(color: slide.gradient.colors.first.withOpacity(0.3), blurRadius: 60, spreadRadius: 10)],
            ),
            child: Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: slide.gradient, boxShadow: [BoxShadow(color: slide.gradient.colors.first.withOpacity(0.5), blurRadius: 30)]),
              ),
            ),
          ).animate().scale(delay: Duration(milliseconds: index * 200)).fadeIn(),
          const SizedBox(height: 48),
          Text(slide.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: SynapseTokens.textPrimary, letterSpacing: 1, decoration: TextDecoration.none))
            .animate().fadeIn(delay: Duration(milliseconds: 400 + index * 200)).slideY(begin: 20, end: 0),
          const SizedBox(height: 16),
          Text(slide.subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: SynapseTokens.textTertiary, height: 1.5, decoration: TextDecoration.none))
            .animate().fadeIn(delay: Duration(milliseconds: 600 + index * 200)).slideY(begin: 20, end: 0),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  _OnboardingSlide({required this.title, required this.subtitle, required this.gradient});
}