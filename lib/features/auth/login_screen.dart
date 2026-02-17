import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/nav/app_router.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';
import '../../core/ui/rihla_field.dart';

import '../../data/services/auth_api.dart';
import '../../data/services/api_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: '');
  final _pass = TextEditingController(text: '');
  bool _hide = true;

  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _goShell() {
    Navigator.pushReplacementNamed(context, Routes.shell);
  }

  void _goSignUp() {
    Navigator.pushNamed(context, Routes.signup);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _login() async {
    final email = _email.text.trim();
    final pass = _pass.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _toast('Please enter a valid email.');
      return;
    }
    if (pass.isEmpty) {
      _toast('Please enter your password.');
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthApi().login(email: email, password: pass);

      if (!mounted) return;
      _goShell();
    } catch (e) {
      final msg = (e is ApiException) ? e.message : 'Login failed';
      if (!mounted) return;
      _toast(msg);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/backgrounds/auth_bg.jpg', fit: BoxFit.cover),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.28),
                  Colors.black.withValues(alpha: 0.14),
                  Colors.black.withValues(alpha: 0.60),
                ],
              ),
            ),
          ),

          Positioned(
            top: -70,
            left: -40,
            child: _BlurBlob(size: 240, color: RihlaColors.accent.withValues(alpha: 0.16)),
          ),
          Positioned(
            bottom: -90,
            right: -50,
            child: _BlurBlob(size: 280, color: RihlaColors.primary.withValues(alpha: 0.14)),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    children: [
                      _BackPill(
                        onTap: () => Navigator.pop(context),
                        label: 'Back',
                      ),
                      const Spacer(),
                      Glass(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        borderRadius: BorderRadius.circular(18),
                        opacity: 0.30,
                        blur: 18,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/brand/logo_mark.png', width: 18, height: 18),
                            const SizedBox(width: 8),
                            Text(
                              'RIHLA',
                              style: t.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Glass(
                          padding: const EdgeInsets.all(18),
                          borderRadius: BorderRadius.circular(30),
                          opacity: 0.42,
                          blur: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: t.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Sign in to continue your journeys and curated events.',
                                style: t.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.86),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),

                              RihlaField(
                                label: 'Email',
                                hint: 'you@example.com',
                                icon: Icons.alternate_email_rounded,
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              RihlaField(
                                label: 'Password',
                                hint: '••••••••',
                                icon: Icons.lock_rounded,
                                controller: _pass,
                                obscure: _hide,
                                trailing: IconButton(
                                  onPressed: () => setState(() => _hide = !_hide),
                                  icon: Icon(
                                    _hide ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                    color: RihlaColors.primaryDark.withValues(alpha: 0.85),
                                    size: 20,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'By continuing, you accept our Terms & Privacy.',
                                      style: t.labelMedium?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.78),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      backgroundColor: Colors.white.withValues(alpha: 0.10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Help',
                                      style: t.labelLarge?.copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              PrimaryButton(
                                text: _loading ? 'Signing in...' : 'Sign In',
                                icon: Icons.arrow_forward_rounded,
                                onTap: _loading ? null : _login,
                              ),

                              const SizedBox(height: 12),

                              PrimaryButton(
                                text: 'Create an account',
                                icon: Icons.person_add_alt_1_rounded,
                                isSecondary: true,
                                onTap: _loading ? null : _goSignUp,
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 260.ms)
                            .slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackPill extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const _BackPill({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: t.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlurBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
