import 'piece_shape.dart';

class Piece {
  Piece({
    required this.id,
    required this.cells,
    required this.colorIndex,
    required this.shapeName,
  });

  final int id;
  final List<List<int>> cells;
  final int colorIndex;
  final String shapeName;

  int get width {
    int max = 0;
    for (final c in cells) {
      if (c[1] > max) max = c[1];
    }
    return max + 1;
  }

  int get height {
    int max = 0;
    for (final c in cells) {
      if (c[0] > max) max = c[0];
    }
    return max + 1;
  }

  int get cellCount => cells.length;

  List<List<int>> absoluteCells(int originRow, int originCol) {
    return cells
        .map((c) => [originRow + c[0], originCol + c[1]])
        .toList(growable: false);
  }

  factory Piece.fromShape({
    required int id,
    required List<List<int>> shape,
    required int colorIndex,
    required String shapeName,
  }) {
    return Piece(
      id: id,
      cells: List<List<int>>.unmodifiable(
        shape.map((c) => List<int>.unmodifiable(c)),
      ),
      colorIndex: colorIndex,
      shapeName: shapeName,
    );
  }

  Piece cloneWithId(int newId) => Piece(
        id: newId,
        cells: cells,
        colorIndex: colorIndex,
        shapeName: shapeName,
      );

  @override
  String toString() => 'Piece($shapeName, id=$id, cells=${cells.length})';
}

class PieceCatalog {
  PieceCatalog._();

  static const Map<String, List<List<int>>> named = {
    'single': PieceShape.single,
    'h2': PieceShape.h2,
    'h3': PieceShape.h3,
    'h4': PieceShape.h4,
    'h5': PieceShape.h5,
    'v2': PieceShape.v2,
    'v3': PieceShape.v3,
    'v4': PieceShape.v4,
    'v5': PieceShape.v5,
    'o2': PieceShape.o2,
    'o3': PieceShape.o3,
    'r23': PieceShape.r23,
    'r32': PieceShape.r32,
    'lSmall': PieceShape.lSmall,
    'lBig': PieceShape.lBig,
    'jSmall': PieceShape.jSmall,
    'jBig': PieceShape.jBig,
    'tSmall': PieceShape.tSmall,
    'sSmall': PieceShape.sSmall,
    'zSmall': PieceShape.zSmall,
  };
}
