import 'dart:convert';

import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';
import '../models/adventure_progress.dart';

class AdventureRepository {
  AdventureRepository(this._storage);

  final StorageService _storage;

  AdventureProgress load() {
    final String raw = _storage.getString(StorageKeys.adventureProgress);
    if (raw.isEmpty) return AdventureProgress.empty;

    try {
      final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
      final List<dynamic> completed =
          (map['completed'] as List<dynamic>?) ?? <dynamic>[];
      final Map<String, dynamic> stars =
          (map['stars'] as Map<String, dynamic>?) ?? <String, dynamic>{};

      final Set<int> completedSet = completed
          .map((e) => (e as num).toInt())
          .toSet();
      final Map<int, int> starsMap = <int, int>{};
      stars.forEach((key, value) {
        starsMap[int.parse(key)] = (value as num).toInt();
      });

      int total = 0;
      for (final v in starsMap.values) {
        total += v;
      }

      return AdventureProgress(
        completedLevelIds: completedSet,
        levelStars: starsMap,
        totalStars: total,
      );
    } catch (_) {
      return AdventureProgress.empty;
    }
  }

  Future<void> save(AdventureProgress progress) async {
    final Map<String, dynamic> map = <String, dynamic>{
      'completed': progress.completedLevelIds.toList(),
      'stars': progress.levelStars.map(
        (k, v) => MapEntry<String, dynamic>(k.toString(), v),
      ),
    };
    await _storage.setString(
      StorageKeys.adventureProgress,
      jsonEncode(map),
    );
    await _storage.setInt(
      StorageKeys.adventureStarsTotal,
      progress.totalStars,
    );
  }

  Future<void> clear() async {
    await _storage.remove(StorageKeys.adventureProgress);
    await _storage.remove(StorageKeys.adventureStarsTotal);
  }
}
