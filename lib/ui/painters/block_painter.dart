import 'package:flutter/material.dart';

class BlockPainter {
  BlockPainter._();

  static void paintBlock({
    required Canvas canvas,
    required Rect rect,
    required Color color,
    required double radius,
  }) {
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final Path topPath = Path()
      ..addRRect(rrect)
      ..close();

    final Paint basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.lerp(color, Colors.white, 0.28) ?? color,
          color,
          Color.lerp(color, Colors.black, 0.18) ?? color,
        ],
        stops: const <double>[0.0, 0.5, 1.0],
      ).createShader(rect);

    canvas.save();
    canvas.clipPath(topPath);
    canvas.drawRect(rect, basePaint);
    canvas.restore();

    final Rect topHighlightRect = Rect.fromLTWH(
      rect.left + rect.width * 0.1,
      rect.top + rect.height * 0.08,
      rect.width * 0.8,
      rect.height * 0.32,
    );
    final Paint topHighlight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Colors.white.withValues(alpha: 0.55),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(topHighlightRect);

    final RRect topHighlightRRect = RRect.fromRectAndRadius(
      topHighlightRect,
      Radius.circular(radius * 0.6),
    );
    canvas.drawRRect(topHighlightRRect, topHighlight);

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.05),
        ],
      ).createShader(rect);

    canvas.drawRRect(rrect.deflate(0.6), borderPaint);

    final Paint bottomShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    final Rect shadowRect = Rect.fromLTWH(
      rect.left + 1.5,
      rect.top + rect.height - 3.5,
      rect.width - 3,
      3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(shadowRect, Radius.circular(radius * 0.5)),
      bottomShadow,
    );
  }

  static void paintGhost({
    required Canvas canvas,
    required Rect rect,
    required Color color,
    required double radius,
  }) {
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final Paint fill = Paint()..color = color.withValues(alpha: 0.18);
    canvas.drawRRect(rrect, fill);

    final Paint border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color.withValues(alpha: 0.55);
    canvas.drawRRect(rrect.deflate(0.75), border);
  }
}
