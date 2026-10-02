import '../models/board.dart';

class LineClearResult {
  const LineClearResult({
    required this.rows,
    required this.cols,
    required this.linesCleared,
  });

  final Set<int> rows;
  final Set<int> cols;
  final int linesCleared;

  bool get hasClears => linesCleared > 0;

  static const LineClearResult none = LineClearResult(
    rows: <int>{},
    cols: <int>{},
    linesCleared: 0,
  );
}

class LineClearer {
  const LineClearer();

  LineClearResult findFullLines(Board board) {
    final Set<int> rows = board.fullRows();
    final Set<int> cols = board.fullCols();
    if (rows.isEmpty && cols.isEmpty) return LineClearResult.none;
    return LineClearResult(
      rows: rows,
      cols: cols,
      linesCleared: rows.length + cols.length,
    );
  }

  Board clear(Board board, LineClearResult result) {
    if (!result.hasClears) return board;
    return board.withClearedRowsAndCols(result.rows, result.cols);
  }
}
