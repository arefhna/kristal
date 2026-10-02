import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../game/models/piece.dart';
import '../../state/game/game_state.dart';
import '../../state/providers.dart';
import '../painters/background_painter.dart';
import '../widgets/board_widget.dart';
import '../widgets/piece_tray.dart';
import '../widgets/score_display.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final GlobalKey _boardKey = GlobalKey();
  double _boardTop = 0;
  double _boardLeft = 0;
  double _boardSize = 0;
  double _cellSize = 0;

  void _updateBoardGeometry() {
    final RenderBox? box =
        _boardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final Offset pos = box.localToGlobal(Offset.zero);
    _boardTop = pos.dy;
    _boardLeft = pos.dx;
    _boardSize = box.size.width;
    _cellSize = _boardSize / 8;
  }

  void _handleDragUpdate(Offset pointer) {
    final controller = ref.read(gameControllerProvider.notifier);
    final DragInfo? drag = ref.read(gameControllerProvider).drag;
    if (drag == null) return;

    final double lift = _cellSize * 1.15;
    final double pieceLeft = pointer.dx - (drag.piece.width * _cellSize) / 2;
    final double pieceTop = pointer.dy - lift - (drag.piece.height * _cellSize) / 2;

    final int col = ((pieceLeft - _boardLeft) / _cellSize).round();
    final int row = ((pieceTop - _boardTop) / _cellSize).round();

    final bool valid = controller.engine.canPlaceAt(drag.piece, row, col);

    controller.onDragUpdate(
      pointerPosition: pointer,
      ghostRow: row,
      ghostCol: col,
      isValid: valid,
    );
  }

  void _handleDragStart(Piece piece, int slotIndex, Offset pointer) {
    _updateBoardGeometry();
    ref.read(gameControllerProvider.notifier).onDragStart(
          piece: piece,
          slotIndex: slotIndex,
          pointerPosition: pointer,
        );
  }

  void _handleDragEnd() {
    final controller = ref.read(gameControllerProvider.notifier);
    final DragInfo? drag = ref.read(gameControllerProvider).drag;
    if (drag == null) return;
    controller.onDragEnd(
      ghostRow: drag.ghostRow,
      ghostCol: drag.ghostCol,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final Size screen = MediaQuery.of(context).size;
    final double padding = screen.width * 0.04;
    final double boardSize = screen.width - padding * 2;
    final double cellSize = boardSize / 8;
    final bool isGameOver = ref.watch(
      gameControllerProvider.select((s) => s.isGameOver),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(
                  painter: BackgroundPainter(palette: palette),
                ),
              ),
              Column(
                children: <Widget>[
                  const SizedBox(height: 12),
                  const ScoreDisplay(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: RepaintBoundary(
                      key: _boardKey,
                      child: BoardWidget(),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: SizedBox(
                      height: cellSize * 5.4,
                      child: PieceTray(
                        cellSize: cellSize * 0.55,
                        onDragStart: _handleDragStart,
                        onDragUpdate: _handleDragUpdate,
                        onDragEnd: _handleDragEnd,
                        onDragCancel: () {
                          ref
                              .read(gameControllerProvider.notifier)
                              .onDragCancel();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              if (isGameOver)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.6),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'OYUN BİTDİ',
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3.0,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(gameControllerProvider.notifier)
                                  .restart();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: palette.accent,
                              foregroundColor: palette.backgroundGradient.first,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'YENİDƏN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
