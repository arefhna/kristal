import '../../core/constants/game_constants.dart';
import '../models/board.dart';
import '../models/piece.dart';
import '../logic/placement_validator.dart';

class RescueDecision {
  const RescueDecision({
    required this.isForced,
    required this.isSoft,
    required this.needsRescue,
  });

  final bool isForced;
  final bool isSoft;
  final bool needsRescue;

  static const RescueDecision none = RescueDecision(
    isForced: false,
    isSoft: false,
    needsRescue: false,
  );
}

class RescueLogic {
  RescueLogic({PlacementValidator? validator})
      : _validator = validator ?? const PlacementValidator();

  final PlacementValidator _validator;

  RescueDecision decide({
    required Board board,
    required List<Piece?> currentPieces,
    required double randomValue,
  }) {
    final bool anyFits = !_validator.noPieceFits(board, currentPieces);

    if (!anyFits && currentPieces.any((p) => p != null)) {
      return const RescueDecision(
        isForced: true,
        isSoft: false,
        needsRescue: true,
      );
    }

    if (board.fillRatio >= GameConstants.rescueBoardFillThreshold &&
        randomValue < GameConstants.rescueSoftChance) {
      return const RescueDecision(
        isForced: false,
        isSoft: true,
        needsRescue: true,
      );
    }

    return RescueDecision.none;
  }
}
