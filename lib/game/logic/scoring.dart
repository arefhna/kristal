import '../../core/constants/game_constants.dart';

class Scoring {
  const Scoring();

  int baseScore(int cellsPlaced) => cellsPlaced * GameConstants.baseCellScore;

  int lineScore(int linesCleared) {
    if (linesCleared <= 0) return 0;
    return linesCleared * linesCleared * GameConstants.lineClearBase;
  }

  int fullClearBonus(int boardSize) {
    return GameConstants.fullClearBaseBonus + boardSize * boardSize;
  }

  double comboMultiplier(int comboCount) {
    if (comboCount <= 0) return 1.0;
    final double m = 1.0 + comboCount * GameConstants.comboStep;
    return m > GameConstants.comboMaxMultiplier
        ? GameConstants.comboMaxMultiplier
        : m;
  }

  int total({
    required int cellsPlaced,
    required int linesCleared,
    required bool isFullClear,
    required int boardSize,
    required int comboCount,
    int specialBonus = 0,
  }) {
    final int base = baseScore(cellsPlaced);
    final int lines = lineScore(linesCleared);
    final int fullClear = isFullClear ? fullClearBonus(boardSize) : 0;
    final double mult = comboMultiplier(comboCount);
    final int subtotal = base + lines + fullClear + specialBonus;
    return (subtotal * mult).round();
  }

  int nextComboCount(int currentCombo, int linesCleared) {
    if (linesCleared <= 0) return 0;
    return currentCombo + 1;
  }
}
