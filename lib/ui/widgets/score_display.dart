import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../state/providers.dart';

class ScoreDisplay extends ConsumerWidget {
  const ScoreDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int score = ref.watch(
      gameControllerProvider.select((s) => s.score),
    );
    final int combo = ref.watch(
      gameControllerProvider.select((s) => s.combo),
    );
    final ThemePalette palette = ref.watch(themePaletteProvider);

    return Column(
      children: <Widget>[
        Text(
          'XAL',
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 12,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> anim) {
            return FadeTransition(
              opacity: anim,
              child: ScaleTransition(scale: anim, child: child),
            );
          },
          child: Text(
            '$score',
            key: ValueKey<int>(score),
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ),
        if (combo > 1) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            'COMBO x${combo}',
            style: TextStyle(
              color: palette.accent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
