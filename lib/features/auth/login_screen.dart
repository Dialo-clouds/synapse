import 'package:flutter/material.dart';
import '../../core/tokens/synapse_tokens.dart';
import '../../core/services/pocketbase_service.dart';
import '../../app/home_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_isLogin) {
        await PocketBaseService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await PocketBaseService.signUp(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        await PocketBaseService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: SynapseTokens.durationSlow,
            pageBuilder: (_, __, ___) => const HomeShell(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('ClientException: ', ''));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000008),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SYNAPSE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w200,
                    color: SynapseTokens.electricBlue.withOpacity(0.9),
                    letterSpacing: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Spatial Intelligence',
                  style: TextStyle(
                    fontSize: 11,
                    color: SynapseTokens.primaryViolet.withOpacity(0.7),
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 48),

                if (!_isLogin) ...[
                  _GlassInput(controller: _nameController, hint: 'Full Name', icon: Icons.person_outline),
                  const SizedBox(height: 12),
                ],

                _GlassInput(controller: _emailController, hint: 'Email', icon: Icons.email_outlined),
                const SizedBox(height: 12),
                _GlassInput(controller: _passwordController, hint: 'Password', icon: Icons.lock_outline, obscure: true),

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: SynapseTokens.neuralPink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SynapseTokens.neuralPink.withOpacity(0.3)),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(fontSize: 12, color: SynapseTokens.neuralPink.withOpacity(0.8)),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                GestureDetector(
                  onTap: _loading ? null : _submit,
                  child: Opacity(
                    opacity: _loading ? 0.5 : 1.0,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [SynapseTokens.primaryViolet, SynapseTokens.electricBlue],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: SynapseTokens.electricBlue.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                _isLogin ? 'SIGN IN' : 'CREATE ACCOUNT',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin ? "Don't have an account? Sign up" : 'Already have an account? Sign in',
                    style: TextStyle(fontSize: 13, color: SynapseTokens.textTertiary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;

  const _GlassInput({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: SynapseTokens.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: SynapseTokens.textTertiary),
          prefixIcon: Icon(icon, color: SynapseTokens.textTertiary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}