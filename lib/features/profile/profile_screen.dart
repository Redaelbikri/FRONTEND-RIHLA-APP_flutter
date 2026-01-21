import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/nav/app_router.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/cards.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/backgrounds/home_bg.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.06),
                  Colors.black.withValues(alpha: 0.28),
                  Colors.black.withValues(alpha: 0.44),
                ],
              ),
            ),
          ),
          Positioned(
            top: -70,
            left: -40,
            child: _BlurBlob(size: 260, color: RihlaColors.accent.withValues(alpha: 0.14)),
          ),
          Positioned(
            bottom: -90,
            right: -50,
            child: _BlurBlob(size: 300, color: RihlaColors.primary.withValues(alpha: 0.13)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Glass(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    borderRadius: BorderRadius.circular(18),
                    opacity: 0.34,
                    blur: 18,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Profile',
                          style: t.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),


                  Glass(
                    padding: const EdgeInsets.all(18),
                    borderRadius: BorderRadius.circular(30),
                    opacity: 0.40,
                    blur: 20,
                    child: Row(
                      children: [
                        _Avatar(),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REDA',
                                style: t.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'reda@rihla.app',
                                style: t.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.84),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: const [
                                  _MiniChip(icon: Icons.verified_rounded, text: 'Premium Vibe'),
                                  _MiniChip(icon: Icons.location_on_rounded, text: 'Morocco'),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 260.ms)
                      .slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 16),

                  Text(
                    'Quick actions',
                    style: t.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SoftTile(
                    icon: Icons.edit_rounded,
                    title: 'Edit profile',
                    subtitle: 'Update your identity and preferences',
                    onTap: () => Navigator.pushNamed(context, Routes.editProfile),
                  )
                      .animate()
                      .fadeIn(delay: 80.ms, duration: 320.ms)
                      .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 12),

                  SoftTile(
                    icon: Icons.notifications_rounded,
                    title: 'Notifications',
                    subtitle: 'Reminders, saves, and recommendations',
                    onTap: () => Navigator.pushNamed(context, Routes.notifications),
                  )
                      .animate()
                      .fadeIn(delay: 140.ms, duration: 320.ms)
                      .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 12),

                  SoftTile(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    subtitle: 'Theme, language, and about',
                    onTap: () => Navigator.pushNamed(context, Routes.settings),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 320.ms)
                      .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 12),

                  SoftTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Return to login screen',
                    onTap: () => _logout(context),
                  )
                      .animate()
                      .fadeIn(delay: 260.ms, duration: 320.ms)
                      .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 18),

                  Glass(
                    padding: const EdgeInsets.all(16),
                    borderRadius: BorderRadius.circular(28),
                    opacity: 0.30,
                    blur: 18,
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: RihlaColors.premiumGradient,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your experience',
                                style: t.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'RIHLA is designed to feel premium, smooth, and culturally inspired.',
                                style: t.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.84),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 320.ms, duration: 320.ms)
                      .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        boxShadow: const [
          BoxShadow(
            color: RihlaColors.shadow,
            blurRadius: 22,
            offset: Offset(0, 14),
          )
        ],
        image: const DecorationImage(
          image: AssetImage('assets/avatars/user.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: t.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
