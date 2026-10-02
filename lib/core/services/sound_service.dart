enum SoundId {
  place,
  clear,
  combo,
  fullClear,
  gameOver,
  buttonTap,
}

abstract class SoundService {
  Future<void> initialize();
  Future<void> play(SoundId id);
  Future<void> setEnabled(bool enabled);
  Future<void> dispose();
}

class NoOpSoundService implements SoundService {
  bool _enabled = true;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> play(SoundId id) async {}

  @override
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
  }

  @override
  Future<void> dispose() async {}

  bool get isEnabled => _enabled;
}
