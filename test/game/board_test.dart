import 'package:flutter_test/flutter_test.dart';
import 'package:kristal/game/models/board.dart';
import 'package:kristal/game/models/cell.dart';

void main() {
  group('Board', () {
    test('bos lövhə tamamilə boşdur', () {
      final Board b = Board.empty();
      expect(b.size, 8);
      expect(b.filledCount, 0);
      expect(b.isCompletelyEmpty, true);
    });

    test('withCells hüceyrələri doldurur', () {
      final Board b = Board.empty();
      final Board b2 = b.withCells([
        [0, 0],
        [0, 1],
      ], 3);
      expect(b2.filledCount, 2);
      expect(b2.at(0, 0).type, CellType.normal);
      expect(b2.at(0, 0).colorIndex, 3);
      expect(b.filledCount, 0);
    });

    test('tam sətir və sütun tapılır', () {
      final List<List<Cell>> m = List<List<Cell>>.generate(
        8,
        (_) => List<Cell>.generate(8, (_) => Cell.empty),
      );
      for (int c = 0; c < 8; c++) {
        m[2][c] = const Cell(type: CellType.normal, colorIndex: 1);
      }
      for (int r = 0; r < 8; r++) {
        m[r][5] = const Cell(type: CellType.normal, colorIndex: 2);
      }
      final Board b = Board.fromMatrix(m);
      expect(b.fullRows(), {2});
      expect(b.fullCols(), {5});
    });

    test('withClearedRowsAndCols sıfırlayır', () {
      final List<List<Cell>> m = List<List<Cell>>.generate(
        8,
        (_) => List<Cell>.generate(8, (_) => Cell.empty),
      );
      for (int c = 0; c < 8; c++) {
        m[0][c] = const Cell(type: CellType.normal, colorIndex: 1);
      }
      final Board b = Board.fromMatrix(m);
      final Board b2 = b.withClearedRowsAndCols({0}, {});
      expect(b2.filledCount, 0);
    });
  });
}
