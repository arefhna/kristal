import 'dart:math';

class SeededRandom {
  SeededRandom(int seed) : _state = (seed == 0 ? 1 : seed) & 0x7FFFFFFF {
    for (int i = 0; i < 8; i++) {
      _next();
    }
  }

  factory SeededRandom.fromDate(DateTime date) {
    final int seed = date.year * 10000 + date.month * 100 + date.day;
    return SeededRandom(seed);
  }

  int _state;

  int _next() {
    _state = (_state * 48271) % 0x7FFFFFFF;
    return _state;
  }

  double nextDouble() => _next() / 0x7FFFFFFF;

  int nextInt(int max) {
    if (max <= 0) {
      throw ArgumentError('max musbet olmalidir');
    }
    return (nextDouble() * max).floor().clamp(0, max - 1);
  }

  T weightedPick<T>(List<T> items, List<double> weights) {
    assert(items.length == weights.length);
    double total = 0;
    for (final double w in weights) {
      total += w;
    }
    if (total <= 0) {
      return items[nextInt(items.length)];
    }
    double r = nextDouble() * total;
    for (int i = 0; i < items.length; i++) {
      r -= weights[i];
      if (r <= 0) return items[i];
    }
    return items.last;
  }
}

int systemSeed() => DateTime.now().microsecondsSinceEpoch & 0x7FFFFFFF;

Random createSystemRandom() => Random(systemSeed());
