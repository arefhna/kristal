import '../../game/models/board.dart';
import '../../game/models/cell.dart';

enum ObjectiveType {
  clearLines,
  breakIce,
  reachScore,
  surviveBatch,
}

class LevelObjective {
  const LevelObjective({
    required this.type,
    required this.target,
    this.description = '',
  });

  final ObjectiveType type;
  final int target;
  final String description;

  String label() {
    switch (type) {
      case ObjectiveType.clearLines:
        return '$target sətir sil';
      case ObjectiveType.breakIce:
        return '$target buz qır';
      case ObjectiveType.reachScore:
        return '$target xal topla';
      case ObjectiveType.surviveBatch:
        return '$target növbə sağ qal';
    }
  }
}

class AdventureLevel {
  const AdventureLevel({
    required this.id,
    required this.world,
    required this.indexInWorld,
    required this.name,
    required this.objective,
    required this.initialIceCoords,
    required this.initialFillCoords,
  });

  final int id;
  final int world;
  final int indexInWorld;
  final String name;
  final LevelObjective objective;
  final List<List<int>> initialIceCoords;
  final List<List<int>> initialFillCoords;

  Board buildInitialBoard({int size = 8}) {
    Board board = Board.empty(size);

    if (initialFillCoords.isNotEmpty) {
      board = board.withCells(initialFillCoords, 0);
    }

    if (initialIceCoords.isNotEmpty) {
      board = board.withIceCells(initialIceCoords);
    }

    return board;
  }
}
