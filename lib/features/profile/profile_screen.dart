import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/nav/app_router.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/cards.dart';
import '../../data/services/auth_api.dart';
import '../../data/services/api_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserMe> _future;

  @override
  void initState() {
    super.initState();
    _future = AuthApi().me();
  }

  void _reload() {
    setState(() => _future = AuthApi().me());
  }

  Future<void> _logout() async {
    await AuthApi().logout();
    if (!mounted) return;
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
                  Row(
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
                      const Spacer(),
                      TextButton(
                        onPressed: _reload,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          backgroundColor: Colors.white.withValues(alpha: 0.10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: Text('Refresh', style: t.labelLarge?.copyWith(fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  FutureBuilder<UserMe>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: Padding(padding: EdgeInsets.all(18), child: CircularProgressIndicator()));
                      }
                      if (snap.hasError) {
                        final msg = snap.error is ApiException ? (snap.error as ApiException).message : 'Failed to load profile';
                        return Glass(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(26),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(msg, style: const TextStyle(color: Colors.white)),
                              const SizedBox(height: 10),
                              TextButton(onPressed: _reload, child: const Text('Retry')),
                            ],
                          ),
                        );
                      }

                      final me = snap.data!;
                      final fullName = '${me.prenom} ${me.nom}'.trim();

                      return Glass(
                        padding: const EdgeInsets.all(18),
                        borderRadius: BorderRadius.circular(30),
                        opacity: 0.40,
                        blur: 20,
                        child: Row(
                          children: [
                            const _Avatar(),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fullName.isEmpty ? 'User' : fullName,
                                    style: t.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    me.email,
                                    style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.84), fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      const _MiniChip(icon: Icons.verified_rounded, text: 'Account'),
                                      if ((me.telephone ?? '').trim().isNotEmpty)
                                        _MiniChip(icon: Icons.phone_rounded, text: me.telephone!.trim()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic);
                    },
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Quick actions',
                    style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),

                  SoftTile(
                    icon: Icons.edit_rounded,
                    title: 'Edit profile',
                    subtitle: 'Update your identity and preferences',
                    onTap: () async {
                      final changed = await Navigator.pushNamed(context, Routes.editProfile);
                      if (changed == true) _reload();
                    },
                  ).animate().fadeIn(delay: 80.ms, duration: 320.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 12),

                  SoftTile(
                    icon: Icons.notifications_rounded,
                    title: 'Notifications',
                    subtitle: 'Connected to backend',
                    onTap: () => Navigator.pushNamed(context, Routes.notifications),
                  ).animate().fadeIn(delay: 140.ms, duration: 320.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 12),

                  SoftTile(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    subtitle: 'Theme, language, and about',
                    onTap: () => Navigator.pushNamed(context, Routes.settings),
                  ).animate().fadeIn(delay: 200.ms, duration: 320.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 12),

                  SoftTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Clears token + returns to login',
                    onTap: _logout,
                  ).animate().fadeIn(delay: 260.ms, duration: 320.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
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
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        boxShadow: const [BoxShadow(color: RihlaColors.shadow, blurRadius: 22, offset: Offset(0, 14))],
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
            style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.92), fontWeight: FontWeight.w900),
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
