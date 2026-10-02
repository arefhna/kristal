import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/achievement_progress.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../game/achievements/achievement_catalog.dart';
import '../../game/achievements/achievement_checker.dart';
import '../providers.dart';
import 'achievement_state.dart';

class AchievementController extends Notifier<AchievementState> {
  late final AchievementRepository _repo;

  @override
  AchievementState build() {
    _repo = ref.watch(achievementRepositoryProvider);
    return AchievementState(
      progress: _repo.load(),
      isLoaded: true,
    );
  }

  Future<void> evaluateAndUnlock({
    required int lastCombo,
    required bool lastWasFullClear,
  }) async {
    final stats = ref.read(statsControllerProvider).stats;
    final daily = ref.read(dailyControllerProvider).progress;
    final adventure = ref.read(adventureControllerProvider).progress;

    final Set<String> unlocked = AchievementChecker.check(
      stats: stats,
      daily: daily,
      adventure: adventure,
      current: state.progress,
      lastCombo: lastCombo,
      lastWasFullClear: lastWasFullClear,
    );

    final Set<String> newlyUnlocked = unlocked.difference(
      state.progress.unlockedIds,
    );

    if (newlyUnlocked.isEmpty) return;

    final AchievementProgress updated = state.progress.copyWith(
      unlockedIds: unlocked,
    );

    String? toast = state.pendingToast;
    if (toast == null && newlyUnlocked.isNotEmpty) {
      final String firstId = newlyUnlocked.first;
      final achievement = AchievementCatalog.byId(firstId);
      if (achievement != null) {
        toast = achievement.title;
      }
    }

    state = state.copyWith(
      progress: updated,
      pendingToast: toast,
    );

    await _repo.save(updated);
  }

  Future<void> markAllSeen() async {
    final AchievementProgress updated = state.progress.copyWith(
      seenIds: Set<String>.from(state.progress.unlockedIds),
    );
    state = state.copyWith(progress: updated);
    await _repo.save(updated);
  }

  void clearToast() {
    state = state.copyWith(clearToast: true);
  }

  Future<void> reset() async {
    await _repo.clear();
    state = const AchievementState(
      progress: AchievementProgress.empty,
      isLoaded: true,
    );
  }
}
