import 'package:flutter/material.dart';

import '../../core/theme/theme_palette.dart';

class AchievementToast extends StatelessWidget {
  const AchievementToast({
    super.key,
    required this.palette,
    required this.title,
    required this.isVisible,
  });

  final ThemePalette palette;
  final String title;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      offset: isVisible ? Offset.zero : const Offset(0, -1.5),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isVisible ? 1.0 : 0.0,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: palette.accent,
            borderRadius: BorderRadius.circular(18),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.accent.withValues(alpha: 0.45),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.emoji_events_rounded,
                color: palette.backgroundGradient.first,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'NAİLİYYƏT AÇILDI',
                      style: TextStyle(
                        color: palette.backgroundGradient.first
                            .withValues(alpha: 0.75),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: TextStyle(
                        color: palette.backgroundGradient.first,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
