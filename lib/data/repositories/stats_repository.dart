import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';
import '../models/player_stats.dart';

class StatsRepository {
  StatsRepository(this._storage);

  final StorageService _storage;

  PlayerStats load() {
    return PlayerStats(
      bestScore: _storage.getInt(StorageKeys.bestScore),
      totalGames: _storage.getInt(StorageKeys.totalGames),
      totalLines: _storage.getInt(StorageKeys.totalLines),
      longestCombo: _storage.getInt(StorageKeys.longestCombo),
      totalScore: _storage.getInt(StorageKeys.totalScore),
    );
  }

  Future<void> save(PlayerStats stats) async {
    await _storage.setInt(StorageKeys.bestScore, stats.bestScore);
    await _storage.setInt(StorageKeys.totalGames, stats.totalGames);
    await _storage.setInt(StorageKeys.totalLines, stats.totalLines);
    await _storage.setInt(StorageKeys.longestCombo, stats.longestCombo);
    await _storage.setInt(StorageKeys.totalScore, stats.totalScore);
  }

  Future<void> clear() async {
    await _storage.remove(StorageKeys.bestScore);
    await _storage.remove(StorageKeys.totalGames);
    await _storage.remove(StorageKeys.totalLines);
    await _storage.remove(StorageKeys.longestCombo);
    await _storage.remove(StorageKeys.totalScore);
  }
}
