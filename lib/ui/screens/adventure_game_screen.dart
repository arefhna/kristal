import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/theme/theme_palette.dart';
import '../../data/models/adventure_level.dart';
import '../../game/adventure/adventure_catalog.dart';
import '../../game/adventure/adventure_engine.dart';
import '../../game/models/piece.dart';
import '../../game/models/placement_result.dart';
import '../effects/line_flash.dart';
import '../effects/particle_system.dart';
import '../effects/screen_shake.dart';
import '../painters/background_painter.dart';
import '../painters/board_painter.dart';
import '../painters/effects_painter.dart';
import '../widgets/piece_tray.dart';
import '../widgets/score_display.dart';

class AdventureGameScreen extends StatefulWidget {
  const AdventureGameScreen({super.key, required this.levelId});

  final int levelId;

  @override
  State<AdventureGameScreen> createState() => _AdventureGameScreenState();
}

class _AdventureGameScreenState extends State<AdventureGameScreen>
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
    _level = AdventureCatalog.byId(widget.levelId) ?? AdventureCatalog.all.first;
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

    if (_ghostRow == null ||
        _ghostCol == null ||
        !_ghostValid) {
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
      _recordIfNeeded();
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
          color: _palette().accent,
          count: 16,
        );
      }
      for (final c in result.clearedCols) {
        _particles.burstCol(
          x: _boardLeft + (c + 0.5) * _cellSize,
          startY: _boardTop,
          endY: _boardTop + _boardSize,
          color: _palette().accent,
          count: 16,
        );
      }
    }

    if (result.iceBroken > 0) {
      for (final cell in piece.absoluteCells(row, col)) {
        final double x = _boardLeft + (cell[1] + 0.5) * _cellSize;
        final double y = _boardTop + (cell[0] + 0.5) * _cellSize;
        _particles.burstAt(
          center: Offset(x, y),
          color: const Color(0xFFB0D4F0),
          count: 4,
          baseSpeed: 80,
          spread: 100,
          size: 3.0,
        );
      }
    }
  }

  ThemePalette _palette() {
    final Brightness b = Theme.of(context).brightness;
    return b == Brightness.dark
        ? ThemePalette.kristal
        : ThemePalette.kristal;
  }

  Future<void> _recordIfNeeded() async {
    if (_engine.status == AdventureStatus.playing || _recorded) return;
    _recorded = true;

    if (_engine.status == AdventureStatus.victory) {
      final int stars = _engine.starsEarned();
      // Controller-ə yazacağıq (aşağıda ref ilə)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
