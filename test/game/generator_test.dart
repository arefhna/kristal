import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kristal/game/generator/piece_generator.dart';
import 'package:kristal/game/models/board.dart';
import 'package:kristal/game/models/cell.dart';
import 'package:kristal/game/models/piece.dart';

void main() {
  group('PieceGenerator', () {
    test('3 fiqur verir', () {
      final PieceGenerator g = PieceGenerator(random: Random(42));
      final batch = g.generateBatch(
        board: Board.empty(),
        difficulty: 0.0,
        currentPieces: const <Piece?>[],
      );
      expect(batch.length, 3);
      expect(batch.every((p) => p != null), true);
    });

    test('id-lər unikaldır', () {
      final PieceGenerator g = PieceGenerator(random: Random(7));
      final batch = g.generateBatch(
        board: Board.empty(),
        difficulty: 0.5,
        currentPieces: const <Piece?>[],
      );
      final Set<int> ids = batch.map((p) => p!.id).toSet();
      expect(ids.length, 3);
    });

    test('eyni seed eyni ardıcıllıq verir', () {
      final PieceGenerator g1 = PieceGenerator(random: Random(123));
      final PieceGenerator g2 = PieceGenerator(random: Random(123));
      final b1 = g1.generateBatch(
        board: Board.empty(),
        difficulty: 0.5,
        currentPieces: const <Piece?>[],
      );
      final b2 = g2.generateBatch(
        board: Board.empty(),
        difficulty: 0.5,
        currentPieces: const <Piece?>[],
      );
      for (int i = 0; i < 3; i++) {
        expect(b1[i]!.shapeName, b2[i]!.shapeName);
        expect(b1[i]!.colorIndex, b2[i]!.colorIndex);
      }
    });

    test('lövhə tam doludursa xilasedici gəlir', () {
      final List<List<Cell>> m = List<List<Cell>>.generate(
        8,
        (_) => List<Cell>.generate(
          8,
          (_) => const Cell(type: CellType.normal, colorIndex: 0),
        ),
      );
      final Board full = Board.fromMatrix(m);
      final PieceGenerator g = PieceGenerator(random: Random(1));
      final List<Piece?> current = <Piece?>[
        Piece.fromShape(
          id: 900,
          shape: const [
            [0, 0], [0, 1], [0, 2],
          ],
          colorIndex: 1,
          shapeName: 'h3',
        ),
        null,
        null,
      ];
      final batch = g.generateBatch(
        board: full,
        difficulty: 0.9,
        currentPieces: current,
      );
      for (final p in batch) {
        expect(p, isNotNull);
        expect(p!.cellCount, lessThanOrEqualTo(3));
      }
    });
  });
}
