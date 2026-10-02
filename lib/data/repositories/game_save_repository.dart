import 'dart:convert';

import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';
import '../../game/models/board.dart';
import '../../game/models/cell.dart';
import '../../game/models/piece.dart';
import '../models/game_save.dart';

class GameSaveRepository {
  GameSaveRepository(this._storage);

  final StorageService _storage;

  bool get hasSave => _storage.getBool(StorageKeys.saveExists);

  Future<void> saveGame({
    required Board board,
    required List<Piece?> batch,
    required int score,
    required int combo,
    required int bestCombo,
  }) async {
    final List<List<int>> matrix = <List<int>>[];
    for (int r = 0; r < board.size; r++) {
      final List<int> row = <int>[];
      for (int c = 0; c < board.size; c++) {
        final Cell cell = board.at(r, c);
        row.add(cell.isEmpty ? -1 : cell.colorIndex);
      }
      matrix.add(row);
    }

    final List<String> batchEncoded = <String>[];
    for (final p in batch) {
      if (p == null) {
        batchEncoded.add('');
      } else {
        batchEncoded.add(jsonEncode(<String, dynamic>{
          'id': p.id,
          'shape': p.shapeName,
          'color': p.colorIndex,
        }));
      }
    }

    await _storage.setString(StorageKeys.saveBoard, jsonEncode(matrix));
    await _storage.setStringList(StorageKeys.saveBatch, batchEncoded);
    await _storage.setInt(StorageKeys.saveScore, score);
    await _storage.setInt(StorageKeys.saveCombo, combo);
    await _storage.setInt(StorageKeys.saveBestCombo, bestCombo);
    await _storage.setBool(StorageKeys.saveExists, true);
  }

  GameSave? loadGame() {
    if (!hasSave) return null;

    try {
      final String boardRaw = _storage.getString(StorageKeys.saveBoard);
      if (boardRaw.isEmpty) return null;

      final List<dynamic> decodedBoard = jsonDecode(boardRaw) as List<dynamic>;
      final List<List<int>> matrix = <List<int>>[];
      for (final row in decodedBoard) {
        final List<dynamic> rowList = row as List<dynamic>;
        matrix.add(rowList.map((e) => (e as num).toInt()).toList());
      }

      final List<String> batchEncoded =
          _storage.getStringList(StorageKeys.saveBatch);
      final List<PieceSave?> batch = <PieceSave?>[];
      for (final raw in batchEncoded) {
        if (raw.isEmpty) {
          batch.add(null);
        } else {
          final Map<String, dynamic> map =
              jsonDecode(raw) as Map<String, dynamic>;
          batch.add(
            PieceSave(
              id: (map['id'] as num).toInt(),
              shapeName: map['shape'] as String,
              colorIndex: (map['color'] as num).toInt(),
            ),
          );
        }
      }

      return GameSave(
        boardMatrix: matrix,
        batch: batch,
        score: _storage.getInt(StorageKeys.saveScore),
        combo: _storage.getInt(StorageKeys.saveCombo),
        bestCombo: _storage.getInt(StorageKeys.saveBestCombo),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSave() async {
    await _storage.remove(StorageKeys.saveBoard);
    await _storage.remove(StorageKeys.saveBatch);
    await _storage.remove(StorageKeys.saveScore);
    await _storage.remove(StorageKeys.saveCombo);
    await _storage.remove(StorageKeys.saveBestCombo);
    await _storage.setBool(StorageKeys.saveExists, false);
  }

  Board boardFromMatrix(List<List<int>> matrix) {
    final List<List<Cell>> cells = <List<Cell>>[];
    for (final row in matrix) {
      final List<Cell> cellRow = <Cell>[];
      for (final v in row) {
        if (v < 0) {
          cellRow.add(Cell.empty);
        } else {
          cellRow.add(Cell(type: CellType.normal, colorIndex: v));
        }
      }
      cells.add(cellRow);
    }
    return Board.fromMatrix(cells);
  }
}
