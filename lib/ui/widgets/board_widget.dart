import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../state/game/game_state.dart';
import '../../state/providers.dart';
import '../painters/board_painter.dart';

class BoardWidget extends ConsumerWidget {
  const BoardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DragInfo? drag = ref.watch(
      gameControllerProvider.select((s) => s.drag),
    );
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final board = ref.watch(
      gameControllerProvider.select((s) => s.board),
    );

    final List<List<int>> ghostCells = <List<int>>[];
    Color? ghostColor;

    if (drag != null &&
        drag.isValidTarget &&
        drag.ghostRow != null &&
        drag.ghostCol != null) {
      final List<List<int>> cells = drag.piece.absoluteCells(
        drag.ghostRow!,
        drag.ghostCol!,
      );
      ghostCells.addAll(cells);
      final int idx = drag.piece.colorIndex;
      ghostColor = idx >= 0 && idx < palette.blockColors.length
          ? palette.blockColors[idx]
          : palette.blockColors.first;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: BoardPainter(
            board: board,
            palette: palette,
            ghostCells: ghostCells,
            ghostColor: ghostColor,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}
