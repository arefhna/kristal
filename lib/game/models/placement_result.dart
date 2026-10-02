import 'board.dart';

class PlacementResult {
  const PlacementResult({
    required this.isValid,
    required this.newBoard,
    required this.cellsPlaced,
    required this.clearedRows,
    required this.clearedCols,
    required this.linesCleared,
    required this.baseScore,
    required this.lineScore,
    required this.fullClearBonus,
    required this.comboMultiplier,
    required this.comboCount,
    required this.totalScore,
    required this.isFullClear,
  });

  final bool isValid;
  final Board newBoard;
  final int cellsPlaced;
  final Set<int> clearedRows;
  final Set<int> clearedCols;
  final int linesCleared;
  final int baseScore;
  final int lineScore;
  final int fullClearBonus;
  final double comboMultiplier;
  final int comboCount;
  final int totalScore;
  final bool isFullClear;

  factory PlacementResult.invalid(Board board) {
    return PlacementResult(
      isValid: false,
      newBoard: board,
      cellsPlaced: 0,
      clearedRows: const <int>{},
      clearedCols: const <int>{},
      linesCleared: 0,
      baseScore: 0,
      lineScore: 0,
      fullClearBonus: 0,
      comboMultiplier: 1.0,
      comboCount: 0,
      totalScore: 0,
      isFullClear: false,
    );
  }

  @override
  String toString() =>
      'PlacementResult(valid=$isValid, lines=$linesCleared, score=$totalScore, combo=$comboCount)';
}
