import '../../game/models/piece.dart';

class GameSave {
  const GameSave({
    required this.boardMatrix,
    required this.batch,
    required this.score,
    required this.combo,
    required this.bestCombo,
  });

  final List<List<int>> boardMatrix;
  final List<PieceSave?> batch;
  final int score;
  final int combo;
  final int bestCombo;

  static const GameSave empty = GameSave(
    boardMatrix: <List<int>>[],
    batch: <PieceSave?>[],
    score: 0,
    combo: 0,
    bestCombo: 0,
  );
}

class PieceSave {
  const PieceSave({
    required this.id,
    required this.shapeName,
    required this.colorIndex,
  });

  final int id;
  final String shapeName;
  final int colorIndex;

  Piece toPiece() {
    final List<List<int>> shape = PieceCatalog.named[shapeName] ?? <List<int>>[
      <int>[0, 0],
    ];
    return Piece.fromShape(
      id: id,
      shape: shape,
      colorIndex: colorIndex,
      shapeName: shapeName,
    );
  }

  factory PieceSave.fromPiece(Piece piece) {
    return PieceSave(
      id: piece.id,
      shapeName: piece.shapeName,
      colorIndex: piece.colorIndex,
    );
  }
}
