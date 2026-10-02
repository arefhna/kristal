import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/haptics.dart';
import '../../data/repositories/settings_repository.dart';
import '../providers.dart';
import 'settings_state.dart';

class SettingsController extends Notifier<SettingsState> {
  late final SettingsRepository _repo;

  @override
  SettingsState build() {
    _repo = ref.watch(settingsRepositoryProvider);
    final SettingsData data = _repo.load();
    Haptics.enabled = data.hapticsEnabled;
    return SettingsState(
      themeId: data.themeId,
      hapticsEnabled: data.hapticsEnabled,
      soundEnabled: data.soundEnabled,
      isLoaded: true,
    );
  }

  Future<void> setTheme(ThemeIdHolder value) async {}

  Future<void> toggleHaptics() async {
    final bool next = !state.hapticsEnabled;
    Haptics.enabled = next;
    state = state.copyWith(hapticsEnabled: next);
    await _repo.save(
      SettingsData(
        themeId: state.themeId,
        hapticsEnabled: next,
        soundEnabled: state.soundEnabled,
      ),
    );
    if (next) {
      await Haptics.selection();
    }
  }

  Future<void> toggleSound() async {
    final bool next = !state.soundEnabled;
    state = state.copyWith(soundEnabled: next);
    await _repo.save(
      SettingsData(
        themeId: state.themeId,
        hapticsEnabled: state.hapticsEnabled,
        soundEnabled: next,
      ),
    );
  }

  Future<void> updateTheme(ThemeIdHolder holder) async {
    state = state.copyWith(themeId: holder.id);
    await _repo.save(
      SettingsData(
        themeId: holder.id,
        hapticsEnabled: state.hapticsEnabled,
        soundEnabled: state.soundEnabled,
      ),
    );
  }
}

class ThemeIdHolder {
  const ThemeIdHolder(this.id);
  final ThemeId id;
}
