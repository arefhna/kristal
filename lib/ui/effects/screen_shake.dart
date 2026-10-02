import 'dart:math';
import 'dart:ui';

class ScreenShake {
  ScreenShake({Random? random}) : _random = random ?? Random();

  final Random _random;
  double _timeLeft = 0.0;
  double _intensity = 0.0;

  void trigger({required double intensity, required double duration}) {
    _intensity = intensity;
    _timeLeft = duration;
  }

  void update(double dt) {
    if (_timeLeft > 0) {
      _timeLeft -= dt;
      if (_timeLeft < 0) _timeLeft = 0;
    }
  }

  Offset get currentOffset {
    if (_timeLeft <= 0) return Offset.zero;
    final double t = _timeLeft;
    final double amplitude = _intensity * t * 4;
    return Offset(
      (_random.nextDouble() - 0.5) * amplitude,
      (_random.nextDouble() - 0.5) * amplitude,
    );
  }

  bool get isActive => _timeLeft > 0;
}
