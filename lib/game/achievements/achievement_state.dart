import 'package:flutter/foundation.dart';

import '../../data/models/achievement_progress.dart';

@immutable
class AchievementState {
  const AchievementState({
    required this.progress,
    this.pendingToast,
    this.isLoaded = false,
  });

  final AchievementProgress progress;
  final String? pendingToast;
  final bool isLoaded;

  static const AchievementState empty = AchievementState(
    progress: AchievementProgress.empty,
  );

  AchievementState copyWith({
    AchievementProgress? progress,
    String? pendingToast,
    bool clearToast = false,
    bool? isLoaded,
  }) {
    return AchievementState(
      progress: progress ?? this.progress,
      pendingToast: clearToast ? null : (pendingToast ?? this.pendingToast),
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
