import '../../data/models/adventure_level.dart';

class ObjectiveTracker {
  ObjectiveTracker(this.objective);

  final LevelObjective objective;

  int _current = 0;

  int get current => _current;
  int get target => objective.target;

  bool get isComplete => _current >= objective.target;

  double get progress {
    if (objective.target <= 0) return 1.0;
    return (_current / objective.target).clamp(0.0, 1.0);
  }

  void update({
    required int linesCleared,
    required int iceBroken,
    required int score,
    required int batchCount,
  }) {
    switch (objective.type) {
      case ObjectiveType.clearLines:
        _current += linesCleared;
        break;
      case ObjectiveType.breakIce:
        _current += iceBroken;
        break;
      case ObjectiveType.reachScore:
        _current = score;
        break;
      case ObjectiveType.surviveBatch:
        _current = batchCount;
        break;
    }
  }

  void reset() {
    _current = 0;
  }
}
