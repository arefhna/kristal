import 'dart:ui';

import 'block_colors.dart';

enum ThemeId { kristal, forest, night }

class ThemePalette {
  const ThemePalette({
    required this.id,
    required this.name,
    required this.backgroundGradient,
    required this.blockColors,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.boardBackground,
    required this.boardCell,
    required this.ghostColor,
  });

  final ThemeId id;
  final String name;
  final List<Color> backgroundGradient;
  final List<Color> blockColors;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color boardBackground;
  final Color boardCell;
  final Color ghostColor;

  static const ThemePalette kristal = ThemePalette(
    id: ThemeId.kristal,
    name: 'Kristal',
    backgroundGradient: <Color>[
      Color(0xFF1A1B3A),
      Color(0xFF2D1B4E),
      Color(0xFF1A1B3A),
    ],
    blockColors: BlockColors.kristal,
    accent: Color(0xFFE2C2FF),
    textPrimary: Color(0xFFF5F5FF),
    textSecondary: Color(0xFFB8B5D8),
    boardBackground: Color(0x33222244),
    boardCell: Color(0x22FFFFFF),
    ghostColor: Color(0x88FFFFFF),
  );

  static const ThemePalette forest = ThemePalette(
    id: ThemeId.forest,
    name: 'Meşə',
    backgroundGradient: <Color>[
      Color(0xFF1A2416),
      Color(0xFF2A3A22),
      Color(0xFF1A2416),
    ],
    blockColors: BlockColors.forest,
    accent: Color(0xFFB5EAD7),
    textPrimary: Color(0xFFF0F5E8),
    textSecondary: Color(0xFFB0BFA0),
    boardBackground: Color(0x33223322),
    boardCell: Color(0x22FFFFFF),
    ghostColor: Color(0x88FFFFFF),
  );

  static const ThemePalette night = ThemePalette(
    id: ThemeId.night,
    name: 'Gecə',
    backgroundGradient: <Color>[
      Color(0xFF0A0E1F),
      Color(0xFF1A1A3A),
      Color(0xFF0A0E1F),
    ],
    blockColors: BlockColors.night,
    accent: Color(0xFF8A9EFF),
    textPrimary: Color(0xFFE8ECFF),
    textSecondary: Color(0xFF9FA8D0),
    boardBackground: Color(0x33112233),
    boardCell: Color(0x22FFFFFF),
    ghostColor: Color(0x88AACCFF),
  );

  static const List<ThemePalette> all = <ThemePalette>[
    kristal,
    forest,
    night,
  ];

  static ThemePalette byId(ThemeId id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return kristal;
  }
}
