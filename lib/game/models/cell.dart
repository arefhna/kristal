enum CellType {
  empty,
  normal,
  ice,
  locked,
  bomb,
}

class Cell {
  const Cell({
    this.type = CellType.empty,
    this.colorIndex = -1,
    this.iceLayers = 0,
  });

  final CellType type;
  final int colorIndex;
  final int iceLayers;

  bool get isEmpty => type == CellType.empty;
  bool get isFilled => type != CellType.empty;
  bool get isIce => type == CellType.ice;
  bool get isBomb => type == CellType.bomb;
  bool get isLocked => type == CellType.locked;

  static const Cell empty = Cell();

  Cell copyWith({CellType? type, int? colorIndex, int? iceLayers}) {
    return Cell(
      type: type ?? this.type,
      colorIndex: colorIndex ?? this.colorIndex,
      iceLayers: iceLayers ?? this.iceLayers,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cell &&
          other.type == type &&
          other.colorIndex == colorIndex &&
          other.iceLayers == iceLayers;

  @override
  int get hashCode => Object.hash(type, colorIndex, iceLayers);

  @override
  String toString() => isEmpty ? '.' : '${type.name[0]}$colorIndex';
}
