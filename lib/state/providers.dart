import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme_palette.dart';
import 'game/game_controller.dart';
import 'game/game_state.dart';

final gameControllerProvider =
    NotifierProvider<GameController, GameState>(GameController.new);

final themePaletteProvider = Provider<ThemePalette>((ref) {
  return ThemePalette.kristal;
});
