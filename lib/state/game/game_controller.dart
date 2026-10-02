import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/haptics.dart';
import '../../game/game_engine.dart';
import '../../game/models/board.dart';
import '../../game/models/piece.dart';
import '../../game/models/placement_result.dart';
import 'game_state.dart';

class GameController extends Notifier<GameState> {
  late final GameEngine _engine;
  int _batchKeyCounter = 0;
  int _effectTrigger = 0;
  int _comboTrigger = 0;

  @override
  GameState build() {
    _engine = GameEngine();
    _engine.start();
    return GameState.fromEngine(_engine, batchKey: _batchKeyCounter);
  }

  GameEngine get engine => _engine;

  void restart() {
    _engine.start();
    _batchKeyCounter++;
    _effectTrigger++;
    _comboTrigger++;
    state = GameState.fromEngine(
      _engine,
      batchKey: _batchKeyCounter,
      effectTrigger: _effectTrigger,
      comboTrigger: _comboTrigger,
    );
  }

  void onDragStart({
    required Piece piece,
    required int slotIndex,
    required Offset pointerPosition,
  }) {
    state = state.copyWith(
      drag: DragInfo(
        piece: piece,
        slotIndex: slotIndex,
        pointerPosition: pointerPosition,
      ),
    );
  }

  void onDragUpdate({
    required Offset pointerPosition,
    required int? ghostRow,
    required int? ghostCol,
    required bool isValid,
  }) {
    final DragInfo? current = state.drag;
    if (current == null) return;
    state = state.copyWith(
      drag: current.copyWith(
        pointerPosition: pointerPosition,
        ghostRow: ghostRow,
        ghostCol: ghostCol,
        isValidTarget: isValid,
        clearGhost: ghostRow == null || ghostCol == null,
      ),
    );
  }

  void onDragCancel() {
    state = state.copyWith(clearDrag: true);
  }

  PlacementResult? onDragEnd({
    required int? ghostRow,
    required int? ghostCol,
  }) {
    final DragInfo? current = state.drag;
    if (current == null) return null;

    if (ghostRow == null || ghostCol == null || !current.isValidTarget) {
      state = state.copyWith(clearDrag: true);
      return null;
    }

    final PlacementResult result = _engine.tryPlace(
      piece: current.piece,
      originRow: ghostRow,
      originCol: ghostCol,
      batchSlot: current.slotIndex,
    );

    if (!result.isValid) {
      state = state.copyWith(clearDrag: true);
      return null;
    }

    if (result.linesCleared > 0) {
      Haptics.medium();
    } else {
      Haptics.light();
    }
    if (result.isFullClear) {
      Haptics.heavy();
    }

    final List<List<int>> placedCells =
        current.piece.absoluteCells(ghostRow, ghostCol);

    _effectTrigger++;

    String comboLabel = '';
    if (result.comboCount >= 2) {
      _comboTrigger++;
      comboLabel = _labelForCombo(result.comboCount);
    }

    final bool batchRefilled = _engine.currentBatch.every((p) => p != null) &&
        state.batch.every(
          (p) => p == null || p!.id != _engine.currentBatch.first!.id,
        );

    if (batchRefilled) {
      _batchKeyCounter++;
    }

    state = GameState.fromEngine(
      _engine,
      lastGain: result.totalScore,
      batchKey: _batchKeyCounter,
      lastPlacementCells: placedCells,
      lastPlacementColor: current.piece.colorIndex,
      lastClearedRows: result.clearedRows,
      lastClearedCols: result.clearedCols,
      effectTrigger: _effectTrigger,
      comboTrigger: _comboTrigger,
      comboLabel: comboLabel,
    );

    return result;
  }

  String _labelForCombo(int combo) {
    if (combo <= 1) return '';
    if (combo == 2) return 'YAXŞI';
    if (combo == 3) return 'ƏLA';
    if (combo == 4) return 'MÖHTƏŞƏM';
    if (combo == 5) return 'İNANILMAZ';
    return 'EFSANE';
  }

  Board get board => _engine.board;
}
