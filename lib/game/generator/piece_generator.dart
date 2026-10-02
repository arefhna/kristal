import 'dart:math';

import '../../core/constants/game_constants.dart';
import '../../core/utils/seeded_random.dart';
import '../models/board.dart';
import '../models/piece.dart';
import '../models/piece_shape.dart';
import 'piece_weights.dart';
import 'rescue_logic.dart';

class PieceGenerator {
  PieceGenerator({
    Random? random,
    RescueLogic? rescueLogic,
  })  : _random = random ?? createSystemRandom(),
        _rescue = rescueLogic ?? RescueLogic();

  final Random _random;
  final RescueLogic _rescue;
  int _nextId = 1;

  int get lastId => _nextId - 1;

  List<Piece?> generateBatch({
    required Board board,
    required double difficulty,
    required List<Piece?> currentPieces,
  }) {
    final double roll = _random.nextDouble();
    final RescueDecision decision = _rescue.decide(
      board: board,
      currentPieces: currentPieces,
      randomValue: roll,
    );

    if (decision.isForced) {
      return _forcedBatch();
    }

    if (decision.isSoft) {
      return _softRescueBatch(difficulty);
    }

    return _normalBatch(difficulty);
  }

  List<Piece?> _normalBatch(double difficulty) {
    final Map<String, double> weights = PieceWeights.forDifficulty(difficulty);
    final List<String> names = weights.keys.toList(growable: false);
    final List<double> values =
        names.map((n) => weights[n] ?? 0.0).toList(growable: false);

    return List<Piece?>.generate(
      GameConstants.piecesPerBatch,
      (_) => _makePiece(
        _weightedName(names, values),
      ),
      growable: false,
    );
  }

  List<Piece?> _forcedBatch() {
    return List<Piece?>.generate(
      GameConstants.piecesPerBatch,
      (_) => _makeRescuePiece(),
      growable: false,
    );
  }

  List<Piece?> _softRescueBatch(double difficulty) {
    final List<Piece?> result = <Piece?>[];
    result.add(_makeRescuePiece());
    final int remaining = GameConstants.piecesPerBatch - 1;
    final Map<String, double> weights = PieceWeights.forDifficulty(difficulty);
    final List<String> names = weights.keys.toList(growable: false);
    final List<double> values =
        names.map((n) => weights[n] ?? 0.0).toList(growable: false);
    for (int i = 0; i < remaining; i++) {
      result.add(_makePiece(_weightedName(names, values)));
    }
    return result;
  }

  String _weightedName(List<String> names, List<double> weights) {
    double total = 0;
    for (final w in weights) {
      total += w;
    }
    if (total <= 0) {
      return names[_random.nextInt(names.length)];
    }
    double r = _random.nextDouble() * total;
    for (int i = 0; i < names.length; i++) {
      r -= weights[i];
      if (r <= 0) return names[i];
    }
    return names.last;
  }

  Piece _makeRescuePiece() {
    final Map<String, double> weights = PieceWeights.rescueWeights();
    final List<String> names = weights.keys.toList(growable: false);
    final List<double> values =
        names.map((n) => weights[n] ?? 0.0).toList(growable: false);
    return _makePiece(_weightedName(names, values));
  }

  Piece _makePiece(String shapeName) {
    final List<List<int>>? shape = PieceCatalog.named[shapeName];
    if (shape == null) {
      throw StateError('Naməlum forma: $shapeName');
    }
    final int colorIndex = _random.nextInt(GameConstants.colorCount);
    final int id = _nextId++;
    return Piece.fromShape(
      id: id,
      shape: shape,
      colorIndex: colorIndex,
      shapeName: shapeName,
    );
  }

  void reset() {
    _nextId = 1;
  }
}

class SeededPieceGenerator extends PieceGenerator {
  SeededPieceGenerator(int seed)
      : super(
          random: _buildRandom(seed),
        );

  static Random _buildRandom(int seed) {
    final SeededRandom sr = SeededRandom(seed);
    final int baseSeed = sr.nextInt(0x7FFFFFFF);
    return Random(baseSeed);
  }
}
