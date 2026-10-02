class GameConstants {
  GameConstants._();

  static const int boardSize = 8;
  static const int piecesPerBatch = 3;

  static const int baseCellScore = 1;
  static const int lineClearBase = 10;
  static const int fullClearBaseBonus = 300;
  static const double comboStep = 0.5;
  static const double comboMaxMultiplier = 5.0;

  static const int difficultyScoreCap = 5000;
  static const double difficultySkillWeight = 0.5;
  static const double difficultySkillMin = -0.2;
  static const double difficultySkillMax = 0.3;
  static const int performanceWindow = 5;

  static const double rescueBoardFillThreshold = 0.70;
  static const double rescueSoftChance = 0.25;

  static const int bombBonus = 50;
  static const int iceBreakBonus = 20;

  static const int colorCount = 7;
}
