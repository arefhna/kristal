import 'package:flutter/foundation.dart';

import '../../data/models/daily_record.dart';

@immutable
class DailyState {
  const DailyState({
    required this.progress,
    required this.todaySeed,
    required this.todayDateKey,
    this.isLoaded = false,
  });

  final DailyProgress progress;
  final int todaySeed;
  final String todayDateKey;
  final bool isLoaded;

  static const DailyState empty = DailyState(
    progress: DailyProgress.empty,
    todaySeed: 0,
    todayDateKey: '',
  );

  DailyState copyWith({
    DailyProgress? progress,
    int? todaySeed,
    String? todayDateKey,
    bool? isLoaded,
  }) {
    return DailyState(
      progress: progress ?? this.progress,
      todaySeed: todaySeed ?? this.todaySeed,
      todayDateKey: todayDateKey ?? this.todayDateKey,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
