import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/nav/app_router.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';
import '../../core/ui/rihla_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _name = TextEditingController(text: '');
  final _email = TextEditingController(text: '');
  final _pass = TextEditingController(text: '');
  bool _hide = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _goLogin() {
    Navigator.pop(context);
  }

  void _create() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.shell, (r) => false);
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
            right: -40,
            child: _BlurBlob(size: 240, color: RihlaColors.accent.withValues(alpha: 0.16)),
          ),
          Positioned(
            bottom: -90,
            left: -50,
            child: _BlurBlob(size: 280, color: RihlaColors.primary.withValues(alpha: 0.14)),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    children: [
                      _BackPill(
                        onTap: _goLogin,
                        label: 'Login',
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
                                'Create your account',
                                style: t.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Start building trips and exploring curated events.',
                                style: t.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.86),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),

                              RihlaField(
                                label: 'Full name',
                                hint: 'Your name',
                                icon: Icons.person_rounded,
                                controller: _name,
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(height: 12),
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

                              Text(
                                'We keep your data private. You can change preferences anytime.',
                                style: t.labelMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.78),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 12),

                              PrimaryButton(
                                text: 'Create account',
                                icon: Icons.check_circle_rounded,
                                onTap: _create,
                              ),

                              const SizedBox(height: 12),

                              PrimaryButton(
                                text: 'I already have an account',
                                icon: Icons.login_rounded,
                                isSecondary: true,
                                onTap: _goLogin,
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
