import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:rihla2026/core/theme/rihla_colors.dart';
import 'package:rihla2026/core/ui/glass.dart';

import 'package:rihla2026/data/models/event_model.dart';
import 'package:rihla2026/data/api/events_api.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _selectedCategory = 0;

  final List<String> _categories = const [
    'All',
    'Culture',
    'Food',
    'Music',
    'Art',
    'Nature',
    'Sport',
  ];

  final EventsApi _api = EventsApi();
  late Future<List<EventModel>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = _api.getAll(); // ✅ backend: GET /api/events
  }

  List<EventModel> _filter(List<EventModel> events) {
    if (_selectedCategory == 0) return events;
    final cat = _categories[_selectedCategory];
    return events.where((e) => (e.categorie ?? '').trim() == cat).toList();
  }

  ImageProvider _imageProvider(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return const AssetImage('assets/events/event_1.jpg');

    // URL image (backend)
    if (s.startsWith('http://') || s.startsWith('https://')) {
      return NetworkImage(s);
    }

    // Asset
    if (s.startsWith('assets/')) {
      return AssetImage(s);
    }

    // fallback
    return const AssetImage('assets/events/event_1.jpg');
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
                  Colors.black.withValues(alpha: 0.30),
                  Colors.black.withValues(alpha: 0.62),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Glass(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    borderRadius: BorderRadius.circular(22),
                    opacity: 0.32,
                    blur: 18,
                    child: Row(
                      children: [
                        const Icon(Icons.event_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Events',
                          style: t.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Curated nearby',
                          style: t.labelLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 54,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final active = i == _selectedCategory;
                      return InkWell(
                        onTap: () => setState(() => _selectedCategory = i),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.white.withValues(alpha: 0.18)
                                : Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: active
                                  ? Colors.white.withValues(alpha: 0.28)
                                  : Colors.white.withValues(alpha: 0.14),
                            ),
                          ),
                          child: Text(
                            _categories[i],
                            style: t.labelLarge?.copyWith(
                              color: Colors.white.withValues(alpha: active ? 0.92 : 0.82),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Expanded(
                  child: FutureBuilder<List<EventModel>>(
                    future: _futureEvents,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Failed to load events.\n${snap.error}',
                              textAlign: TextAlign.center,
                              style: t.bodyLarge?.copyWith(color: Colors.white),
                            ),
                          ),
                        );
                      }

                      final items = _filter(snap.data ?? const <EventModel>[]);
                      if (items.isEmpty) {
                        return Center(
                          child: Text(
                            'No events found.',
                            style: t.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _EventCard(
                          event: items[i],
                          imageProvider: _imageProvider,
                        )
                            .animate()
                            .fadeIn(delay: (60 * i).ms, duration: 260.ms)
                            .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
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

class _EventCard extends StatelessWidget {
  final EventModel event;
  final ImageProvider Function(String raw) imageProvider;

  const _EventCard({
    required this.event,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    // ✅ fields that exist in your EventModel:
    final title = (event.nom ?? 'Event').trim();
    final cat = (event.categorie ?? 'General').trim();
    final place = (event.lieu ?? 'Morocco').trim();
    final img = (event.imageUrl ?? '').trim();

    return Glass(
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(26),
      opacity: 0.34,
      blur: 18,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image(
              image: imageProvider(img),
              width: 112,
              height: 112,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$cat • $place',
                  style: t.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                      ),
                      child: Text(
                        'Details',
                        style: t.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.90),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white),
                  ],
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
