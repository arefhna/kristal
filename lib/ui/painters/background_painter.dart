import 'package:flutter/material.dart';

import '../../core/theme/theme_palette.dart';

class BackgroundPainter extends CustomPainter {
  BackgroundPainter({required this.palette});

  final ThemePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: palette.backgroundGradient,
        stops: const <double>[0.0, 0.5, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    final Paint glow = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          palette.accent.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.8, size.height * 0.15),
          radius: size.width * 0.6,
        ),
      );

    canvas.drawRect(rect, glow);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) =>
      oldDelegate.palette != palette;
}
