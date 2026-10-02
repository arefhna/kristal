import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/daily_record.dart';
import '../../data/repositories/daily_repository.dart';
import '../../game/daily_seed.dart';
import '../providers.dart';
import 'daily_state.dart';

class DailyController extends Notifier<DailyState> {
  late final DailyRepository _repo;

  @override
  DailyState build() {
    _repo = ref.watch(dailyRepositoryProvider);
    final DateTime now = DateTime.now();
    final DailyProgress progress = _repo.load(now: now);
    return DailyState(
      progress: progress,
      todaySeed: DailySeed.todaySeed(now),
      todayDateKey: DailySeed.todayKey(now),
      isLoaded: true,
    );
  }

  Future<void> recordScore(int score) async {
    final DailyProgress updated =
        await _repo.recordScore(score: score, now: DateTime.now());
    state = state.copyWith(progress: updated);
  }

  Future<void> refresh() async {
    final DateTime now = DateTime.now();
    final DailyProgress progress = _repo.load(now: now);
    state = DailyState(
      progress: progress,
      todaySeed: DailySeed.todaySeed(now),
      todayDateKey: DailySeed.todayKey(now),
      isLoaded: true,
    );
  }

  bool get hasPlayedToday => state.progress.hasPlayedToday;
}
