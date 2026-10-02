class PieceShape {
  PieceShape._();

  static const List<List<int>> single = [
    [0, 0],
  ];

  static const List<List<int>> h2 = [
    [0, 0], [0, 1],
  ];

  static const List<List<int>> h3 = [
    [0, 0], [0, 1], [0, 2],
  ];

  static const List<List<int>> h4 = [
    [0, 0], [0, 1], [0, 2], [0, 3],
  ];

  static const List<List<int>> h5 = [
    [0, 0], [0, 1], [0, 2], [0, 3], [0, 4],
  ];

  static const List<List<int>> v2 = [
    [0, 0], [1, 0],
  ];

  static const List<List<int>> v3 = [
    [0, 0], [1, 0], [2, 0],
  ];

  static const List<List<int>> v4 = [
    [0, 0], [1, 0], [2, 0], [3, 0],
  ];

  static const List<List<int>> v5 = [
    [0, 0], [1, 0], [2, 0], [3, 0], [4, 0],
  ];

  static const List<List<int>> o2 = [
    [0, 0], [0, 1],
    [1, 0], [1, 1],
  ];

  static const List<List<int>> o3 = [
    [0, 0], [0, 1], [0, 2],
    [1, 0], [1, 1], [1, 2],
    [2, 0], [2, 1], [2, 2],
  ];

  static const List<List<int>> r23 = [
    [0, 0], [0, 1], [0, 2],
    [1, 0], [1, 1], [1, 2],
  ];

  static const List<List<int>> r32 = [
    [0, 0], [0, 1],
    [1, 0], [1, 1],
    [2, 0], [2, 1],
  ];

  static const List<List<int>> lSmall = [
    [0, 0],
    [1, 0], [1, 1],
  ];

  static const List<List<int>> lBig = [
    [0, 0],
    [1, 0],
    [2, 0], [2, 1],
  ];

  static const List<List<int>> jSmall = [
        [0, 1],
    [1, 0], [1, 1],
  ];

  static const List<List<int>> jBig = [
         [0, 1],
         [1, 1],
    [2, 0], [2, 1],
  ];

  static const List<List<int>> tSmall = [
    [0, 0], [0, 1], [0, 2],
           [1, 1],
  ];

  static const List<List<int>> sSmall = [
           [0, 1], [0, 2],
    [1, 0], [1, 1],
  ];

  static const List<List<int>> zSmall = [
    [0, 0], [0, 1],
           [1, 1], [1, 2],
  ];

  static const List<List<List<int>>> easySet = [
    single, h2, v2, h3, v3, o2, lSmall, jSmall,
  ];

  static const List<List<List<int>>> mediumSet = [
    h3, v3, h4, v4, o2, lSmall, jSmall, tSmall, sSmall, zSmall,
  ];

  static const List<List<List<int>>> hardSet = [
    h5, v5, lBig, jBig, r23, r32, o3, tSmall, sSmall, zSmall,
  ];
}
