import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';

import 'transport_mode.dart';
import 'transport_models.dart';
import 'transport_result_card.dart';
import 'transport_booking_details_screen.dart';


class TransportScreen extends StatefulWidget {
  final TransportMode initialMode;
  const TransportScreen({super.key, this.initialMode = TransportMode.train});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  late TransportMode _mode;
  SortFilter _filter = SortFilter.all;

  final fromCtrl = TextEditingController(text: 'Casablanca');
  final toCtrl = TextEditingController(text: 'Tanger');

  int _dayIndex = 0;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    fromCtrl.dispose();
    toCtrl.dispose();
    super.dispose();
  }

  List<TransportResult> get _results {
    final list = TransportMock.resultsFor(_mode).toList();


    if (_filter == SortFilter.cheapest) {
      list.sort((a, b) => a.priceMad.compareTo(b.priceMad));
    } else if (_filter == SortFilter.fastest) {
      list.sort((a, b) => a.duration.compareTo(b.duration));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/backgrounds/transport_bg.png', fit: BoxFit.cover),


          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.32),
                  Colors.black.withValues(alpha: 0.14),
                  Colors.black.withValues(alpha: 0.65),
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
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
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
                                '${fromCtrl.text}  →  ${toCtrl.text}',
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
                                child: const Icon(Icons.tune_rounded, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                  child: Column(
                    children: [
                      _ModeRow(
                        mode: _mode,
                        onChanged: (m) => setState(() => _mode = m),
                      ),

                      const SizedBox(height: 10),

                      _RouteForm(
                        fromCtrl: fromCtrl,
                        toCtrl: toCtrl,
                        onSwap: () {
                          final tmp = fromCtrl.text;
                          fromCtrl.text = toCtrl.text;
                          toCtrl.text = tmp;
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 12),

                      _DayTabs(
                        index: _dayIndex,
                        onChanged: (i) => setState(() => _dayIndex = i),
                      ),

                      const SizedBox(height: 12),

                      _FilterChips(
                        value: _filter,
                        onChanged: (v) => setState(() => _filter = v),
                        modeLabel: _mode.label,
                      ),
                    ],
                  ),
                ),


                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final r = _results[i];
                      return TransportResultCard(
                        r: r,
                        onSelect: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TransportBookingDetailsScreen(result: r),
                            ),
                          );
                        },
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
}

class _ModeRow extends StatelessWidget {
  final TransportMode mode;
  final ValueChanged<TransportMode> onChanged;

  const _ModeRow({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget item(TransportMode m, IconData icon) {
      final active = m == mode;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(m),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? Colors.white.withValues(alpha: 0.20) : Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: active ? 0.22 : 0.14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  m.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        item(TransportMode.train, Icons.train_rounded),
        const SizedBox(width: 8),
        item(TransportMode.bus, Icons.directions_bus_rounded),
        const SizedBox(width: 8),
        item(TransportMode.flight, Icons.flight_rounded),
        const SizedBox(width: 8),
        item(TransportMode.car, Icons.directions_car_rounded),
      ],
    );
  }
}

class _RouteForm extends StatelessWidget {
  final TextEditingController fromCtrl;
  final TextEditingController toCtrl;
  final VoidCallback onSwap;

  const _RouteForm({
    required this.fromCtrl,
    required this.toCtrl,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    Widget field(String label, TextEditingController c, IconData icon) {
      return Expanded(
        child: Glass(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          borderRadius: BorderRadius.circular(22),
          opacity: 0.40,
          blur: 18,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: c,
                  style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: label,
                    hintStyle: t.titleSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        field('From', fromCtrl, Icons.trip_origin_rounded),
        const SizedBox(width: 10),
        InkWell(
          onTap: onSwap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            ),
            child: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        field('To', toCtrl, Icons.location_on_rounded),
      ],
    );
  }
}

class _DayTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _DayTabs({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget tab(String label, int i) {
      final active = i == index;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(i),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: active ? const Color(0xFF1F6E5C) : Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('TODAY\n14', 0),
        const SizedBox(width: 8),
        tab('FRI\n15', 1),
        const SizedBox(width: 8),
        tab('SAT\n16', 2),
        const SizedBox(width: 8),
        tab('SUN\n17', 3),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  final SortFilter value;
  final ValueChanged<SortFilter> onChanged;
  final String modeLabel;

  const _FilterChips({required this.value, required this.onChanged, required this.modeLabel});

  @override
  Widget build(BuildContext context) {
    Widget chip(SortFilter f) {
      final active = f == value;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(f),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? Colors.blue.withValues(alpha: 0.55) : Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Center(
              child: Text(
                f == SortFilter.all ? 'All $modeLabel' : f.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip(SortFilter.all),
        const SizedBox(width: 8),
        chip(SortFilter.fastest),
        const SizedBox(width: 8),
        chip(SortFilter.cheapest),
      ],
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
