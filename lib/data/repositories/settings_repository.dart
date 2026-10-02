import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/theme_palette.dart';

class SettingsData {
  const SettingsData({
    required this.themeId,
    required this.hapticsEnabled,
    required this.soundEnabled,
  });

  final ThemeId themeId;
  final bool hapticsEnabled;
  final bool soundEnabled;

  static const SettingsData defaults = SettingsData(
    themeId: ThemeId.kristal,
    hapticsEnabled: true,
    soundEnabled: true,
  );
}

class SettingsRepository {
  SettingsRepository(this._storage);

  final StorageService _storage;

  SettingsData load() {
    final String themeName = _storage.getString(
      StorageKeys.settingsTheme,
      defaultValue: ThemeId.kristal.name,
    );

    ThemeId themeId = ThemeId.kristal;
    for (final id in ThemeId.values) {
      if (id.name == themeName) {
        themeId = id;
        break;
      }
    }

    return SettingsData(
      themeId: themeId,
      hapticsEnabled: _storage.getBool(
        StorageKeys.settingsHaptics,
        defaultValue: true,
      ),
      soundEnabled: _storage.getBool(
        StorageKeys.settingsSound,
        defaultValue: true,
      ),
    );
  }

  Future<void> save(SettingsData data) async {
    await _storage.setString(StorageKeys.settingsTheme, data.themeId.name);
    await _storage.setBool(StorageKeys.settingsHaptics, data.hapticsEnabled);
    await _storage.setBool(StorageKeys.settingsSound, data.soundEnabled);
  }
}
