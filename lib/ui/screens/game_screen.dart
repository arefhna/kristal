import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../game/models/piece.dart';
import '../../state/game/game_state.dart';
import '../../state/providers.dart';
import '../effects/combo_text.dart';
import '../effects/line_flash.dart';
import '../effects/particle_system.dart';
import '../effects/screen_shake.dart';
import '../painters/background_painter.dart';
import '../painters/effects_painter.dart';
import '../widgets/board_widget.dart';
import '../widgets/combo_text_widget.dart';
import '../widgets/piece_tray.dart';
import '../widgets/score_display.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with TickerProviderStateMixin {
  final GlobalKey _boardKey = GlobalKey();
  double _boardTop = 0;
  double _boardLeft = 0;
  double _boardSize = 0;
  double _cellSize = 0;

  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  final ParticleSystem _particles = ParticleSystem();
  final ScreenShake _shake = ScreenShake();
  final List<LineFlash> _flashes = <LineFlash>[];
  final List<ComboText> _comboTexts = <ComboText>[];
  final Random _random = Random();

  int _lastEffectTrigger = 0;
  int _lastComboTrigger = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final double dt = _lastTick == Duration.zero
        ? 0.016
        : (elapsed - _lastTick).inMicroseconds / 1000000.0;
    _lastTick = elapsed;

    _particles.update(dt);
    _shake.update(dt);

    for (int i = _flashes.length - 1; i >= 0; i--) {
      _flashes[i].update(dt);
      if (_flashes[i].isDead) _flashes.removeAt(i);
    }

    for (int i = _comboTexts.length - 1; i >= 0; i--) {
      _comboTexts[i].update(dt);
      if (_comboTexts[i].isDead) _comboTexts.removeAt(i);
    }

    if (mounted) setState(() {});
  }

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

  void _handleDragStart(Piece piece, int slotIndex, Offset pointer) {
    _updateBoardGeometry();
    ref.read(gameControllerProvider.notifier).onDragStart(
          piece: piece,
          slotIndex: slotIndex,
          pointerPosition: pointer,
        );
  }

  void _handleDragUpdate(Offset pointer) {
    final controller = ref.read(gameControllerProvider.notifier);
    final DragInfo? drag = ref.read(gameControllerProvider).drag;
    if (drag == null) return;

    final double lift = _cellSize * 1.15;
    final double pieceLeft = pointer.dx - (drag.piece.width * _cellSize) / 2;
    final double pieceTop =
        pointer.dy - lift - (drag.piece.height * _cellSize) / 2;

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

  void _handleDragEnd() {
    final controller = ref.read(gameControllerProvider.notifier);
    final DragInfo? drag = ref.read(gameControllerProvider).drag;
    if (drag == null) return;
    controller.onDragEnd(
      ghostRow: drag.ghostRow,
      ghostCol: drag.ghostCol,
    );
  }

  void _triggerEffectsForLastPlacement(GameState s, ThemePalette palette) {
    if (s.effectTrigger == _lastEffectTrigger) return;
    _lastEffectTrigger = s.effectTrigger;

    if (s.lastClearedRows.isNotEmpty || s.lastClearedCols.isNotEmpty) {
      _flashes.add(
        LineFlash(
          rows: s.lastClearedRows,
          cols: s.lastClearedCols,
          duration: 0.45,
        ),
      );

      for (final r in s.lastClearedRows) {
        _particles.burstRow(
          y: _boardTop + (r + 0.5) * _cellSize,
          startX: _boardLeft,
          endX: _boardLeft + _boardSize,
          color: palette.accent,
          count: 16,
        );
      }
      for (final c in s.lastClearedCols) {
        _particles.burstCol(
          x: _boardLeft + (c + 0.5) * _cellSize,
          startY: _boardTop,
          endY: _boardTop + _boardSize,
          color: palette.accent,
          count: 16,
        );
      }
    }

    for (final cell in s.lastPlacementCells) {
      final double x = _boardLeft + (cell[1] + 0.5) * _cellSize;
      final double y = _boardTop + (cell[0] + 0.5) * _cellSize;
      final Color c = s.lastPlacementColor != null &&
              s.lastPlacementColor! >= 0 &&
              s.lastPlacementColor! < palette.blockColors.length
          ? palette.blockColors[s.lastPlacementColor!]
          : palette.accent;
      _particles.burstAt(
        center: Offset(x, y),
        color: c,
        count: 3,
        baseSpeed: 60,
        spread: 80,
        size: 3.5,
      );
    }
  }

  void _triggerComboEffects(GameState s, ThemePalette palette) {
    if (s.comboTrigger == _lastComboTrigger) return;
    _lastComboTrigger = s.comboTrigger;

    if (s.comboLabel.isNotEmpty) {
      _comboTexts.add(
        ComboText(
          text: s.comboLabel,
          color: palette.accent,
        ),
      );
    }

    final double intensity = 0.6 + s.combo * 0.15;
    _shake.trigger(
      intensity: intensity.clamp(0.6, 2.0),
      duration: 0.35,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final Size screen = MediaQuery.of(context).size;
    final double padding = screen.width * 0.04;
    final double boardSize = screen.width - padding * 2;
    final double cellSize = boardSize / 8;

    ref.listen<GameState>(gameControllerProvider, (prev, next) {
      _triggerEffectsForLastPlacement(next, palette);
      _triggerComboEffects(next, palette);
    });

    final bool isGameOver = ref.watch(
      gameControllerProvider.select((s) => s.isGameOver),
    );

    final Offset shakeOffset = _shake.currentOffset;
    final Offset boardOrigin = Offset(_boardLeft, _boardTop);

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
              Transform.translate(
                offset: shakeOffset,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 12),
                    const ScoreDisplay(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: RepaintBoundary(
                        key: _boardKey,
                        child: const BoardWidget(),
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
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: EffectsPainter(
                      particles: _particles.particles,
                      flashes: _flashes,
                      boardSize: _boardSize,
                      boardOrigin: boardOrigin,
                      palette: palette,
                    ),
                  ),
                ),
              ),
              ..._comboTexts.map(
                (c) => Positioned(
                  left: 0,
                  right: 0,
                  top: _boardTop + _boardSize * 0.35 + c.offsetY,
                  child: IgnorePointer(
                    child: Center(
                      child: ComboTextWidget(
                        text: c.text,
                        color: c.color,
                        opacity: c.opacity,
                        scale: c.scale,
                      ),
                    ),
                  ),
                ),
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
                              _particles.clear();
                              _flashes.clear();
                              _comboTexts.clear();
                              _lastEffectTrigger = 0;
                              _lastComboTrigger = 0;
                              ref
                                  .read(gameControllerProvider.notifier)
                                  .restart();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: palette.accent,
                              foregroundColor:
                                  palette.backgroundGradient.first,
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
