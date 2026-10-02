import 'dart:math';

import '../../core/utils/seeded_random.dart';

Random seededRandomAdapter(int seed) {
  final SeededRandom sr = SeededRandom(seed);
  final int baseSeed = sr.nextInt(0x7FFFFFFF);
  return Random(baseSeed);
}
