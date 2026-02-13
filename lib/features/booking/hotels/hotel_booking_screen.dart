import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';
import '../../../core/ui/primary_button.dart';
import 'hotel_models.dart';
import '../payment/fake_stripe_payment_screen.dart';
import 'hotel_booking_screen.dart';


class HotelBookingScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelBookingScreen({super.key, required this.hotel});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;

  int _guests = 2;
  int _rooms = 1;

  String _roomType = 'Standard';
  bool _breakfast = true;
  bool _freeCancel = true;

  int get _nights {
    if (_checkIn == null || _checkOut == null) return 0;
    final n = _checkOut!.difference(_checkIn!).inDays;
    return n <= 0 ? 0 : n;
  }

  double get _extras {
    double x = 0;
    if (_breakfast) x += 80.0 * _guests;
    if (_freeCancel) x += 60.0;
    if (_roomType == 'Deluxe') x += 120.0;
    if (_roomType == 'Suite') x += 240.0;
    return x;
  }

  double get _subtotal {
    if (_nights == 0) return 0;
    return (widget.hotel.priceMadPerNight.toDouble() * _nights * _rooms) + _extras;
  }

  double get _fees => _subtotal == 0 ? 0 : (_subtotal * 0.07);
  double get _total => _subtotal + _fees;

  bool get _canContinue => _nights > 0 && _guests > 0 && _rooms > 0;

  Future<void> _pickDate({required bool checkIn}) async {
    final now = DateTime.now();
    final initial = checkIn
        ? (_checkIn ?? now.add(const Duration(days: 1)))
        : (_checkOut ?? (_checkIn?.add(const Duration(days: 2)) ?? now.add(const Duration(days: 3))));

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
      if (checkIn) {
        _checkIn = picked;
        _checkOut ??= _checkIn!.add(const Duration(days: 2));
        if (_checkOut!.isBefore(_checkIn!.add(const Duration(days: 1)))) {
          _checkOut = _checkIn!.add(const Duration(days: 2));
        }
      } else {
        _checkOut = picked;
        if (_checkIn != null && _checkOut!.isBefore(_checkIn!.add(const Duration(days: 1)))) {
          _checkOut = _checkIn!.add(const Duration(days: 2));
        }
      }
    });
  }

  void _incGuests() => setState(() => _guests = (_guests + 1).clamp(1, 12));
  void _decGuests() => setState(() => _guests = (_guests - 1).clamp(1, 12));

  void _incRooms() => setState(() => _rooms = (_rooms + 1).clamp(1, 6));
  void _decRooms() => setState(() => _rooms = (_rooms - 1).clamp(1, 6));

  void _continueToPayment() {
    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select valid dates & details.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FakeStripePaymentScreen(
          merchantName: widget.hotel.name,
          subtitle: "${widget.hotel.city} · $_nights nights · $_rooms room(s)",
          amountMad: _total, title: '', meta: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

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
                  Colors.black.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.42),
                  Colors.black.withValues(alpha: 0.70),
                ],
              ),
            ),
          ),
          Positioned(
            top: -70,
            left: -50,
            child: _BlurBlob(size: 280, color: RihlaColors.accent.withValues(alpha: 0.14)),
          ),
          Positioned(
            bottom: -90,
            right: -60,
            child: _BlurBlob(size: 320, color: RihlaColors.primary.withValues(alpha: 0.13)),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      _RoundIcon(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Book hotel",
                          style: t.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Glass(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        borderRadius: BorderRadius.circular(18),
                        opacity: 0.26,
                        blur: 18,
                        child: Row(
                          children: [
                            const Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Secure",
                              style: t.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Glass(
                          padding: const EdgeInsets.all(14),
                          borderRadius: BorderRadius.circular(28),
                          opacity: 0.40,
                          blur: 20,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Image.asset(
                                  widget.hotel.image,
                                  width: 84,
                                  height: 84,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 84,
                                    height: 84,
                                    color: Colors.white.withValues(alpha: 0.10),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.hotel_rounded, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.hotel.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${widget.hotel.city} · ${widget.hotel.priceMadPerNight} MAD / night",
                                      style: t.bodyMedium?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.82),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.hotel.rating.toStringAsFixed(1),
                                          style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "(${widget.hotel.reviewsCount})",
                                          style: t.labelLarge?.copyWith(
                                            color: Colors.white.withValues(alpha: 0.70),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.06, end: 0),

                        const SizedBox(height: 14),

                        // Dates
                        _SectionTitle(title: "Dates", icon: Icons.calendar_today_rounded),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _DateButton(
                                label: "Check-in",
                                value: _checkIn,
                                onTap: () => _pickDate(checkIn: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DateButton(
                                label: "Check-out",
                                value: _checkOut,
                                onTap: () => _pickDate(checkIn: false),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Glass(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(28),
                          opacity: 0.34,
                          blur: 18,
                          child: Column(
                            children: [
                              _CounterRow(
                                label: "Guests",
                                value: _guests,
                                onAdd: _incGuests,
                                onRemove: _decGuests,
                              ),
                              Divider(color: Colors.white.withValues(alpha: 0.14)),
                              _CounterRow(
                                label: "Rooms",
                                value: _rooms,
                                onAdd: _incRooms,
                                onRemove: _decRooms,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Room type
                        _SectionTitle(title: "Room type", icon: Icons.bed_rounded),
                        const SizedBox(height: 10),
                        Glass(
                          padding: const EdgeInsets.all(14),
                          borderRadius: BorderRadius.circular(28),
                          opacity: 0.34,
                          blur: 18,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: const ['Standard', 'Deluxe', 'Suite'].map((e) {

                              return SizedBox();
                            }).toList(),
                          ),
                        ),


                        const SizedBox(height: 0),
                        Builder(
                          builder: (context) {
                            final items = const ['Standard', 'Deluxe', 'Suite'];
                            return Transform.translate(
                              offset: const Offset(0, -76),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 76),
                                child: Glass(
                                  padding: const EdgeInsets.all(14),
                                  borderRadius: BorderRadius.circular(28),
                                  opacity: 0.34,
                                  blur: 18,
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: items.map((e) {
                                      final active = _roomType == e;
                                      return _MiniChoiceChip(
                                        text: e,
                                        active: active,
                                        onTap: () => setState(() => _roomType = e),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        // Extras
                        _SectionTitle(title: "Options", icon: Icons.tune_rounded),
                        const SizedBox(height: 10),
                        Glass(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(28),
                          opacity: 0.34,
                          blur: 18,
                          child: Column(
                            children: [
                              _ToggleRow(
                                title: "Breakfast included",
                                subtitle: "+80 MAD / guest (fake)",
                                value: _breakfast,
                                onChanged: (v) => setState(() => _breakfast = v),
                              ),
                              Divider(color: Colors.white.withValues(alpha: 0.14)),
                              _ToggleRow(
                                title: "Free cancellation",
                                subtitle: "+60 MAD (fake)",
                                value: _freeCancel,
                                onChanged: (v) => setState(() => _freeCancel = v),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        _SectionTitle(title: "Summary", icon: Icons.receipt_long_rounded),
                        const SizedBox(height: 10),
                        Glass(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(28),
                          opacity: 0.34,
                          blur: 18,
                          child: Column(
                            children: [
                              _Line(label: "Nights", value: _nights == 0 ? "-" : "$_nights"),
                              _Line(label: "Rooms", value: "$_rooms"),
                              _Line(label: "Extras", value: "${_extras.toStringAsFixed(0)} MAD"),
                              _Line(label: "Subtotal", value: "${_subtotal.toStringAsFixed(0)} MAD"),
                              _Line(label: "Service fee (7%)", value: "${_fees.toStringAsFixed(0)} MAD"),
                              const SizedBox(height: 10),
                              Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.16),
                              ),
                              const SizedBox(height: 10),
                              _Line(
                                label: "Total",
                                value: "${_total.toStringAsFixed(0)} MAD",
                                strong: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),


          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.78),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Opacity(
                opacity: _canContinue ? 1 : 0.65,
                child: PrimaryButton(
                  text: "Validate booking",
                  icon: Icons.verified_rounded,
                  onTap: _continueToPayment,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: t.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;

  const _Line({required this.label, required this.value, this.strong = false});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Colors.white.withValues(alpha: strong ? 0.95 : 0.82);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: t.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: t.titleMedium?.copyWith(
              color: c,
              fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.70), fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.white.withValues(alpha: 0.35),
          inactiveThumbColor: Colors.white.withValues(alpha: 0.70),
          inactiveTrackColor: Colors.white.withValues(alpha: 0.18),
        ),
      ],
    );
  }
}

class _MiniChoiceChip extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _MiniChoiceChip({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? Colors.white.withValues(alpha: 0.32) : Colors.white.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 16,
              color: Colors.white.withValues(alpha: 0.92),
            ),
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
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    String display = "Select";
    if (value != null) {
      display = "${value!.day.toString().padLeft(2, '0')}/"
          "${value!.month.toString().padLeft(2, '0')}/"
          "${value!.year}";
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: t.labelLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              display,
              style: t.titleMedium?.copyWith(
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

class _CounterRow extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _CounterRow({
    required this.label,
    required this.value,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final disabledMinus = value <= 1;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: t.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _CircleIcon(
          icon: Icons.remove_rounded,
          disabled: disabledMinus,
          onTap: disabledMinus ? null : onRemove,
        ),
        const SizedBox(width: 10),
        Text(
          value.toString(),
          style: t.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 10),
        _CircleIcon(
          icon: Icons.add_rounded,
          onTap: onAdd,
        ),
      ],
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  const _CircleIcon({
    required this.icon,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Opacity(
        opacity: disabled ? 0.35 : 1,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
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
