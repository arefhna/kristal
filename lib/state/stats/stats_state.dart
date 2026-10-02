import 'package:flutter/foundation.dart';

import '../../data/models/player_stats.dart';

@immutable
class StatsState {
  const StatsState({
    required this.stats,
    this.isLoaded = false,
  });

  final PlayerStats stats;
  final bool isLoaded;

  static const StatsState initial = StatsState(stats: PlayerStats.empty);

  StatsState copyWith({PlayerStats? stats, bool? isLoaded}) {
    return StatsState(
      stats: stats ?? this.stats,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
