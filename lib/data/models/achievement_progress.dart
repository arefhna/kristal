class AchievementProgress {
  const AchievementProgress({
    required this.unlockedIds,
    required this.seenIds,
  });

  final Set<String> unlockedIds;
  final Set<String> seenIds;

  static const AchievementProgress empty = AchievementProgress(
    unlockedIds: <String>{},
    seenIds: <String>{},
  );

  bool isUnlocked(String id) => unlockedIds.contains(id);
  bool isSeen(String id) => seenIds.contains(id);
  int get unlockedCount => unlockedIds.length;
  int get unseenCount =>
      unlockedIds.where((id) => !seenIds.contains(id)).length;

  AchievementProgress copyWith({
    Set<String>? unlockedIds,
    Set<String>? seenIds,
  }) {
    return AchievementProgress(
      unlockedIds: unlockedIds ?? this.unlockedIds,
      seenIds: seenIds ?? this.seenIds,
    );
  }
}
