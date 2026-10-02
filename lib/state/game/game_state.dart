import 'package:flutter/foundation.dart';

import '../../game/game_engine.dart';
import '../../game/models/board.dart';
import '../../game/models/piece.dart';

@immutable
class DragInfo {
  const DragInfo({
    required this.piece,
    required this.slotIndex,
    required this.pointerPosition,
    this.ghostRow,
    this.ghostCol,
    this.isValidTarget = false,
  });

  final Piece piece;
  final int slotIndex;
  final Offset pointerPosition;
  final int? ghostRow;
  final int? ghostCol;
  final bool isValidTarget;

  DragInfo copyWith({
    Offset? pointerPosition,
    int? ghostRow,
    int? ghostCol,
    bool? isValidTarget,
    bool clearGhost = false,
  }) {
    return DragInfo(
      piece: piece,
      slotIndex: slotIndex,
      pointerPosition: pointerPosition ?? this.pointerPosition,
      ghostRow: clearGhost ? null : (ghostRow ?? this.ghostRow),
      ghostCol: clearGhost ? null : (ghostCol ?? this.ghostCol),
      isValidTarget: isValidTarget ?? this.isValidTarget,
    );
  }
}

@immutable
class GameState {
  const GameState({
    required this.board,
    required this.batch,
    required this.score,
    required this.combo,
    required this.bestCombo,
    required this.isGameOver,
    required this.difficulty,
    this.drag,
    this.lastGain = 0,
    this.batchKey = 0,
  });

  final Board board;
  final List<Piece?> batch;
  final int score;
  final int combo;
  final int bestCombo;
  final bool isGameOver;
  final double difficulty;
  final DragInfo? drag;
  final int lastGain;
  final int batchKey;

  factory GameState.initial() {
    return const GameState(
      board: null,
      batch: <Piece?>[],
      score: 0,
      combo: 0,
      bestCombo: 0,
      isGameOver: false,
      difficulty: 0.0,
    );
  }

  GameState copyWith({
    Board? board,
    List<Piece?>? batch,
    int? score,
    int? combo,
    int? bestCombo,
    bool? isGameOver,
    double? difficulty,
    DragInfo? drag,
    bool clearDrag = false,
    int? lastGain,
    int? batchKey,
  }) {
    return GameState(
      board: board ?? this.board,
      batch: batch ?? this.batch,
      score: score ?? this.score,
      combo: combo ?? this.combo,
      bestCombo: bestCombo ?? this.bestCombo,
      isGameOver: isGameOver ?? this.isGameOver,
      difficulty: difficulty ?? this.difficulty,
      drag: clearDrag ? null : (drag ?? this.drag),
      lastGain: lastGain ?? this.lastGain,
      batchKey: batchKey ?? this.batchKey,
    );
  }

  factory GameState.fromEngine(GameEngine engine, {DragInfo? drag, int? lastGain, int? batchKey}) {
    return GameState(
      board: engine.board,
      batch: engine.currentBatch,
      score: engine.score,
      combo: engine.combo,
      bestCombo: engine.bestCombo,
      isGameOver: engine.isGameOver,
      difficulty: engine.difficultyValue,
      drag: drag,
      lastGain: lastGain ?? 0,
      batchKey: batchKey ?? 0,
    );
  }
}
