import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';
import '../models/achievement_progress.dart';

class AchievementRepository {
  AchievementRepository(this._storage);

  final StorageService _storage;

  AchievementProgress load() {
    final List<String> unlocked =
        _storage.getStringList(StorageKeys.achievementsUnlocked);
    final List<String> seen =
        _storage.getStringList(StorageKeys.achievementsSeen);
    return AchievementProgress(
      unlockedIds: unlocked.toSet(),
      seenIds: seen.toSet(),
    );
  }

  Future<void> save(AchievementProgress progress) async {
    await _storage.setStringList(
      StorageKeys.achievementsUnlocked,
      progress.unlockedIds.toList(),
    );
    await _storage.setStringList(
      StorageKeys.achievementsSeen,
      progress.seenIds.toList(),
    );
  }

  Future<void> clear() async {
    await _storage.remove(StorageKeys.achievementsUnlocked);
    await _storage.remove(StorageKeys.achievementsSeen);
  }
}
