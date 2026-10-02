import 'package:flutter/material.dart';

import '../../core/theme/theme_palette.dart';
import '../../game/models/piece.dart';
import '../painters/piece_painter.dart';

class DraggablePiece extends StatefulWidget {
  const DraggablePiece({
    super.key,
    required this.piece,
    required this.slotIndex,
    required this.cellSize,
    required this.palette,
    required this.hidden,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onDragCancel,
  });

  final Piece piece;
  final int slotIndex;
  final double cellSize;
  final ThemePalette palette;
  final bool hidden;
  final void Function(Piece piece, int slotIndex, Offset pointer)? onDragStart;
  final void Function(Offset pointer)? onDragUpdate;
  final void Function()? onDragEnd;
  final void Function()? onDragCancel;

  @override
  State<DraggablePiece> createState() => _DraggablePieceState();
}

class _DraggablePieceState extends State<DraggablePiece> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final double w = widget.piece.width * widget.cellSize;
    final double h = widget.piece.height * widget.cellSize;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) {
        setState(() => _dragging = true);
        final RenderBox box = context.findRenderObject()! as RenderBox;
        final Offset local = box.globalToLocal(details.globalPosition);
        widget.onDragStart?.call(
          widget.piece,
          widget.slotIndex,
          details.globalPosition,
        );
        widget.onDragUpdate?.call(details.globalPosition);
        _ = local;
      },
      onPanUpdate: (details) {
        widget.onDragUpdate?.call(details.globalPosition);
      },
      onPanEnd: (_) {
        setState(() => _dragging = false);
        widget.onDragEnd?.call();
      },
      onPanCancel: () {
        setState(() => _dragging = false);
        widget.onDragCancel?.call();
      },
      child: SizedBox(
        width: w < widget.cellSize * 1.5 ? widget.cellSize * 3 : w + widget.cellSize,
        height: h < widget.cellSize * 1.5 ? widget.cellSize * 3 : h + widget.cellSize * 0.2,
        child: Center(
          child: Opacity(
            opacity: widget.hidden ? 0.25 : 1.0,
            child: CustomPaint(
              size: Size(w, h),
              painter: PiecePainter(
                piece: widget.piece,
                palette: widget.palette,
                cellSize: widget.cellSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
