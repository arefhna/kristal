import 'package:flutter/material.dart';

import '../../core/theme/theme_palette.dart';
import '../effects/line_flash.dart';
import '../effects/particle.dart';

class EffectsPainter extends CustomPainter {
  EffectsPainter({
    required this.particles,
    required this.flashes,
    required this.boardSize,
    required this.boardOrigin,
    required this.palette,
  });

  final List<Particle> particles;
  final List<LineFlash> flashes;
  final double boardSize;
  final Offset boardOrigin;
  final ThemePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    _paintLineFlashes(canvas);
    _paintParticles(canvas);
  }

  void _paintLineFlashes(Canvas canvas) {
    if (flashes.isEmpty) return;
    final double cell = boardSize / 8;

    for (final flash in flashes) {
      final double p = flash.progress;
      final double opacity = (1.0 - p) * 0.85;
      final double thickness = cell * (0.85 - p * 0.55);

      final Paint glow = Paint()
        ..color = palette.accent.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      final Paint core = Paint()
        ..color = Color.lerp(palette.accent, const Color(0xFFFFFFFF), 0.5)!
            .withValues(alpha: opacity);

      for (final row in flash.rows) {
        final double y = boardOrigin.dy + row * cell + cell / 2;
        canvas.drawRect(
          Rect.fromLTWH(
            boardOrigin.dx,
            y - thickness / 2,
            boardSize,
            thickness,
          ),
          glow,
        );
        canvas.drawRect(
          Rect.fromLTWH(
            boardOrigin.dx,
            y - thickness / 4,
            boardSize,
            thickness / 2,
          ),
          core,
        );
      }

      for (final col in flash.cols) {
        final double x = boardOrigin.dx + col * cell + cell / 2;
        canvas.drawRect(
          Rect.fromLTWH(
            x - thickness / 2,
            boardOrigin.dy,
            thickness,
            boardSize,
          ),
          glow,
        );
        canvas.drawRect(
          Rect.fromLTWH(
            x - thickness / 4,
            boardOrigin.dy,
            thickness / 2,
            boardSize,
          ),
          core,
        );
      }
    }
  }

  void _paintParticles(Canvas canvas) {
    if (particles.isEmpty) return;
    for (final p in particles) {
      final Paint paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawCircle(p.position, p.currentSize / 2, paint);

      final Paint corePaint = Paint()
        ..color = Color.lerp(p.color, const Color(0xFFFFFFFF), 0.6)!
            .withValues(alpha: p.opacity);
      canvas.drawCircle(p.position, p.currentSize / 4, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant EffectsPainter old) => true;
}
