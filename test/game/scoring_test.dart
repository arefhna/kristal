import 'package:flutter_test/flutter_test.dart';
import 'package:kristal/game/logic/scoring.dart';

void main() {
  const Scoring s = Scoring();

  group('Scoring', () {
    test('base xal hüceyrə sayına bərabərdir', () {
      expect(s.baseScore(0), 0);
      expect(s.baseScore(3), 3);
      expect(s.baseScore(9), 9);
    });

    test('line xalı kvadratik artır', () {
      expect(s.lineScore(0), 0);
      expect(s.lineScore(1), 10);
      expect(s.lineScore(2), 40);
      expect(s.lineScore(3), 90);
      expect(s.lineScore(4), 160);
    });

    test('combo multiplikatoru düzgün hesablanır', () {
      expect(s.comboMultiplier(0), 1.0);
      expect(s.comboMultiplier(1), 1.5);
      expect(s.comboMultiplier(2), 2.0);
      expect(s.comboMultiplier(8), 5.0);
      expect(s.comboMultiplier(20), 5.0);
    });

    test('full clear bonusu 8x8 üçün 364', () {
      expect(s.fullClearBonus(8), 300 + 64);
    });

    test('total xal düzgün toplanır', () {
      final int t = s.total(
        cellsPlaced: 5,
        linesCleared: 2,
        isFullClear: false,
        boardSize: 8,
        comboCount: 2,
      );
      expect(t, ((5 + 40) * 2.0).round());
    });

    test('combo count silmədə artır, olmayanda sıfırlanır', () {
      expect(s.nextComboCount(0, 0), 0);
      expect(s.nextComboCount(2, 0), 0);
      expect(s.nextComboCount(0, 1), 1);
      expect(s.nextComboCount(3, 2), 4);
    });
  });
}
