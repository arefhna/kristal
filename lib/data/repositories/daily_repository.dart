import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';
import '../../game/daily_seed.dart';
import '../models/daily_record.dart';

class DailyRepository {
  DailyRepository(this._storage);

  final StorageService _storage;

  DailyProgress load({DateTime? now}) {
    final DateTime current = now ?? DateTime.now();
    final String todayKey = DailySeed.todayKey(current);

    final String storedDateKey =
        _storage.getString(StorageKeys.dailyCurrentDate);
    final bool sameDay = storedDateKey == todayKey;

    final int bestScore = sameDay
        ? _storage.getInt(StorageKeys.dailyBestScore)
        : _storage.getInt(
            StorageKeys.dailyScoreForDate(todayKey),
          );

    final String lastPlayed = _storage.getString(
      StorageKeys.dailyLastPlayedDate,
    );

    int streak = _storage.getInt(StorageKeys.dailyStreak);

    if (lastPlayed.isNotEmpty) {
      final DateTime lastPlayedDate = DailySeed.parseKey(lastPlayed);
      final bool yesterday = DailySeed.isYesterday(current, lastPlayedDate);
      final bool today = DailySeed.isSameDay(current, lastPlayedDate);
      if (!yesterday && !today) {
        streak = 0;
      }
    }

    return DailyProgress(
      currentDateKey: todayKey,
      todayBestScore: bestScore,
      currentStreak: streak,
      lastPlayedDateKey: lastPlayed,
      totalDaysPlayed: _storage.getInt(StorageKeys.dailyTotalPlayed),
    );
  }

  Future<DailyProgress> recordScore({
    required int score,
    DateTime? now,
  }) async {
    final DateTime current = now ?? DateTime.now();
    final String todayKey = DailySeed.todayKey(current);

    final String storedDateKey =
        _storage.getString(StorageKeys.dailyCurrentDate);
    final bool sameDay = storedDateKey == todayKey;

    final int previousBest = sameDay
        ? _storage.getInt(StorageKeys.dailyBestScore)
        : _storage.getInt(StorageKeys.dailyScoreForDate(todayKey));

    final int newBest = score > previousBest ? score : previousBest;
    final bool firstToday = !sameDay;

    await _storage.setString(StorageKeys.dailyCurrentDate, todayKey);
    await _storage.setInt(StorageKeys.dailyBestScore, newBest);
    await _storage.setInt(StorageKeys.dailyScoreForDate(todayKey), newBest);

    String lastPlayed =
        _storage.getString(StorageKeys.dailyLastPlayedDate);
    int streak = _storage.getInt(StorageKeys.dailyStreak);
    int totalPlayed = _storage.getInt(StorageKeys.dailyTotalPlayed);

    if (firstToday) {
      if (lastPlayed.isNotEmpty) {
        final DateTime lastDate = DailySeed.parseKey(lastPlayed);
        final bool yesterday = DailySeed.isYesterday(current, lastDate);
        streak = yesterday ? streak + 1 : 1;
      } else {
        streak = 1;
      }
      totalPlayed += 1;
      await _storage.setInt(StorageKeys.dailyStreak, streak);
      await _storage.setInt(StorageKeys.dailyTotalPlayed, totalPlayed);
    } else if (streak == 0) {
      streak = 1;
      totalPlayed += 1;
      await _storage.setInt(StorageKeys.dailyStreak, streak);
      await _storage.setInt(StorageKeys.dailyTotalPlayed, totalPlayed);
    }

    await _storage.setString(StorageKeys.dailyLastPlayedDate, todayKey);

    return DailyProgress(
      currentDateKey: todayKey,
      todayBestScore: newBest,
      currentStreak: streak,
      lastPlayedDateKey: todayKey,
      totalDaysPlayed: totalPlayed,
    );
  }

  Future<void> clear() async {
    await _storage.remove(StorageKeys.dailyCurrentDate);
    await _storage.remove(StorageKeys.dailyBestScore);
    await _storage.remove(StorageKeys.dailyStreak);
    await _storage.remove(StorageKeys.dailyLastPlayedDate);
    await _storage.remove(StorageKeys.dailyTotalPlayed);
  }
}
