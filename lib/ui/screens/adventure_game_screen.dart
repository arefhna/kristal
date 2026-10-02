import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../data/models/adventure_level.dart';
import '../../game/adventure/adventure_catalog.dart';
import '../../game/adventure/adventure_engine.dart';
import '../../game/models/piece.dart';
import '../../game/models/placement_result.dart';
import '../../state/providers.dart';
import '../effects/line_flash.dart';
import '../effects/particle_system.dart';
import '../effects/screen_shake.dart';
import '../painters/background_painter.dart';
import '../painters/board_painter.dart';
import '../painters/effects_painter.dart';
import '../widgets/piece_tray.dart';

class AdventureGameScreen extends ConsumerStatefulWidget {
  const AdventureGameScreen({super.key, required this.levelId});

  final int levelId;

  @override
  ConsumerState<AdventureGameScreen> createState() =>
      _AdventureGameScreenState();
}

class _AdventureGameScreenState extends ConsumerState<AdventureGameScreen>
    with TickerProviderStateMixin {
  final GlobalKey _boardKey = GlobalKey();
  late final AdventureEngine _engine;
  late final AdventureLevel _level;
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  double _boardTop = 0;
  double _boardLeft = 0;
  double _boardSize = 0;
  double _cellSize = 0;

  Piece? _dragPiece;
  int _dragSlot = -1;
  Offset? _pointer;
  int? _ghostRow;
  int? _ghostCol;
  bool _ghostValid = false;

  final ParticleSystem _particles = ParticleSystem();
  final ScreenShake _shake = ScreenShake();
  final List<LineFlash> _flashes = <LineFlash>[];
  bool _paused = false;
  bool _recorded = false;

  @override
  void initState() {
    super.initState();
    _level =
        AdventureCatalog.byId(widget.levelId) ?? AdventureCatalog.all.first;
    _engine = AdventureEngine(level: _level);
    _engine.start();
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

    if (_paused) return;

    _particles.update(dt);
    _shake.update(dt);

    for (int i = _flashes.length - 1; i >= 0; i--) {
      _flashes[i].update(dt);
      if (_flashes[i].isDead) _flashes.removeAt(i);
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
    if (_paused || !_engine.isPlaying) return;
    _updateBoardGeometry();
    setState(() {
      _dragPiece = piece;
      _dragSlot = slotIndex;
      _pointer = pointer;
      _ghostRow = null;
      _ghostCol = null;
      _ghostValid = false;
    });
  }

  void _handleDragUpdate(Offset pointer) {
    if (_paused || _dragPiece == null || !_engine.isPlaying) return;
    final double lift = _cellSize * 1.15;
    final double pieceLeft =
        pointer.dx - (_dragPiece!.width * _cellSize) / 2;
    final double pieceTop =
        pointer.dy - lift - (_dragPiece!.height * _cellSize) / 2;

    final int col = ((pieceLeft - _boardLeft) / _cellSize).round();
    final int row = ((pieceTop - _boardTop) / _cellSize).round();

    final bool valid = _engine.canPlaceAt(_dragPiece!, row, col);

    setState(() {
      _pointer = pointer;
      _ghostRow = row;
      _ghostCol = col;
      _ghostValid = valid;
    });
  }

  Future<void> _handleDragEnd() async {
    if (_paused || _dragPiece == null || !_engine.isPlaying) {
      _clearDrag();
      return;
    }

    if (_ghostRow == null || _ghostCol == null || !_ghostValid) {
      _clearDrag();
      return;
    }

    final Piece piece = _dragPiece!;
    final int slot = _dragSlot;
    final int row = _ghostRow!;
    final int col = _ghostCol!;

    final PlacementResult result = _engine.tryPlace(
      piece: piece,
      originRow: row,
      originCol: col,
      batchSlot: slot,
    );

    if (result.isValid) {
      _triggerEffects(piece, row, col, result);
      await _recordIfNeeded();
    }

    _clearDrag();
  }

  void _clearDrag() {
    setState(() {
      _dragPiece = null;
      _dragSlot = -1;
      _pointer = null;
      _ghostRow = null;
      _ghostCol = null;
      _ghostValid = false;
    });
  }

  void _triggerEffects(
    Piece piece,
    int row,
    int col,
    PlacementResult result,
  ) {
    final ThemePalette palette = ref.read(themePaletteProvider);

    if (result.clearedRows.isNotEmpty || result.clearedCols.isNotEmpty) {
      _flashes.add(
        LineFlash(
          rows: result.clearedRows,
          cols: result.clearedCols,
          duration: 0.45,
        ),
      );

      for (final r in result.clearedRows) {
        _particles.burstRow(
          y: _boardTop + (r + 0.5) * _cellSize,
          startX: _boardLeft,
          endX: _boardLeft + _boardSize,
          color: palette.accent,
          count: 16,
        );
      }
      for (final c in result.clearedCols) {
        _particles.burstCol(
          x: _boardLeft + (c + 0.5) * _cellSize,
          startY: _boardTop,
          endY: _boardTop + _boardSize,
          color: palette.accent,
          count: 16,
        );
      }
    }
  }

  Future<void> _recordIfNeeded() async {
    if (_engine.status == AdventureStatus.playing || _recorded) return;
    _recorded = true;

    if (_engine.status == AdventureStatus.victory) {
      final int stars = _engine.starsEarned();
      await ref.read(adventureControllerProvider.notifier).recordLevelCompletion(
            levelId: _level.id,
            stars: stars,
          );
    }
  }

  void _restart() {
    _particles.clear();
    _flashes.clear();
    _recorded = false;
    _paused = false;
    _engine.start();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final Size screen = MediaQuery.of(context).size;
    final double padding = screen.width * 0.04;
    final double boardSize = screen.width - padding * 2;
    final double cellSize = boardSize / 8;

    final Offset shakeOffset = _shake.currentOffset;
    final Offset boardOrigin = Offset(_boardLeft, _boardTop);

    final List<List<int>> ghostCells = <List<int>>[];
    Color? ghostColor;
    if (_dragPiece != null &&
        _ghostRow != null &&
        _ghostCol != null &&
        _ghostValid) {
      ghostCells.addAll(
        _dragPiece!.absoluteCells(_ghostRow!, _ghostCol!),
      );
      final int idx = _dragPiece!.colorIndex;
      ghostColor = idx >= 0 && idx < palette.blockColors.length
          ? palette.blockColors[idx]
          : palette.blockColors.first;
    }

    final bool showVictory = _engine.status == AdventureStatus.victory;
    final bool showDefeat = _engine.status == AdventureStatus.defeat;

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
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: palette.textPrimary,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'SƏVİYYƏ ${_level.indexInWorld}  •  DÜNYA ${_level.world}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: palette.textSecondary,
                                fontSize: 11,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => _paused = true);
                            },
                            icon: Icon(
                              Icons.pause_rounded,
                              color: palette.textPrimary,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ObjectiveCard(
                      palette: palette,
                      label: _level.objective.label(),
                      current: _engine.tracker.current,
                      target: _engine.tracker.target,
                      progress: _engine.tracker.progress,
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: RepaintBoundary(
                        key: _boardKey,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CustomPaint(
                            painter: BoardPainter(
                              board: _engine.board,
                              palette: palette,
                              ghostCells: ghostCells,
                              ghostColor: ghostColor,
                            ),
                            size: Size.infinite,
                          ),
                        ),
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
                          onDragCancel: _clearDrag,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              if (_dragPiece != null && _pointer != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: _pointer!.dx -
                              (_dragPiece!.width * _cellSize) / 2,
                          top: _pointer!.dy -
                              _cellSize * 1.15 -
                              (_dragPiece!.height * _cellSize) / 2,
                          child: Opacity(
                            opacity: 0.85,
                            child: CustomPaint(
                              size: Size(
                                _dragPiece!.width * _cellSize,
                                _dragPiece!.height * _cellSize,
                              ),
                              painter: PieceDragPainter(
                                piece: _dragPiece!,
                                palette: palette,
                                cellSize: _cellSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
              if (showVictory)
                Positioned.fill(
                  child: _ResultOverlay(
                    palette: palette,
                    title: 'QƏLƏBƏ!',
                    stars: _engine.starsEarned(),
                    score: _engine.score,
                    primaryLabel: 'NÖVBƏTİ SƏVİYYƏ',
                    onPrimary: () {
                      Navigator.of(context).pop();
                    },
                    onSecondary: () {
                      Navigator.of(context).pop();
                    },
                    secondaryLabel: 'XƏRİTƏ',
                  ),
                ),
              if (showDefeat)
                Positioned.fill(
                  child: _ResultOverlay(
                    palette: palette,
                    title: 'UĞURSUZ',
                    stars: 0,
                    score: _engine.score,
                    primaryLabel: 'YENİDƏN',
                    onPrimary: _restart,
                    secondaryLabel: 'XƏRİTƏ',
                    onSecondary: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              if (_paused && !showVictory && !showDefeat)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Center(
                      child: TextButton(
                        onPressed: () => setState(() => _paused = false),
                        child: Text(
                          'DAVAM ET',
                          style: TextStyle(
                            color: palette.accent,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3.0,
                          ),
                        ),
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

class _ObjectiveCard extends StatelessWidget {
  const _ObjectiveCard({
    required this.palette,
    required this.label,
    required this.current,
    required this.target,
    required this.progress,
  });

  final ThemePalette palette;
  final String label;
  final int current;
  final int target;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final int displayCurrent = current > target ? target : current;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                  ),
                ),
                Text(
                  '$displayCurrent / $target',
                  style: TextStyle(
                    color: palette.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(palette.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultOverlay extends StatelessWidget {
  const _ResultOverlay({
    required this.palette,
    required this.title,
    required this.stars,
    required this.score,
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
  });

  final ThemePalette palette;
  final String title;
  final int stars;
  final int score;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String secondaryLabel;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4.0,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      i < stars
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: i < stars
                          ? palette.accent
                          : palette.textSecondary.withValues(alpha: 0.4),
                      size: 42,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Text(
                '$score',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onPrimary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.accent,
                  foregroundColor: palette.backgroundGradient.first,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  primaryLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onSecondary,
                child: Text(
                  secondaryLabel,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
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

class PieceDragPainter extends CustomPainter {
  PieceDragPainter({
    required this.piece,
    required this.palette,
    required this.cellSize,
  });

  final Piece piece;
  final ThemePalette palette;
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final double gap = cellSize * 0.06;
    final double radius = cellSize * 0.18;
    final Color blockColor =
        piece.colorIndex >= 0 && piece.colorIndex < palette.blockColors.length
            ? palette.blockColors[piece.colorIndex]
            : palette.blockColors.first;

    for (final c in piece.cells) {
      final Rect cellRect = Rect.fromLTWH(
        c[1] * cellSize + gap,
        c[0] * cellSize + gap,
        cellSize - gap * 2,
        cellSize - gap * 2,
      );
      final RRect rrect =
          RRect.fromRectAndRadius(cellRect, Radius.circular(radius));
      final Paint paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color.lerp(blockColor, Colors.white, 0.3) ?? blockColor,
            blockColor,
            Color.lerp(blockColor, Colors.black, 0.2) ?? blockColor,
          ],
        ).createShader(cellRect);
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PieceDragPainter old) => true;
}
