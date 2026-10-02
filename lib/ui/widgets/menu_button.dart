import 'package:flutter/material.dart';

import '../../core/theme/theme_palette.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.palette,
    this.icon,
    this.subtitle,
    this.isPrimary = false,
  });

  final String label;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;
  final ThemePalette palette;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isPrimary
        ? palette.accent
        : Colors.white.withValues(alpha: 0.06);
    final Color fgColor =
        isPrimary ? palette.backgroundGradient.first : palette.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPrimary
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.12),
              width: 1.0,
            ),
            boxShadow: isPrimary
                ? <BoxShadow>[
                    BoxShadow(
                      color: palette.accent.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, color: fgColor, size: 26),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      label,
                      style: TextStyle(
                        color: fgColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: fgColor.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: fgColor.withValues(alpha: 0.55),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
