import '../../data/models/adventure_level.dart';
import '../game_engine.dart';
import '../models/board.dart';
import '../models/piece.dart';
import '../models/placement_result.dart';
import 'level_objective.dart';

enum AdventureStatus {
  playing,
  victory,
  defeat,
}

class AdventureEngine {
  AdventureEngine({required this.level})
      : _tracker = ObjectiveTracker(level.objective) {
    _engine = GameEngine(initialBoard: level.buildInitialBoard());
  }

  final AdventureLevel level;
  late final GameEngine _engine;
  final ObjectiveTracker _tracker;
  AdventureStatus _status = AdventureStatus.playing;
  int _batchCount = 0;
  int _lastBatchFirstId = -1;

  GameEngine get engine => _engine;
  ObjectiveTracker get tracker => _tracker;
  AdventureStatus get status => _status;
  bool get isPlaying => _status == AdventureStatus.playing;

  void start() {
    _engine.start(initialBoard: level.buildInitialBoard());
    _tracker.reset();
    _status = AdventureStatus.playing;
    _batchCount = 0;
    _lastBatchFirstId = -1;

    _evaluate();
  }

  PlacementResult tryPlace({
    required Piece piece,
    required int originRow,
    required int originCol,
    required int batchSlot,
  }) {
    if (_status != AdventureStatus.playing) {
      return PlacementResult.invalid(_engine.board);
    }

    final PlacementResult result = _engine.tryPlace(
      piece: piece,
      originRow: originRow,
      originCol: originCol,
      batchSlot: batchSlot,
    );

    if (!result.isValid) return result;

    final int newFirstId = _engine.currentBatch.isNotEmpty &&
            _engine.currentBatch.first != null
        ? _engine.currentBatch.first!.id
        : -1;

    if (newFirstId != -1 && newFirstId != _lastBatchFirstId) {
      _lastBatchFirstId = newFirstId;
      _batchCount++;
    }

    _tracker.update(
      linesCleared: result.linesCleared,
      iceBroken: result.iceBroken,
      score: _engine.score,
      batchCount: _batchCount,
    );

    _evaluate();

    return result;
  }

  void _evaluate() {
    if (_tracker.isComplete) {
      _status = AdventureStatus.victory;
      return;
    }
    if (_engine.isGameOver) {
      _status = AdventureStatus.defeat;
    }
  }

  Board get board => _engine.board;
  int get score => _engine.score;
  int get combo => _engine.combo;
  int get bestCombo => _engine.bestCombo;
  List<Piece?> get currentBatch => _engine.currentBatch;
  bool get isGameOver => _engine.isGameOver;

  bool canPlaceAt(Piece piece, int row, int col) =>
      _engine.canPlaceAt(piece, row, col);

  int starsEarned() {
    if (_status != AdventureStatus.victory) return 0;

    final double progress = _tracker.progress;
    final int lines = _engine.totalLines;
    final int score = _engine.score;

    if (level.objective.type == ObjectiveType.reachScore) {
      if (score >= level.objective.target * 2) return 3;
      if (score >= (level.objective.target * 1.5).round()) return 2;
      return 1;
    }

    if (level.objective.type == ObjectiveType.breakIce) {
      if (progress >= 1.0 && _engine.totalIceBroken >= level.objective.target * 2) {
        return 3;
      }
      if (progress >= 1.0 && _engine.totalIceBroken >= (level.objective.target * 1.5).round()) {
        return 2;
      }
      return 1;
    }

    if (lines >= level.objective.target * 2) return 3;
    if (lines >= (level.objective.target * 1.5).round()) return 2;
    return 1;
  }
}
