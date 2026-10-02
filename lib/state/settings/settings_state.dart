import 'package:flutter/foundation.dart';

import '../../core/theme/theme_palette.dart';

@immutable
class SettingsState {
  const SettingsState({
    required this.themeId,
    required this.hapticsEnabled,
    required this.soundEnabled,
    this.isLoaded = false,
  });

  final ThemeId themeId;
  final bool hapticsEnabled;
  final bool soundEnabled;
  final bool isLoaded;

  static const SettingsState initial = SettingsState(
    themeId: ThemeId.kristal,
    hapticsEnabled: true,
    soundEnabled: true,
  );

  SettingsState copyWith({
    ThemeId? themeId,
    bool? hapticsEnabled,
    bool? soundEnabled,
    bool? isLoaded,
  }) {
    return SettingsState(
      themeId: themeId ?? this.themeId,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
