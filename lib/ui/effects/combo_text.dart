import 'dart:ui';

class ComboText {
  ComboText({
    required this.text,
    required this.color,
    this.duration = 1.1,
    this.startY = 0.0,
  }) : elapsed = 0.0;

  final String text;
  final Color color;
  final double duration;
  final double startY;
  double elapsed;

  bool get isDead => elapsed >= duration;

  double get progress => (elapsed / duration).clamp(0.0, 1.0);

  double get opacity {
    final double p = progress;
    if (p < 0.15) return p / 0.15;
    if (p > 0.75) return (1.0 - p) / 0.25;
    return 1.0;
  }

  double get scale {
    final double p = progress;
    if (p < 0.25) {
      return 0.6 + (p / 0.25) * 0.55;
    }
    if (p > 0.7) {
      return 1.15 - ((p - 0.7) / 0.3) * 0.15;
    }
    return 1.15 - (p - 0.25) * 0.1;
  }

  double get offsetY => -progress * 60.0;

  void update(double dt) {
    elapsed += dt;
  }
}

class ComboTextFactory {
  ComboTextFactory._();

  static const List<String> comboNames = <String>[
    '',
    'YAXŞI',
    'ƏLA',
    'MÖHTƏŞƏM',
    'İNANILMAZ',
    'EFSANE',
  ];

  static String nameFor(int combo) {
    if (combo <= 0) return '';
    if (combo >= comboNames.length) return comboNames.last;
    return comboNames[combo];
  }
}
