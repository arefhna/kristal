import 'dart:ui';

class Particle {
  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
    this.gravity = 120.0,
    this.friction = 0.985,
  }) : maxLife = life;

  Offset position;
  Offset velocity;
  Color color;
  double size;
  double life;
  final double maxLife;
  final double gravity;
  final double friction;

  bool get isDead => life <= 0;

  void update(double dt) {
    velocity = Offset(
      velocity.dx * friction,
      velocity.dy * friction + gravity * dt,
    );
    position = position + velocity * dt;
    life -= dt;
  }

  double get opacity {
    if (maxLife <= 0) return 0;
    final double t = (life / maxLife).clamp(0.0, 1.0);
    return t * t;
  }

  double get currentSize {
    final double t = (life / maxLife).clamp(0.0, 1.0);
    return size * (0.4 + t * 0.6);
  }
}
