import '../models/board.dart';
import '../models/piece.dart';

class PlacementValidator {
  const PlacementValidator();

  bool canPlace(Board board, Piece piece, int originRow, int originCol) {
    for (final offset in piece.cells) {
      final int r = originRow + offset[0];
      final int c = originCol + offset[1];
      if (!board.inBounds(r, c)) return false;
      if (!board.isEmptyAt(r, c)) return false;
    }
    return true;
  }

  bool hasAnyPlacement(Board board, Piece piece) {
    final int maxRow = board.size - piece.height;
    final int maxCol = board.size - piece.width;
    for (int r = 0; r <= maxRow; r++) {
      for (int c = 0; c <= maxCol; c++) {
        if (canPlace(board, piece, r, c)) return true;
      }
    }
    return false;
  }

  bool noPieceFits(Board board, List<Piece?> pieces) {
    for (final piece in pieces) {
      if (piece == null) continue;
      if (hasAnyPlacement(board, piece)) return false;
    }
    return true;
  }

  List<List<int>> validOrigins(Board board, Piece piece) {
    final List<List<int>> result = <List<int>>[];
    final int maxRow = board.size - piece.height;
    final int maxCol = board.size - piece.width;
    for (int r = 0; r <= maxRow; r++) {
      for (int c = 0; c <= maxCol; c++) {
        if (canPlace(board, piece, r, c)) {
          result.add(<int>[r, c]);
        }
      }
    }
    return result;
  }
}
