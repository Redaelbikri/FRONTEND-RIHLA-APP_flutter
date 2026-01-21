import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();

  DateTime? _start;
  DateTime? _end;

  double _budget = 2200;
  final Set<_Vibe> _vibes = {_Vibe.nature};

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  int get _days {
    if (_start == null || _end == null) return 0;
    final d = _end!.difference(_start!).inDays;
    return d <= 0 ? 0 : d;
  }

  bool get _canGenerate {
    return _fromCtrl.text.trim().isNotEmpty &&
        _toCtrl.text.trim().isNotEmpty &&
        _start != null &&
        _end != null &&
        _days > 0 &&
        _vibes.isNotEmpty;
  }

  String get _budgetLabel {
    if (_budget < 1800) return 'Economic';
    if (_budget < 4200) return 'Comfort';
    return 'Luxury';
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'Select';
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[d.month - 1]} ${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate({required bool start}) async {
    final now = DateTime.now();
    final initial = start
        ? (_start ?? now)
        : (_end ?? (_start?.add(const Duration(days: 3)) ?? now.add(const Duration(days: 3))));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) {
        final theme = Theme.of(ctx);
        return Theme(
          data: theme.copyWith(
            dialogTheme: theme.dialogTheme.copyWith(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (start) {
        _start = picked;
        _end ??= _start!.add(const Duration(days: 3));
        if (_end!.isBefore(_start!.add(const Duration(days: 1)))) {
          _end = _start!.add(const Duration(days: 2));
        }
      } else {
        _end = picked;
        if (_start != null && _end!.isBefore(_start!.add(const Duration(days: 1)))) {
          _end = _start!.add(const Duration(days: 2));
        }
      }
    });
  }

  void _toggleVibe(_Vibe v) {
    setState(() {
      if (_vibes.contains(v)) {
        if (_vibes.length == 1) return;
        _vibes.remove(v);
      } else {
        _vibes.add(v);
      }
    });
  }

  void _generate() {
    if (!_canGenerate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete the trip details first.')),
      );
      return;
    }
    final from = _fromCtrl.text.trim();
    final to = _toCtrl.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating: $from → $to · $_days days · $_budgetLabel')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    const double floatingButtonHeight = 100.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                  Colors.black.withValues(alpha: 0.50),
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
            bottom: 100,
            right: -50,
            child: _BlurBlob(size: 300, color: RihlaColors.primary.withValues(alpha: 0.13)),
          ),

          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, floatingButtonHeight + 20),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Glass(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          borderRadius: BorderRadius.circular(18),
                          opacity: 0.28,
                          blur: 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'RIHLA AI',
                                style: t.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Glass(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          borderRadius: BorderRadius.circular(18),
                          opacity: 0.22,
                          blur: 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.shield_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Secure',
                                style: t.labelLarge?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Plan a trip\nin seconds',
                      style: t.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                        letterSpacing: -0.6,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 220.ms)
                        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),

                    const SizedBox(height: 8),

                    Text(
                      'Departure, destination, dates, budget and vibe.\nRIHLA generates your itinerary.',
                      style: t.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _RouteInputsCard(fromCtrl: _fromCtrl, toCtrl: _toCtrl),
                    const SizedBox(height: 14),

                    _DatesCard(
                      startLabel: _fmt(_start),
                      endLabel: _fmt(_end),
                      days: _days,
                      onPickStart: () => _pickDate(start: true),
                      onPickEnd: () => _pickDate(start: false),
                    ),
                    const SizedBox(height: 14),

                    _BudgetCard(
                      value: _budget,
                      label: _budgetLabel,
                      onChanged: (v) => setState(() => _budget = v),
                    ),
                    const SizedBox(height: 14),

                    _VibeCard(
                      selected: _vibes,
                      onToggle: _toggleVibe,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: floatingButtonHeight,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
              child: Center(
                child: Opacity(
                  opacity: _canGenerate ? 1 : 0.70,
                  child: Glass(
                    borderRadius: BorderRadius.circular(20),
                    blur: 10,
                    opacity: 0.2,
                    child: PrimaryButton(
                      text: 'Generate itinerary',
                      icon: Icons.auto_awesome_rounded,
                      onTap: _generate,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _RouteInputsCard extends StatelessWidget {
  final TextEditingController fromCtrl;
  final TextEditingController toCtrl;

  const _RouteInputsCard({required this.fromCtrl, required this.toCtrl});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    Widget field({
      required String label,
      required String hint,
      required IconData icon,
      required TextEditingController controller,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: t.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              style: t.titleLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                fontWeight: FontWeight.w900,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: t.titleLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w800,
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      );
    }

    return Glass(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      opacity: 0.34,
      blur: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.place_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Route',
                  style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: field(
                  label: 'DEPARTURE',
                  hint: 'Ville de départ',
                  icon: Icons.trip_origin_rounded,
                  controller: fromCtrl,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: field(
                  label: 'DESTINATION',
                  hint: 'Ville de destination',
                  icon: Icons.flag_rounded,
                  controller: toCtrl,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DatesCard extends StatelessWidget {
  final String startLabel;
  final String endLabel;
  final int days;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  const _DatesCard({
    required this.startLabel,
    required this.endLabel,
    required this.days,
    required this.onPickStart,
    required this.onPickEnd,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Glass(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      opacity: 0.34,
      blur: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'When are you going?',
                  style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ),
              if (days > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
                  ),
                  child: Text(
                    '$days days',
                    style: t.labelLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w900),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TapField(
                  label: 'START',
                  value: startLabel,
                  icon: Icons.play_circle_rounded,
                  onTap: onPickStart,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TapField(
                  label: 'END',
                  value: endLabel,
                  icon: Icons.stop_circle_rounded,
                  onTap: onPickEnd,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TapField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _TapField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: t.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: t.titleLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final double value;
  final String label;
  final ValueChanged<double> onChanged;

  const _BudgetCard({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Glass(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      opacity: 0.34,
      blur: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Budget (MAD)',
                  style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
                ),
                child: Text(
                  '${value.toStringAsFixed(0)} · $label',
                  style: t.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 5,
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              activeTrackColor: Colors.white.withValues(alpha: 0.90),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: value,
              min: 500,
              max: 8000,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _TinyLabel(text: 'ECONOMIC'),
              _TinyLabel(text: 'COMFORT', strong: true),
              _TinyLabel(text: 'LUXURY'),
            ],
          ),
        ],
      ),
    );
  }
}

class _VibeCard extends StatelessWidget {
  final Set<_Vibe> selected;
  final ValueChanged<_Vibe> onToggle;

  const _VibeCard({
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    const items = <_Vibe>[
      _Vibe.nature,
      _Vibe.culture,
      _Vibe.food,
      _Vibe.adventure,
      _Vibe.relax,
      _Vibe.shopping,
    ];

    return Glass(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      opacity: 0.34,
      blur: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Vibe',
                  style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                'Pick 1+',
                style: t.labelLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map((v) {
              final on = selected.contains(v);
              return _MiniVibeChip(
                icon: v.icon,
                label: v.label,
                active: on,
                onTap: () => onToggle(v),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MiniVibeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _MiniVibeChip({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active
                ? Colors.white.withValues(alpha: 0.30)
                : Colors.white.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: t.labelLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                fontWeight: FontWeight.w900,
              ),
            ),
            if (active) ...[
              const SizedBox(width: 6),
              Icon(Icons.check_circle_rounded,
                  color: Colors.white.withValues(alpha: 0.92), size: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _TinyLabel extends StatelessWidget {
  final String text;
  final bool strong;

  const _TinyLabel({required this.text, this.strong = false});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Text(
      text,
      style: t.labelLarge?.copyWith(
        color: Colors.white.withValues(alpha: strong ? 0.92 : 0.70),
        fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
        letterSpacing: 0.6,
      ),
    );
  }
}

enum _Vibe {
  nature('Nature', Icons.park_rounded),
  culture('Culture', Icons.museum_rounded),
  food('Food', Icons.restaurant_rounded),
  adventure('Adventure', Icons.hiking_rounded),
  relax('Relax', Icons.spa_rounded),
  shopping('Shopping', Icons.shopping_bag_rounded);

  final String label;
  final IconData icon;
  const _Vibe(this.label, this.icon);
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
