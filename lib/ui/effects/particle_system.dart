import 'dart:math';
import 'dart:ui';

import 'particle.dart';

class ParticleSystem {
  ParticleSystem({Random? random}) : _random = random ?? Random();

  final Random _random;
  final List<Particle> _particles = <Particle>[];

  List<Particle> get particles => _particles;
  bool get isEmpty => _particles.isEmpty;
  int get count => _particles.length;

  void burstAt({
    required Offset center,
    required Color color,
    int count = 14,
    double baseSpeed = 220.0,
    double spread = 220.0,
    double size = 5.0,
  }) {
    for (int i = 0; i < count; i++) {
      final double angle = _random.nextDouble() * 2 * pi;
      final double speed = baseSpeed + _random.nextDouble() * spread;
      final Offset velocity = Offset(cos(angle), sin(angle)) * speed;
      final double life = 0.55 + _random.nextDouble() * 0.35;
      final Color tinted = Color.lerp(
            color,
            const Color(0xFFFFFFFF),
            _random.nextDouble() * 0.4,
          ) ??
          color;

      _particles.add(
        Particle(
          position: center,
          velocity: velocity,
          color: tinted,
          size: size * (0.7 + _random.nextDouble() * 0.6),
          life: life,
        ),
      );
    }
  }

  void burstRow({
    required double y,
    required double startX,
    required double endX,
    required Color color,
    int count = 18,
  }) {
    for (int i = 0; i < count; i++) {
      final double t = i / (count - 1);
      final double x = startX + (endX - startX) * t;
      final double angle = -pi / 2 + (_random.nextDouble() - 0.5) * 1.2;
      final double speed = 120.0 + _random.nextDouble() * 120.0;
      final Offset velocity = Offset(cos(angle), sin(angle)) * speed;
      final double life = 0.6 + _random.nextDouble() * 0.3;

      _particles.add(
        Particle(
          position: Offset(x, y),
          velocity: velocity,
          color: color,
          size: 4.0 + _random.nextDouble() * 3.0,
          life: life,
          gravity: 200.0,
        ),
      );
    }
  }

  void burstCol({
    required double x,
    required double startY,
    required double endY,
    required Color color,
    int count = 18,
  }) {
    for (int i = 0; i < count; i++) {
      final double t = i / (count - 1);
      final double y = startY + (endY - startY) * t;
      final double angle = (_random.nextBool() ? 0 : pi) +
          (_random.nextDouble() - 0.5) * 1.2;
      final double speed = 120.0 + _random.nextDouble() * 120.0;
      final Offset velocity = Offset(cos(angle), sin(angle)) * speed;
      final double life = 0.6 + _random.nextDouble() * 0.3;

      _particles.add(
        Particle(
          position: Offset(x, y),
          velocity: velocity,
          color: color,
          size: 4.0 + _random.nextDouble() * 3.0,
          life: life,
          gravity: 200.0,
        ),
      );
    }
  }

  void update(double dt) {
    for (int i = _particles.length - 1; i >= 0; i--) {
      _particles[i].update(dt);
      if (_particles[i].isDead) {
        _particles.removeAt(i);
      }
    }
    if (_particles.length > 240) {
      _particles.removeRange(0, _particles.length - 240);
    }
  }

  void clear() => _particles.clear();
}
