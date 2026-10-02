import '../core/constants/game_constants.dart';
import 'generator/piece_generator.dart';
import 'logic/difficulty.dart';
import 'logic/line_clearer.dart';
import 'logic/placement_validator.dart';
import 'logic/scoring.dart';
import 'models/board.dart';
import 'models/piece.dart';
import 'models/placement_result.dart';

class GameEngine {
  GameEngine({
    Board? initialBoard,
    PieceGenerator? generator,
  })  : _board = initialBoard ?? Board.empty(),
        _generator = generator ?? PieceGenerator();

  Board _board;
  final PieceGenerator _generator;

  final PlacementValidator _validator = const PlacementValidator();
  final LineClearer _clearer = const LineClearer();
  final Scoring _scoring = const Scoring();
  final Difficulty _difficulty = Difficulty();

  int _score = 0;
  int _combo = 0;
  int _bestCombo = 0;
  int _totalPlacements = 0;
  int _totalLines = 0;
  List<Piece?> _currentBatch = <Piece?>[];
  bool _gameOver = false;

  Board get board => _board;
  int get score => _score;
  int get combo => _combo;
  int get bestCombo => _bestCombo;
  int get totalPlacements => _totalPlacements;
  int get totalLines => _totalLines;
  List<Piece?> get currentBatch => List<Piece?>.unmodifiable(_currentBatch);
  bool get isGameOver => _gameOver;
  double get difficultyValue => _difficulty.compute(_score);

  void start() {
    _board = Board.empty();
    _score = 0;
    _combo = 0;
    _bestCombo = 0;
    _totalPlacements = 0;
    _totalLines = 0;
    _gameOver = false;
    _difficulty.reset();
    _generator.reset();
    _currentBatch = _generator.generateBatch(
      board: _board,
      difficulty: 0.0,
      currentPieces: const <Piece?>[],
    );
    _checkGameOver();
  }

  PlacementResult tryPlace({
    required Piece piece,
    required int originRow,
    required int originCol,
    required int batchSlot,
  }) {
    if (_gameOver) return PlacementResult.invalid(_board);
    if (batchSlot < 0 || batchSlot >= _currentBatch.length) {
      return PlacementResult.invalid(_board);
    }
    if (_currentBatch[batchSlot]?.id != piece.id) {
      return PlacementResult.invalid(_board);
    }

    if (!_validator.canPlace(_board, piece, originRow, originCol)) {
      return PlacementResult.invalid(_board);
    }

    final List<List<int>> absCells = piece.absoluteCells(originRow, originCol);
    final Board placedBoard = _board.withCells(absCells, piece.colorIndex);

    final LineClearResult clearResult = _clearer.findFullLines(placedBoard);
    final Board finalBoard = clearResult.hasClears
        ? _clearer.clear(placedBoard, clearResult)
        : placedBoard;

    final bool isFullClear =
        clearResult.hasClears && finalBoard.isCompletelyEmpty;

    final int newCombo =
        _scoring.nextComboCount(_combo, clearResult.linesCleared);
    final int comboForMultiplier =
        clearResult.linesCleared > 0 ? newCombo : _combo;

    final int gained = _scoring.total(
      cellsPlaced: piece.cellCount,
      linesCleared: clearResult.linesCleared,
      isFullClear: isFullClear,
      boardSize: _board.size,
      comboCount: comboForMultiplier,
    );

    _board = finalBoard;
    _score += gained;
    _combo = newCombo;
    if (_combo > _bestCombo) _bestCombo = _combo;
    _totalPlacements += 1;
    _totalLines += clearResult.linesCleared;
    _difficulty.recordPlacement(cleared: clearResult.linesCleared > 0);

    _currentBatch = List<Piece?>.from(_currentBatch);
    _currentBatch[batchSlot] = null;

    if (_currentBatch.every((p) => p == null)) {
      _currentBatch = _generator.generateBatch(
        board: _board,
        difficulty: difficultyValue,
        currentPieces: const <Piece?>[],
      );
    }

    _checkGameOver();

    return PlacementResult(
      isValid: true,
      newBoard: _board,
      cellsPlaced: piece.cellCount,
      clearedRows: clearResult.rows,
      clearedCols: clearResult.cols,
      linesCleared: clearResult.linesCleared,
      baseScore: _scoring.baseScore(piece.cellCount),
      lineScore: _scoring.lineScore(clearResult.linesCleared),
      fullClearBonus: isFullClear ? _scoring.fullClearBonus(_board.size) : 0,
      comboMultiplier: _scoring.comboMultiplier(comboForMultiplier),
      comboCount: _combo,
      totalScore: gained,
      isFullClear: isFullClear,
    );
  }

  void _checkGameOver() {
    if (_gameOver) return;
    final bool anyPieceLeft = _currentBatch.any((p) => p != null);
    if (!anyPieceLeft) return;
    if (_validator.noPieceFits(_board, _currentBatch)) {
      _gameOver = true;
    }
  }

  bool canPlaceAt(Piece piece, int originRow, int originCol) {
    return _validator.canPlace(_board, piece, originRow, originCol);
  }

  List<Piece?> get activePieces =>
      _currentBatch.where((p) => p != null).toList(growable: false);

  int activePieceCount() => activePieces.length;
}
