import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/ad_service.dart';
import '../core/services/sound_service.dart';
import '../core/services/storage_service.dart';
import '../core/theme/theme_palette.dart';
import '../data/repositories/game_save_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/stats_repository.dart';
import 'game/game_controller.dart';
import 'game/game_state.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_state.dart';
import 'stats/stats_controller.dart';
import 'stats/stats_state.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('main() daxilində override edilməlidir');
});

final soundServiceProvider = Provider<SoundService>((ref) {
  return NoOpSoundService();
});

final adServiceProvider = Provider<AdService>((ref) {
  return NoOpAdService();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(storageServiceProvider));
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(ref.watch(storageServiceProvider));
});

final gameSaveRepositoryProvider = Provider<GameSaveRepository>((ref) {
  return GameSaveRepository(ref.watch(storageServiceProvider));
});

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);

final statsControllerProvider =
    NotifierProvider<StatsController, StatsState>(StatsController.new);

final gameControllerProvider =
    NotifierProvider<GameController, GameState>(GameController.new);

final themePaletteProvider = Provider<ThemePalette>((ref) {
  final SettingsState settings = ref.watch(settingsControllerProvider);
  return ThemePalette.byId(settings.themeId);
});
