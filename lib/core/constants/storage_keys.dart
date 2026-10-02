class StorageKeys {
  StorageKeys._();

  static const String bestScore = 'best_score';
  static const String totalGames = 'total_games';
  static const String totalLines = 'total_lines';
  static const String longestCombo = 'longest_combo';
  static const String totalScore = 'total_score';

  static const String settingsTheme = 'settings_theme';
  static const String settingsHaptics = 'settings_haptics';
  static const String settingsSound = 'settings_sound';

  static const String saveBoard = 'save_board';
  static const String saveBatch = 'save_batch';
  static const String saveScore = 'save_score';
  static const String saveCombo = 'save_combo';
  static const String saveBestCombo = 'save_best_combo';
  static const String saveExists = 'save_exists';

  static const String dailyCurrentDate = 'daily_current_date';
  static const String dailyBestScore = 'daily_best_score';
  static const String dailyStreak = 'daily_streak';
  static const String dailyLastPlayedDate = 'daily_last_played_date';
  static const String dailyTotalPlayed = 'daily_total_played';

  static const String adventureProgress = 'adventure_progress';
  static const String adventureStarsTotal = 'adventure_stars_total';

  static const String achievementsUnlocked = 'achievements_unlocked';
  static const String achievementsSeen = 'achievements_seen';

  static String dailyScoreForDate(String dateKey) => 'daily_score_$dateKey';
}
