import 'package:flutter/material.dart';

class BlockPainter {
  BlockPainter._();

  static void paintBlock({
    required Canvas canvas,
    required Rect rect,
    required Color color,
    required double radius,
    bool isIce = false,
    int iceLayers = 0,
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

    if (isIce) {
      _paintIceOverlay(
        canvas: canvas,
        rect: rect,
        radius: radius,
        layers: iceLayers,
      );
    }
  }

  static void _paintIceOverlay({
    required Canvas canvas,
    required Rect rect,
    required double radius,
    required int layers,
  }) {
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final Paint iceFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          const Color(0xFFE8F4FF).withValues(alpha: 0.55),
          const Color(0xFF9CC8F0).withValues(alpha: 0.4),
          const Color(0xFFE8F4FF).withValues(alpha: 0.55),
        ],
      ).createShader(rect);

    canvas.drawRRect(rrect, iceFill);

    final Path crack = Path()
      ..moveTo(rect.left + rect.width * 0.3, rect.top + rect.height * 0.15)
      ..lineTo(rect.left + rect.width * 0.55, rect.top + rect.height * 0.5)
      ..lineTo(rect.left + rect.width * 0.4, rect.top + rect.height * 0.85);

    final Paint crackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.65);
    canvas.drawPath(crack, crackPaint);

    if (layers > 1) {
      final Path crack2 = Path()
        ..moveTo(rect.left + rect.width * 0.75, rect.top + rect.height * 0.2)
        ..lineTo(rect.left + rect.width * 0.6, rect.top + rect.height * 0.55)
        ..lineTo(rect.left + rect.width * 0.8, rect.top + rect.height * 0.8);
      canvas.drawPath(crack2, crackPaint);
    }

    final Paint iceBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = const Color(0xFFB0D4F0).withValues(alpha: 0.85);
    canvas.drawRRect(rrect.deflate(0.9), iceBorder);
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
