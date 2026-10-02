import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/adventure_progress.dart';
import '../../data/repositories/adventure_repository.dart';
import '../providers.dart';
import 'adventure_state.dart';

class AdventureController extends Notifier<AdventureState> {
  late final AdventureRepository _repo;

  @override
  AdventureState build() {
    _repo = ref.watch(adventureRepositoryProvider);
    return AdventureState(progress: _repo.load(), isLoaded: true);
  }

  Future<void> recordLevelCompletion({
    required int levelId,
    required int stars,
  }) async {
    final AdventureProgress current = state.progress;
    final Set<int> completed = Set<int>.from(current.completedLevelIds)
      ..add(levelId);
    final Map<int, int> starsMap = Map<int, int>.from(current.levelStars);
    final int previousStars = starsMap[levelId] ?? 0;
    if (stars > previousStars) {
      starsMap[levelId] = stars;
    }

    int total = 0;
    for (final v in starsMap.values) {
      total += v;
    }

    final AdventureProgress updated = current.copyWith(
      completedLevelIds: completed,
      levelStars: starsMap,
      totalStars: total,
    );

    state = state.copyWith(progress: updated);
    await _repo.save(updated);
  }

  Future<void> reset() async {
    await _repo.clear();
    state = const AdventureState(progress: AdventureProgress.empty, isLoaded: true);
  }
}
