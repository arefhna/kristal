class PieceWeights {
  PieceWeights._();

  static Map<String, double> forDifficulty(double d) {
    final double t1 = (d / 0.5).clamp(0.0, 1.0);
    final double t2 = ((d - 0.5) / 0.5).clamp(0.0, 1.0);

    double lerp(double a, double b, double c) {
      if (d <= 0.5) return a + (b - a) * t1;
      return b + (c - b) * t2;
    }

    return <String, double>{
      'single': lerp(0.06, 0.03, 0.02),
      'h2': lerp(0.10, 0.05, 0.02),
      'v2': lerp(0.10, 0.05, 0.02),
      'h3': lerp(0.12, 0.09, 0.06),
      'v3': lerp(0.12, 0.09, 0.06),
      'o2': lerp(0.08, 0.06, 0.04),
      'lSmall': lerp(0.08, 0.06, 0.05),
      'jSmall': lerp(0.08, 0.06, 0.05),
      'tSmall': lerp(0.06, 0.06, 0.05),
      'sSmall': lerp(0.06, 0.06, 0.05),
      'zSmall': lerp(0.06, 0.06, 0.05),
      'h4': lerp(0.04, 0.06, 0.07),
      'v4': lerp(0.04, 0.06, 0.07),
      'h5': lerp(0.00, 0.04, 0.06),
      'v5': lerp(0.00, 0.04, 0.06),
      'lBig': lerp(0.00, 0.04, 0.06),
      'jBig': lerp(0.00, 0.04, 0.06),
      'r23': lerp(0.00, 0.03, 0.05),
      'r32': lerp(0.00, 0.03, 0.05),
      'o3': lerp(0.00, 0.02, 0.05),
    };
  }

  static Map<String, double> rescueWeights() {
    return <String, double>{
      'single': 0.45,
      'h2': 0.20,
      'v2': 0.20,
      'h3': 0.08,
      'v3': 0.07,
    };
  }

  static const Set<String> smallShapes = <String>{
    'single',
    'h2',
    'v2',
    'h3',
    'v3',
  };
}
