import 'package:flutter/material.dart';

import '../../core/theme/theme_palette.dart';
import '../../game/models/piece.dart';
import 'block_painter.dart';

class PiecePainter extends CustomPainter {
  PiecePainter({
    required this.piece,
    required this.palette,
    required this.cellSize,
    this.opacity = 1.0,
  });

  final Piece piece;
  final ThemePalette palette;
  final double cellSize;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final double gap = cellSize * 0.06;
    final double radius = cellSize * 0.18;
    final Color blockColor = piece.colorIndex >= 0 && piece.colorIndex < palette.blockColors.length
        ? palette.blockColors[piece.colorIndex]
        : palette.blockColors.first;

    final Color finalColor = opacity < 1.0
        ? blockColor.withValues(alpha: opacity)
        : blockColor;

    for (final c in piece.cells) {
      final Rect cellRect = Rect.fromLTWH(
        c[1] * cellSize + gap,
        c[0] * cellSize + gap,
        cellSize - gap * 2,
        cellSize - gap * 2,
      );
      BlockPainter.paintBlock(
        canvas: canvas,
        rect: cellRect,
        color: finalColor,
        radius: radius,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PiecePainter old) {
    return old.piece != piece ||
        old.palette != palette ||
        old.cellSize != cellSize ||
        old.opacity != opacity;
  }
}
