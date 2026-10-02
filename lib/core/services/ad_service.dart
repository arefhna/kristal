abstract class AdService {
  Future<void> initialize();
  Future<bool> showRewardedContinue();
  bool get isRewardedAvailable;
  Future<void> dispose();
}

class NoOpAdService implements AdService {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> showRewardedContinue() async => false;

  @override
  bool get isRewardedAvailable => false;

  @override
  Future<void> dispose() async {}
}
