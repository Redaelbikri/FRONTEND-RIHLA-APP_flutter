import 'package:flutter/material.dart';
import '../theme/rihla_colors.dart';
import 'glass.dart';

class RihlaField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final Widget? trailing;

  // ✅ ADD THIS
  final String? Function(String?)? validator;

  const RihlaField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.trailing,
    this.validator, // ✅ ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Glass(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: BorderRadius.circular(22),
      opacity: 0.34,
      blur: 18,
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
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),

          // ✅ IMPORTANT: TextFormField (not TextField) so validator works
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscure,
            validator: validator, // ✅ ADD THIS
            style: t.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w800,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: t.titleMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.45),
                fontWeight: FontWeight.w700,
              ),

              // ✅ Nice error style on dark bg
              errorStyle: const TextStyle(
                color: Color(0xFFFFD58A),
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
}
