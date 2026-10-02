import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/player_stats.dart';
import '../../data/repositories/stats_repository.dart';
import '../providers.dart';
import 'stats_state.dart';

class StatsController extends Notifier<StatsState> {
  late final StatsRepository _repo;

  @override
  StatsState build() {
    _repo = ref.watch(statsRepositoryProvider);
    final PlayerStats stats = _repo.load();
    return StatsState(stats: stats, isLoaded: true);
  }

  Future<void> recordGameEnd({
    required int score,
    required int lines,
    required int longestCombo,
  }) async {
    final PlayerStats current = state.stats;
    final PlayerStats updated = current.copyWith(
      bestScore: score > current.bestScore ? score : current.bestScore,
      totalGames: current.totalGames + 1,
      totalLines: current.totalLines + lines,
      longestCombo:
          longestCombo > current.longestCombo ? longestCombo : current.longestCombo,
      totalScore: current.totalScore + score,
    );
    state = state.copyWith(stats: updated);
    await _repo.save(updated);
  }

  Future<void> reset() async {
    await _repo.clear();
    state = const StatsState(stats: PlayerStats.empty, isLoaded: true);
  }
}
