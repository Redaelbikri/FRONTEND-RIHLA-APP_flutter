import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';
import 'hotel_models.dart';
import 'hotel_card.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final cityCtrl = TextEditingController(text: 'Marrakech');
  DateTime _checkIn = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 3));

  @override
  void dispose() {
    cityCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm';
  }

  Future<void> _pickDates() async {

    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: RihlaColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkIn = picked;
        _checkOut = picked.add(const Duration(days: 2));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final hotels = HotelMock.hotels(cityCtrl.text.trim().isEmpty ? 'Marrakech' : cityCtrl.text.trim());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/backgrounds/hotels_bg.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.30),
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.70),
                ],
              ),
            ),
          ),

          Positioned(
            top: -90,
            left: -70,
            child: _BlurBlob(size: 320, color: RihlaColors.accent.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: -130,
            right: -90,
            child: _BlurBlob(size: 420, color: RihlaColors.primary.withValues(alpha: 0.12)),
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                          ),
                          child: const Icon(Icons.chevron_left_rounded, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Glass(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          borderRadius: BorderRadius.circular(22),
                          opacity: 0.36,
                          blur: 18,
                          child: Row(
                            children: [
                              Text(
                                'Hotels • ${cityCtrl.text.isEmpty ? 'Marrakech' : cityCtrl.text}',
                                style: t.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                                ),
                                child: const Icon(Icons.filter_alt_rounded, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      _CityAndDatesRow(
                        cityCtrl: cityCtrl,
                        checkIn: _checkIn,
                        checkOut: _checkOut,
                        fmt: _fmt,
                        onPickDates: _pickDates,
                        onApply: () => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      _HotelQuickFilters(),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                    itemCount: hotels.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final h = hotels[i];
                      return HotelCard(
                        h: h,
                        onTap: () => _openHotelSheet(context, h),
                      );
                    },
                  ).animate().fadeIn(duration: 240.ms),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openHotelSheet(BuildContext context, Hotel h) {
    final t = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Glass(
            padding: const EdgeInsets.all(14),
            borderRadius: BorderRadius.circular(28),
            opacity: 0.52,
            blur: 18,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      h.image,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 170,
                        alignment: Alignment.center,
                        color: Colors.white.withValues(alpha: 0.10),
                        child: const Icon(Icons.hotel_rounded, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          h.name,
                          style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        h.rating.toStringAsFixed(1),
                        style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${h.city} • ${h.reviewsCount} reviews',
                    style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.78), fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: h.tags.map((e) => _Tag(text: e)).toList(),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Top Reviews',
                    style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),

                  ...h.reviews.take(2).map((rv) => _ReviewTile(r: rv)),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${h.priceMadPerNight} MAD / night',
                          style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Booked: ${h.name} (UI only)'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          backgroundColor: RihlaColors.primary.withValues(alpha: 0.85),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Book', style: t.labelLarge?.copyWith(fontWeight: FontWeight.w900)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.08, end: 0),
        );
      },
    );
  }
}

class _CityAndDatesRow extends StatelessWidget {
  final TextEditingController cityCtrl;
  final DateTime checkIn;
  final DateTime checkOut;
  final String Function(DateTime) fmt;
  final VoidCallback onPickDates;
  final VoidCallback onApply;

  const _CityAndDatesRow({
    required this.cityCtrl,
    required this.checkIn,
    required this.checkOut,
    required this.fmt,
    required this.onPickDates,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    Widget pill({required IconData icon, required Widget child, VoidCallback? onTap}) {
      final w = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(child: child),
          ],
        ),
      );

      if (onTap == null) return w;
      return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: w);
    }

    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Glass(
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(24),
            opacity: 0.40,
            blur: 18,
            child: Column(
              children: [
                pill(
                  icon: Icons.location_city_rounded,
                  child: TextField(
                    controller: cityCtrl,
                    style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'City (ex: Marrakech)',
                      hintStyle: t.titleSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onChanged: (_) => onApply(),
                  ),
                ),
                const SizedBox(height: 10),
                pill(
                  icon: Icons.date_range_rounded,
                  onTap: onPickDates,
                  child: Text(
                    '${fmt(checkIn)}  →  ${fmt(checkOut)}',
                    style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),

        Expanded(
          flex: 3,
          child: InkWell(
            onTap: onApply,
            borderRadius: BorderRadius.circular(26),
            child: Container(
              height: 122,
              decoration: BoxDecoration(
                gradient: RihlaColors.premiumGradient,
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [
                  BoxShadow(color: RihlaColors.shadow, blurRadius: 18, offset: Offset(0, 12)),
                ],
              ),
              child: const Center(
                child: Icon(Icons.search_rounded, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HotelQuickFilters extends StatefulWidget {
  @override
  State<_HotelQuickFilters> createState() => _HotelQuickFiltersState();
}

class _HotelQuickFiltersState extends State<_HotelQuickFilters> {
  int active = 0;
  final items = const ['Recommended', 'Top rated', 'Best value'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length, (i) {
        final isActive = i == active;
        return Expanded(
          child: InkWell(
            onTap: () => setState(() => active = i),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              margin: EdgeInsets.only(right: i == items.length - 1 ? 0 : 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.white.withValues(alpha: 0.22) : Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: isActive ? 0.20 : 0.12)),
              ),
              child: Center(
                child: Text(
                  items[i],
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final HotelReview r;
  const _ReviewTile({required this.r});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          r.name,
                          style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        r.rating.toStringAsFixed(1),
                        style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        r.timeAgo,
                        style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.70), fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r.comment,
                    style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.84), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(
        text,
        style: t.labelMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.86),
          fontWeight: FontWeight.w900,
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
      imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
      child: Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    );
  }
}
