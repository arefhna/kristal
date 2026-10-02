import 'package:flutter/material.dart';

import '../../core/theme/theme_palette.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({
    super.key,
    required this.palette,
    required this.onResume,
    required this.onRestart,
    required this.onHome,
  });

  final ThemePalette palette;
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'PAUZA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6.0,
                ),
              ),
              const SizedBox(height: 32),
              _PauseButton(
                label: 'DAVAM ET',
                palette: palette,
                isPrimary: true,
                onTap: onResume,
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label: 'YENİDƏN BAŞLA',
                palette: palette,
                onTap: onRestart,
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label: 'MENYU',
                palette: palette,
                onTap: onHome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton({
    required this.label,
    required this.palette,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final ThemePalette palette;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final Color bg = isPrimary
        ? palette.accent
        : Colors.white.withValues(alpha: 0.08);
    final Color fg =
        isPrimary ? palette.backgroundGradient.first : palette.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPrimary
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.12),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fg,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
