import '../../data/models/achievement_progress.dart';
import '../../data/models/adventure_progress.dart';
import '../../data/models/daily_record.dart';
import '../../data/models/player_stats.dart';

class AchievementChecker {
  AchievementChecker._();

  static Set<String> check({
    required PlayerStats stats,
    required DailyProgress daily,
    required AdventureProgress adventure,
    required AchievementProgress current,
    required int lastCombo,
    required bool lastWasFullClear,
  }) {
    final Set<String> unlocked = Set<String>.from(current.unlockedIds);

    void tryUnlock(String id, bool condition) {
      if (condition) unlocked.add(id);
    }

    tryUnlock('first_game', stats.totalGames >= 1);
    tryUnlock('games_10', stats.totalGames >= 10);
    tryUnlock('master_10_games', stats.totalGames >= 10);
    tryUnlock('games_50', stats.totalGames >= 50);

    tryUnlock('score_500', stats.bestScore >= 500);
    tryUnlock('score_1000', stats.bestScore >= 1000);
    tryUnlock('score_2500', stats.bestScore >= 2500);
    tryUnlock('score_5000', stats.bestScore >= 5000);

    tryUnlock('combo_5', stats.longestCombo >= 5 || lastCombo >= 5);
    tryUnlock('combo_8', stats.longestCombo >= 8 || lastCombo >= 8);

    tryUnlock('lines_100', stats.totalLines >= 100);
    tryUnlock('lines_500', stats.totalLines >= 500);

    tryUnlock('daily_first', daily.totalDaysPlayed >= 1);
    tryUnlock('daily_streak_3', daily.currentStreak >= 3);
    tryUnlock('daily_streak_7', daily.currentStreak >= 7);
    tryUnlock('daily_streak_30', daily.currentStreak >= 30);

    tryUnlock('adventure_first', adventure.completedLevelIds.isNotEmpty);
    tryUnlock(
      'adventure_world_1',
      _allCompletedInRange(adventure.completedLevelIds, 1, 10),
    );
    tryUnlock(
      'adventure_world_2',
      _allCompletedInRange(adventure.completedLevelIds, 11, 20),
    );
    tryUnlock(
      'adventure_world_3',
      _allCompletedInRange(adventure.completedLevelIds, 21, 30),
    );
    tryUnlock('stars_50', adventure.totalStars >= 50);
    tryUnlock('stars_90', adventure.totalStars >= 90);

    tryUnlock('perfect_clear', lastWasFullClear);

    return unlocked;
  }

  static bool _allCompletedInRange(Set<int> completed, int from, int to) {
    for (int i = from; i <= to; i++) {
      if (!completed.contains(i)) return false;
    }
    return true;
  }
}
