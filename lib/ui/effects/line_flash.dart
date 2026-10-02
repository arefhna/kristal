import 'dart:ui';

class LineFlash {
  LineFlash({
    required this.rows,
    required this.cols,
    required this.duration,
  }) : elapsed = 0.0;

  final Set<int> rows;
  final Set<int> cols;
  final double duration;
  double elapsed;

  bool get isDead => elapsed >= duration;

  double get progress => (elapsed / duration).clamp(0.0, 1.0);

  void update(double dt) {
    elapsed += dt;
  }
}
