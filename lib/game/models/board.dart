import '../../core/constants/game_constants.dart';
import 'cell.dart';

class Board {
  Board._(this._cells);

  final List<List<Cell>> _cells;

  int get size => _cells.length;

  factory Board.empty([int size = GameConstants.boardSize]) {
    return Board._(
      List<List<Cell>>.generate(
        size,
        (_) => List<Cell>.filled(size, Cell.empty, growable: false),
        growable: false,
      ),
    );
  }

  factory Board.fromMatrix(List<List<Cell>> cells) {
    return Board._(
      List<List<Cell>>.unmodifiable(
        cells.map((row) => List<Cell>.unmodifiable(row)),
      ),
    );
  }

  Cell at(int row, int col) => _cells[row][col];

  bool isEmptyAt(int row, int col) => _cells[row][col].isEmpty;

  bool inBounds(int row, int col) =>
      row >= 0 && row < size && col >= 0 && col < size;

  int get filledCount {
    int count = 0;
    for (final row in _cells) {
      for (final cell in row) {
        if (cell.isFilled) count++;
      }
    }
    return count;
  }

  double get fillRatio => filledCount / (size * size);

  Board withCells(List<List<int>> absoluteCells, int colorIndex) {
    final List<List<Cell>> next = _cells
        .map((row) => List<Cell>.from(row))
        .toList(growable: false);
    for (final ac in absoluteCells) {
      next[ac[0]][ac[1]] = Cell(type: CellType.normal, colorIndex: colorIndex);
    }
    return Board._(next);
  }

  Board withClearedRowsAndCols(Set<int> rows, Set<int> cols) {
    final List<List<Cell>> next = _cells
        .map((row) => List<Cell>.from(row))
        .toList(growable: false);
    for (final r in rows) {
      for (int c = 0; c < size; c++) {
        next[r][c] = Cell.empty;
      }
    }
    for (final c in cols) {
      for (int r = 0; r < size; r++) {
        next[r][c] = Cell.empty;
      }
    }
    return Board._(next);
  }

  Set<int> fullRows() {
    final Set<int> result = <int>{};
    for (int r = 0; r < size; r++) {
      bool full = true;
      for (int c = 0; c < size; c++) {
        if (_cells[r][c].isEmpty) {
          full = false;
          break;
        }
      }
      if (full) result.add(r);
    }
    return result;
  }

  Set<int> fullCols() {
    final Set<int> result = <int>{};
    for (int c = 0; c < size; c++) {
      bool full = true;
      for (int r = 0; r < size; r++) {
        if (_cells[r][c].isEmpty) {
          full = false;
          break;
        }
      }
      if (full) result.add(c);
    }
    return result;
  }

  bool get isCompletelyEmpty => filledCount == 0;

  List<List<Cell>> get raw => _cells;

  @override
  String toString() {
    final StringBuffer sb = StringBuffer();
    for (final row in _cells) {
      sb.writeln(row.map((c) => c.isEmpty ? '.' : '#').join());
    }
    return sb.toString();
  }
}
