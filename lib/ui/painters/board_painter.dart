import 'package:flutter/material.dart';

import '../../core/theme/theme_palette.dart';
import '../../game/models/board.dart';
import 'block_painter.dart';

class BoardPainter extends CustomPainter {
  BoardPainter({
    required this.board,
    required this.palette,
    this.ghostCells = const <List<int>>[],
    this.ghostColor,
  });

  final Board board;
  final ThemePalette palette;
  final List<List<int>> ghostCells;
  final Color? ghostColor;

  @override
  void paint(Canvas canvas, Size size) {
    final int n = board.size;
    final double cellSize = size.width / n;
    final double gap = cellSize * 0.06;
    final double radius = cellSize * 0.18;

    final Paint boardBg = Paint()
      ..color = palette.boardBackground
      ..style = PaintingStyle.fill;

    final RRect boardRRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(cellSize * 0.28),
    );
    canvas.drawRRect(boardRRect, boardBg);

    final Paint cellBg = Paint()..color = palette.boardCell;

    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        final Rect cellRect = Rect.fromLTWH(
          c * cellSize + gap,
          r * cellSize + gap,
          cellSize - gap * 2,
          cellSize - gap * 2,
        );
        final RRect cellRRect = RRect.fromRectAndRadius(
          cellRect,
          Radius.circular(radius),
        );
        canvas.drawRRect(cellRRect, cellBg);
      }
    }

    if (ghostCells.isNotEmpty) {
      final Color gColor = ghostColor ?? palette.ghostColor;
      for (final gc in ghostCells) {
        final int r = gc[0];
        final int c = gc[1];
        if (r < 0 || r >= n || c < 0 || c >= n) continue;
        final Rect cellRect = Rect.fromLTWH(
          c * cellSize + gap,
          r * cellSize + gap,
          cellSize - gap * 2,
          cellSize - gap * 2,
        );
        BlockPainter.paintGhost(
          canvas: canvas,
          rect: cellRect,
          color: gColor,
          radius: radius,
        );
      }
    }

    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        final cell = board.at(r, c);
        if (cell.isEmpty) continue;

        final int colorIndex = cell.colorIndex;
        final Color blockColor =
            colorIndex >= 0 && colorIndex < palette.blockColors.length
                ? palette.blockColors[colorIndex]
                : palette.blockColors.first;

        final Rect cellRect = Rect.fromLTWH(
          c * cellSize + gap,
          r * cellSize + gap,
          cellSize - gap * 2,
          cellSize - gap * 2,
        );

        BlockPainter.paintBlock(
          canvas: canvas,
          rect: cellRect,
          color: blockColor,
          radius: radius,
          isIce: cell.isIce,
          iceLayers: cell.iceLayers,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter old) {
    return old.board != board ||
        old.ghostCells != ghostCells ||
        old.palette != palette ||
        old.ghostColor != ghostColor;
  }
}
