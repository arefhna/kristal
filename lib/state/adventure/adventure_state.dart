import 'package:flutter/foundation.dart';

import '../../data/models/adventure_progress.dart';

@immutable
class AdventureState {
  const AdventureState({
    required this.progress,
    this.isLoaded = false,
  });

  final AdventureProgress progress;
  final bool isLoaded;

  static const AdventureState empty = AdventureState(
    progress: AdventureProgress.empty,
  );

  AdventureState copyWith({
    AdventureProgress? progress,
    bool? isLoaded,
  }) {
    return AdventureState(
      progress: progress ?? this.progress,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
