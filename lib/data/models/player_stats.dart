class PlayerStats {
  const PlayerStats({
    required this.bestScore,
    required this.totalGames,
    required this.totalLines,
    required this.longestCombo,
    required this.totalScore,
  });

  final int bestScore;
  final int totalGames;
  final int totalLines;
  final int longestCombo;
  final int totalScore;

  static const PlayerStats empty = PlayerStats(
    bestScore: 0,
    totalGames: 0,
    totalLines: 0,
    longestCombo: 0,
    totalScore: 0,
  );

  PlayerStats copyWith({
    int? bestScore,
    int? totalGames,
    int? totalLines,
    int? longestCombo,
    int? totalScore,
  }) {
    return PlayerStats(
      bestScore: bestScore ?? this.bestScore,
      totalGames: totalGames ?? this.totalGames,
      totalLines: totalLines ?? this.totalLines,
      longestCombo: longestCombo ?? this.longestCombo,
      totalScore: totalScore ?? this.totalScore,
    );
  }

  double get averageScore {
    if (totalGames == 0) return 0;
    return totalScore / totalGames;
  }
}
