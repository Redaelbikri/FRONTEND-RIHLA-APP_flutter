import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../data/api/notifications_api.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../data/services/api_client.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsRepository _repo;
  late Future<List<NotificationModel>> _future;

  @override
  void initState() {
    super.initState();
    _repo = NotificationsRepository(NotificationsApi());
    _future = _repo.mine();
  }

  void _reload() {
    setState(() => _future = _repo.mine());
  }

  IconData _iconFromType(String type) {
    switch (type.toUpperCase()) {
      case 'BOOKING':
      case 'TICKET':
        return Icons.confirmation_number_rounded;
      case 'PAYMENT':
        return Icons.payments_rounded;
      case 'EVENT':
        return Icons.local_activity_rounded;
      case 'SECURITY':
        return Icons.security_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '—';
    final now = DateTime.now();
    final d = now.difference(dt);

    if (d.inMinutes < 1) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';

    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    return '$dd/$mm';
  }

  Future<void> _markAsRead(NotificationModel n) async {
    if (n.read) return;
    try {
      await _repo.markRead(n.id);
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
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
                  Colors.black.withValues(alpha: 0.34),
                  Colors.black.withValues(alpha: 0.56),
                ],
              ),
            ),
          ),
          Positioned(
            top: -70,
            left: -40,
            child: _BlurBlob(size: 260, color: RihlaColors.accent.withValues(alpha: 0.14)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                          ),
                          child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Glass(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        borderRadius: BorderRadius.circular(18),
                        opacity: 0.30,
                        blur: 18,
                        child: Text(
                          'Notifications',
                          style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
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
                ),
                Expanded(
                  child: FutureBuilder<List<NotificationModel>>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        final msg = snap.error is ApiException
                            ? (snap.error as ApiException).message
                            : 'Failed to load notifications';
                        return Center(
                          child: Glass(
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
                          ),
                        );
                      }

                      final items = snap.data ?? const <NotificationModel>[];
                      if (items.isEmpty) {
                        return Center(
                          child: Glass(
                            padding: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(26),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('No notifications.', style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 10),
                                TextButton(onPressed: _reload, child: const Text('Refresh')),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final n = items[i];
                          final icon = _iconFromType(n.type);

                          return Glass(
                            padding: const EdgeInsets.all(14),
                            borderRadius: BorderRadius.circular(26),
                            opacity: 0.34,
                            blur: 18,
                            child: InkWell(
                              onTap: () => _markAsRead(n),
                              borderRadius: BorderRadius.circular(26),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      gradient: RihlaColors.premiumGradient,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Icon(icon, color: Colors.white, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                n.title,
                                                style: t.titleMedium?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            if (!n.read)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFFD58A),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          n.message,
                                          style: t.bodyMedium?.copyWith(
                                            color: Colors.white.withValues(alpha: 0.84),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _timeAgo(n.createdAt),
                                    style: t.labelMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.70),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: (70 * i).ms, duration: 320.ms)
                              .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
                        },
                      );
                    },
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
