import '../../core/constants/game_constants.dart';

class Difficulty {
  Difficulty({int window = GameConstants.performanceWindow})
      : _window = window;

  final int _window;
  final List<int> _recentClears = <int>[];

  void recordPlacement({required bool cleared}) {
    _recentClears.add(cleared ? 1 : 0);
    if (_recentClears.length > _window) {
      _recentClears.removeAt(0);
    }
  }

  double get recentClearRatio {
    if (_recentClears.isEmpty) return 0.4;
    int sum = 0;
    for (final v in _recentClears) {
      sum += v;
    }
    return sum / _recentClears.length;
  }

  double baseFromScore(int score) {
    final double r = score / GameConstants.difficultyScoreCap;
    return r.clamp(0.0, 1.0);
  }

  double skillAdjustment() {
    final double raw =
        (recentClearRatio - 0.4) * GameConstants.difficultySkillWeight;
    return raw.clamp(
      GameConstants.difficultySkillMin,
      GameConstants.difficultySkillMax,
    );
  }

  double compute(int score) {
    return (baseFromScore(score) + skillAdjustment()).clamp(0.0, 1.0);
  }

  void reset() => _recentClears.clear();

  List<int> get recentHistory => List<int>.unmodifiable(_recentClears);
}
