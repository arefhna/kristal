class AdventureProgress {
  const AdventureProgress({
    required this.completedLevelIds,
    required this.levelStars,
    required this.totalStars,
  });

  final Set<int> completedLevelIds;
  final Map<int, int> levelStars;
  final int totalStars;

  static const AdventureProgress empty = AdventureProgress(
    completedLevelIds: <int>{},
    levelStars: <int, int>{},
    totalStars: 0,
  );

  int starsFor(int levelId) => levelStars[levelId] ?? 0;

  bool isCompleted(int levelId) => completedLevelIds.contains(levelId);

  bool isUnlocked(int levelId) {
    if (levelId <= 1) return true;
    return completedLevelIds.contains(levelId - 1);
  }

  AdventureProgress copyWith({
    Set<int>? completedLevelIds,
    Map<int, int>? levelStars,
    int? totalStars,
  }) {
    return AdventureProgress(
      completedLevelIds: completedLevelIds ?? this.completedLevelIds,
      levelStars: levelStars ?? this.levelStars,
      totalStars: totalStars ?? this.totalStars,
    );
  }
}
