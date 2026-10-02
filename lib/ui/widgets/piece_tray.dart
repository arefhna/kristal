import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../game/models/piece.dart';
import '../../state/game/game_state.dart';
import '../../state/providers.dart';
import 'draggable_piece.dart';

class PieceTray extends ConsumerWidget {
  const PieceTray({
    super.key,
    required this.cellSize,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onDragCancel,
  });

  final double cellSize;
  final void Function(Piece piece, int slotIndex, Offset pointer)? onDragStart;
  final void Function(Offset pointer)? onDragUpdate;
  final void Function()? onDragEnd;
  final void Function()? onDragCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Piece?> batch = ref.watch(
      gameControllerProvider.select((s) => s.batch),
    );
    final int batchKey = ref.watch(
      gameControllerProvider.select((s) => s.batchKey),
    );
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final bool anyDragging = ref.watch(
      gameControllerProvider.select((s) => s.drag != null),
    );

    return Row(
      key: ValueKey<int>(batchKey),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(3, (i) {
        final Piece? piece = i < batch.length ? batch[i] : null;
        if (piece == null) {
          return SizedBox(width: cellSize * 5, height: cellSize * 5);
        }
        final bool isBeingDragged = anyDragging &&
            ref.read(gameControllerProvider).drag?.slotIndex == i;

        return DraggablePiece(
          piece: piece,
          slotIndex: i,
          cellSize: cellSize,
          palette: palette,
          hidden: isBeingDragged,
          onDragStart: onDragStart,
          onDragUpdate: onDragUpdate,
          onDragEnd: onDragEnd,
          onDragCancel: onDragCancel,
        );
      }),
    );
  }
}
