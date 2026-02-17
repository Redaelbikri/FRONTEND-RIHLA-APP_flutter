import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';
import '../../../data/api/hebergements_api.dart';
import '../../../data/models/hotel_model.dart';
import '../../../data/repositories/hotel_repository_impl.dart';
import 'hotel_booking_screen.dart';
import 'hotel_card.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final _cityCtrl = TextEditingController(text: 'Marrakech');

  late final HotelRepositoryImpl _repo;
  late Future<List<HotelModel>> _future;

  @override
  void initState() {
    super.initState();
    _repo = HotelRepositoryImpl(HebergementsApi());
    _future = _repo.getHotels(_cityCtrl.text);
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = _repo.getHotels(_cityCtrl.text);
    });
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
                  Colors.black.withValues(alpha: 0.14),
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.26),
                  Colors.black.withValues(alpha: 0.55),
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
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(18),
                        child: Glass(
                          padding: const EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(18),
                          opacity: 0.26,
                          blur: 18,
                          child: const Icon(Icons.chevron_left_rounded, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Glass(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          borderRadius: BorderRadius.circular(22),
                          opacity: 0.32,
                          blur: 18,
                          child: Row(
                            children: [
                              const Icon(Icons.hotel_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Hotels',
                                  style: t.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _reload,
                                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Glass(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    borderRadius: BorderRadius.circular(22),
                    opacity: 0.28,
                    blur: 18,
                    child: Row(
                      children: [
                        const Icon(Icons.location_city_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _cityCtrl,
                            style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search city',
                              hintStyle: t.titleMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.45),
                                fontWeight: FontWeight.w800,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (_) => _reload(),
                          ),
                        ),
                        TextButton(
                          onPressed: _reload,
                          child: Text('Search', style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: FutureBuilder<List<HotelModel>>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      }
                      if (snap.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snap.error}',
                            style: t.bodyLarge?.copyWith(color: Colors.white),
                          ),
                        );
                      }

                      final hotels = snap.data ?? const <HotelModel>[];
                      if (hotels.isEmpty) {
                        return Center(
                          child: Text(
                            'No hotels found',
                            style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w700),
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                        itemCount: hotels.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final h = hotels[i];
                          return HotelCard(
                            hotel: h,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HotelBookingScreen(hotel: h),
                                ),
                              );
                            },
                          ).animate().fadeIn(delay: (70 * i).ms).slideY(begin: 0.06, end: 0);
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
