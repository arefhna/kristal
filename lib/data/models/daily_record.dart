class DailyRecord {
  const DailyRecord({
    required this.dateKey,
    required this.score,
  });

  final String dateKey;
  final int score;

  static const DailyRecord empty = DailyRecord(
    dateKey: '',
    score: 0,
  );
}

class DailyProgress {
  const DailyProgress({
    required this.currentDateKey,
    required this.todayBestScore,
    required this.currentStreak,
    required this.lastPlayedDateKey,
    required this.totalDaysPlayed,
  });

  final String currentDateKey;
  final int todayBestScore;
  final int currentStreak;
  final String lastPlayedDateKey;
  final int totalDaysPlayed;

  static const DailyProgress empty = DailyProgress(
    currentDateKey: '',
    todayBestScore: 0,
    currentStreak: 0,
    lastPlayedDateKey: '',
    totalDaysPlayed: 0,
  );

  bool get hasPlayedToday =>
      currentDateKey.isNotEmpty && currentDateKey == lastPlayedDateKey;

  DailyProgress copyWith({
    String? currentDateKey,
    int? todayBestScore,
    int? currentStreak,
    String? lastPlayedDateKey,
    int? totalDaysPlayed,
  }) {
    return DailyProgress(
      currentDateKey: currentDateKey ?? this.currentDateKey,
      todayBestScore: todayBestScore ?? this.todayBestScore,
      currentStreak: currentStreak ?? this.currentStreak,
      lastPlayedDateKey: lastPlayedDateKey ?? this.lastPlayedDateKey,
      totalDaysPlayed: totalDaysPlayed ?? this.totalDaysPlayed,
    );
  }
}
