import '../models/board.dart';

class LineClearResult {
  const LineClearResult({
    required this.rows,
    required this.cols,
    required this.linesCleared,
    required this.iceBroken,
  });

  final Set<int> rows;
  final Set<int> cols;
  final int linesCleared;
  final int iceBroken;

  bool get hasClears => linesCleared > 0;

  static const LineClearResult none = LineClearResult(
    rows: <int>{},
    cols: <int>{},
    linesCleared: 0,
    iceBroken: 0,
  );
}

class LineClearer {
  const LineClearer();

  LineClearResult findFullLines(Board board) {
    final Set<int> rows = board.fullRows();
    final Set<int> cols = board.fullCols();
    if (rows.isEmpty && cols.isEmpty) return LineClearResult.none;

    int iceBroken = 0;
    final Set<List<int>> iceCoords = <List<int>>{};

    for (final r in rows) {
      for (int c = 0; c < board.size; c++) {
        if (board.at(r, c).isIce) {
          iceBroken++;
          iceCoords.add(<int>[r, c]);
        }
      }
    }
    for (final c in cols) {
      for (int r = 0; r < board.size; r++) {
        if (board.at(r, c).isIce) {
          iceBroken++;
          iceCoords.add(<int>[r, c]);
        }
      }
    }

    return LineClearResult(
      rows: rows,
      cols: cols,
      linesCleared: rows.length + cols.length,
      iceBroken: iceBroken,
    );
  }

  Board clear(Board board, LineClearResult result) {
    if (!result.hasClears) return board;

    Board next = board;

    final Set<List<int>> iceCoords = <List<int>>{};
    for (final r in result.rows) {
      for (int c = 0; c < board.size; c++) {
        if (board.at(r, c).isIce && board.at(r, c).iceLayers <= 1) {
          iceCoords.add(<int>[r, c]);
        }
      }
    }
    for (final c in result.cols) {
      for (int r = 0; r < board.size; r++) {
        if (board.at(r, c).isIce && board.at(r, c).iceLayers <= 1) {
          iceCoords.add(<int>[r, c]);
        }
      }
    }

    if (iceCoords.isNotEmpty) {
      next = next.withFilledCellsCleared(iceCoords);
    }

    return next.withClearedRowsAndCols(result.rows, result.cols);
  }
}
