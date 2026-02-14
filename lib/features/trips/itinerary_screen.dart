import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';

class ItineraryScreen extends StatefulWidget {
  final String from;
  final String to;
  final DateTime start;
  final DateTime end;
  final double budgetMad;
  final List<String> vibes;

  /// ✅ OSM coords
  final LatLng fromLatLng;
  final LatLng toLatLng;

  const ItineraryScreen({
    super.key,
    required this.from,
    required this.to,
    required this.start,
    required this.end,
    required this.budgetMad,
    required this.vibes,
    required this.fromLatLng,
    required this.toLatLng,
  });

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final MapController _map = MapController();

  int get days {
    final d = widget.end.difference(widget.start).inDays;
    return d <= 0 ? 1 : d;
  }

  String _fmtDate(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[d.month - 1]} ${d.day.toString().padLeft(2, '0')}';
  }

  String get budgetLabel {
    if (widget.budgetMad < 1800) return 'Economic';
    if (widget.budgetMad < 4200) return 'Comfort';
    return 'Luxury';
  }

  LatLng get _center => LatLng(
    (widget.fromLatLng.latitude + widget.toLatLng.latitude) / 2,
    (widget.fromLatLng.longitude + widget.toLatLng.longitude) / 2,
  );

  LatLngBounds get _bounds {
    final sw = LatLng(
      widget.fromLatLng.latitude < widget.toLatLng.latitude
          ? widget.fromLatLng.latitude
          : widget.toLatLng.latitude,
      widget.fromLatLng.longitude < widget.toLatLng.longitude
          ? widget.fromLatLng.longitude
          : widget.toLatLng.longitude,
    );

    final ne = LatLng(
      widget.fromLatLng.latitude > widget.toLatLng.latitude
          ? widget.fromLatLng.latitude
          : widget.toLatLng.latitude,
      widget.fromLatLng.longitude > widget.toLatLng.longitude
          ? widget.fromLatLng.longitude
          : widget.toLatLng.longitude,
    );

    return LatLngBounds(sw, ne);
  }

  void _fitRoute() {
    _map.fitCamera(
      CameraFit.bounds(
        bounds: _bounds,
        padding: const EdgeInsets.all(40),
      ),
    );
  }

  List<_DayPlan> _buildPlan() {
    final base = <_DayPlan>[
      _DayPlan(
        title: 'Arrival & Medina Walk',
        subtitle: 'Check-in, sunset rooftop, old town exploration',
        icon: Icons.nightlife_rounded,
        spots: ['Rooftop Café', 'Medina alleys', 'Local artisan souk'],
      ),
      _DayPlan(
        title: 'Culture & Heritage',
        subtitle: 'Museums, architecture, and guided stories',
        icon: Icons.museum_rounded,
        spots: ['Historical museum', 'Traditional riad', 'Andalusian garden'],
      ),
      _DayPlan(
        title: 'Food & Experiences',
        subtitle: 'Tasting tour and cooking experience',
        icon: Icons.restaurant_rounded,
        spots: ['Street food', 'Cooking class', 'Mint tea ceremony'],
      ),
      _DayPlan(
        title: 'Adventure Day',
        subtitle: 'Nature escape with viewpoints & photography',
        icon: Icons.hiking_rounded,
        spots: ['Panorama point', 'Hike trail', 'Golden hour shots'],
      ),
      _DayPlan(
        title: 'Relax & Shopping',
        subtitle: 'Hammam, spa, gifts and souvenirs',
        icon: Icons.spa_rounded,
        spots: ['Hammam', 'Argan shop', 'Leather workshop'],
      ),
    ];

    return List.generate(days, (i) {
      final b = base[i % base.length];
      return b.copyWith(
        dayIndex: i + 1,
        date: widget.start.add(Duration(days: i)),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // Fit route after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final plan = _buildPlan();

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
                  Colors.black.withValues(alpha: 0.68),
                ],
              ),
            ),
          ),

          Positioned(
            top: -70,
            right: -50,
            child: _BlurBlob(size: 280, color: RihlaColors.accent.withValues(alpha: 0.14)),
          ),
          Positioned(
            bottom: -110,
            left: -80,
            child: _BlurBlob(size: 420, color: RihlaColors.primary.withValues(alpha: 0.14)),
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
                              const Icon(Icons.map_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Itinerary • ${widget.from} → ${widget.to}',
                                  style: t.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                                ),
                                child: Text(
                                  '$days days',
                                  style: t.labelLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Glass(
                          padding: const EdgeInsets.all(14),
                          borderRadius: BorderRadius.circular(28),
                          opacity: 0.40,
                          blur: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Live Map (OSM)',
                                    style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                                  ),
                                  const Spacer(),
                                  _MiniPill(icon: Icons.calendar_today_rounded, text: _fmtDate(widget.start)),
                                  const SizedBox(width: 8),
                                  _MiniPill(icon: Icons.flag_rounded, text: widget.to),
                                ],
                              ),
                              const SizedBox(height: 12),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: SizedBox(
                                  height: 240,
                                  width: double.infinity,
                                  child: FlutterMap(
                                    mapController: _map,
                                    options: MapOptions(
                                      initialCenter: _center,
                                      initialZoom: 6.2,
                                      interactionOptions: const InteractionOptions(
                                        flags: InteractiveFlag.drag |
                                        InteractiveFlag.pinchZoom |
                                        InteractiveFlag.doubleTapZoom,
                                      ),
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.rihla2026',
                                      ),

                                      PolylineLayer(
                                        polylines: [
                                          Polyline(
                                            points: [widget.fromLatLng, widget.toLatLng],
                                            strokeWidth: 4,
                                            color: Colors.white.withValues(alpha: 0.88),
                                          ),
                                        ],
                                      ),

                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: widget.fromLatLng,
                                            width: 46,
                                            height: 46,
                                            child: _OsmPin(label: widget.from, kind: _PinKind.from),
                                          ),
                                          Marker(
                                            point: widget.toLatLng,
                                            width: 46,
                                            height: 46,
                                            child: _OsmPin(label: widget.to, kind: _PinKind.to),
                                          ),
                                        ],
                                      ),


                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.35),
                                              borderRadius: BorderRadius.circular(18),
                                              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.route_rounded, color: Colors.white, size: 16),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '${widget.from} → ${widget.to}',
                                                  style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: _ActionButton(
                                      icon: Icons.center_focus_strong_rounded,
                                      label: 'Fit route',
                                      onTap: _fitRoute,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _ActionButton(
                                      icon: Icons.my_location_rounded,
                                      label: 'Center',
                                      onTap: () => _map.move(_center, 6.2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.06, end: 0),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: Glass(
                                padding: const EdgeInsets.all(14),
                                borderRadius: BorderRadius.circular(26),
                                opacity: 0.30,
                                blur: 18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Budget', style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.78), fontWeight: FontWeight.w900)),
                                    const SizedBox(height: 8),
                                    Text('${widget.budgetMad.toStringAsFixed(0)} MAD', style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                                    const SizedBox(height: 4),
                                    Text(budgetLabel, style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.80), fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Glass(
                                padding: const EdgeInsets.all(14),
                                borderRadius: BorderRadius.circular(26),
                                opacity: 0.30,
                                blur: 18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Vibes', style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.78), fontWeight: FontWeight.w900)),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: widget.vibes.take(3).map((v) => _Chip(text: v)).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text('Day by day', style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),

                        ...plan.map((d) => _DayCard(day: d)).toList(),

                        const SizedBox(height: 18),
                        PrimaryButton(
                          text: 'Finish',
                          icon: Icons.check_circle_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
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

/* ============== UI helpers ============== */

class _OsmPin extends StatelessWidget {
  final String label;
  final _PinKind kind;
  const _OsmPin({required this.label, required this.kind});

  @override
  Widget build(BuildContext context) {
    final bg = kind == _PinKind.from
        ? Colors.white.withValues(alpha: 0.18)
        : RihlaColors.accent.withValues(alpha: 0.22);

    final icon = kind == _PinKind.from ? Icons.trip_origin_rounded : Icons.location_on_rounded;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Tooltip(
        message: label,
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

enum _PinKind { from, to }

class _DayCard extends StatelessWidget {
  final _DayPlan day;
  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Glass(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(26),
        opacity: 0.34,
        blur: 18,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Icon(day.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                        ),
                        child: Text(
                          'DAY ${day.dayIndex} • ${day.dateLabel}',
                          style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.92), fontWeight: FontWeight.w900),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(day.title, style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(day.subtitle, style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.84), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: day.spots.map((s) => _Chip(text: s)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.06, end: 0),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(text, style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.86), fontWeight: FontWeight.w900)),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MiniPill({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.90), size: 16),
          const SizedBox(width: 6),
          Text(text, style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

/* ============== data ============== */

class _DayPlan {
  final int dayIndex;
  final DateTime date;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> spots;

  _DayPlan({
    this.dayIndex = 1,
    DateTime? date,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.spots,
  }) : date = date ?? DateTime.now();

  String get dateLabel {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[date.month - 1]} ${date.day.toString().padLeft(2, '0')}';
  }

  _DayPlan copyWith({int? dayIndex, DateTime? date}) => _DayPlan(
    dayIndex: dayIndex ?? this.dayIndex,
    date: date ?? this.date,
    title: title,
    subtitle: subtitle,
    icon: icon,
    spots: spots,
  );
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
