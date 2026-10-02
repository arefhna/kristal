enum CellType {
  empty,
  normal,
  ice,
  locked,
  bomb,
}

class Cell {
  const Cell({this.type = CellType.empty, this.colorIndex = -1});

  final CellType type;
  final int colorIndex;

  bool get isEmpty => type == CellType.empty;
  bool get isFilled => type != CellType.empty;

  static const Cell empty = Cell();

  Cell copyWith({CellType? type, int? colorIndex}) {
    return Cell(
      type: type ?? this.type,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cell && other.type == type && other.colorIndex == colorIndex;

  @override
  int get hashCode => Object.hash(type, colorIndex);

  @override
  String toString() => isEmpty ? '.' : '${type.name[0]}$colorIndex';
}
