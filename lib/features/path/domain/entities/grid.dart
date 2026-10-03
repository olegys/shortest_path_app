import 'point.dart';

class Grid {
  Grid._(this.width, this.height, this._blocked);

  factory Grid.fromRows(List<String> rows) {
    if (rows.isEmpty) throw const FormatException('Grid is empty');

    final int width = rows.first.length;
    if (width == 0) throw const FormatException('Grid row is empty');

    final List<bool> blocked = <bool>[];
    for (final String row in rows) {
      if (row.length != width) {
        throw const FormatException('Grid rows have different lengths');
      }
      for (int i = 0; i < row.length; i++) {
        blocked.add(row[i].toUpperCase() == blockedChar);
      }
    }
    return Grid._(width, rows.length, blocked);
  }

  static const String blockedChar = 'X';

  static const List<Point> _directions = [
    Point(0, -1),
    Point(1, -1),
    Point(1, 0),
    Point(1, 1),
    Point(0, 1),
    Point(-1, 1),
    Point(-1, 0),
    Point(-1, -1),
  ];

  final int width;
  final int height;
  final List<bool> _blocked;

  bool contains(Point p) => p.x >= 0 && p.y >= 0 && p.x < width && p.y < height;

  bool isBlocked(Point p) => !contains(p) || _blocked[indexOf(p)];

  int indexOf(Point p) => p.y * width + p.x;

  Point pointAt(int index) => Point(index % width, index ~/ width);

  Iterable<Point> neighbors(Point p) sync* {
    for (final Point d in _directions) {
      final Point next = Point(p.x + d.x, p.y + d.y);
      if (!isBlocked(next)) yield next;
    }
  }
}
