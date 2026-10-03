import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_app/features/path/domain/entities/grid.dart';
import 'package:shortest_path_app/features/path/domain/entities/point.dart';
import 'package:shortest_path_app/features/path/domain/services/path_finder.dart';

void main() {
  const BfsPathFinder finder = BfsPathFinder();

  bool isValidWalk(Grid grid, List<Point> path) {
    for (int i = 0; i < path.length; i++) {
      if (grid.isBlocked(path[i])) return false;
      if (i > 0) {
        final int dx = (path[i].x - path[i - 1].x).abs();
        final int dy = (path[i].y - path[i - 1].y).abs();
        if (dx > 1 || dy > 1 || (dx == 0 && dy == 0)) return false;
      }
    }
    return true;
  }

  test('example from the task description', () {
    final Grid grid = Grid.fromRows(['.X.', '.X.', '...']);

    final List<Point> path = finder.findPath(
      grid,
      const Point(1, 2),
      const Point(2, 0),
    );

    expect(path, const [Point(1, 2), Point(2, 1), Point(2, 0)]);
  });

  test('start equals end returns a single cell', () {
    final Grid grid = Grid.fromRows(['..', '..']);

    expect(finder.findPath(grid, const Point(1, 1), const Point(1, 1)), const [
      Point(1, 1),
    ]);
  });

  test('open grid: diagonal is the shortest way', () {
    final Grid grid = Grid.fromRows([
      '.....',
      '.....',
      '.....',
      '.....',
      '.....',
    ]);

    final List<Point> path = finder.findPath(
      grid,
      const Point(0, 0),
      const Point(4, 4),
    );

    expect(path.length, 5);
    expect(path.first, const Point(0, 0));
    expect(path.last, const Point(4, 4));
    expect(isValidWalk(grid, path), isTrue);
  });

  test('goes around a wall', () {
    final Grid grid = Grid.fromRows([
      '.X...',
      '.X.X.',
      '.X.X.',
      '.X.X.',
      '...X.',
    ]);

    final List<Point> path = finder.findPath(
      grid,
      const Point(0, 0),
      const Point(4, 0),
    );

    expect(path, isNotEmpty);
    expect(path.length, 10);
    expect(isValidWalk(grid, path), isTrue);
    expect(path.first, const Point(0, 0));
    expect(path.last, const Point(4, 0));
  });

  test('returns an empty list when there is no path', () {
    final Grid grid = Grid.fromRows(['.X.', '.X.', '.X.']);

    expect(
      finder.findPath(grid, const Point(0, 0), const Point(2, 0)),
      isEmpty,
    );
  });

  test('returns an empty list when start or end is blocked', () {
    final Grid grid = Grid.fromRows(['X..', '...', '..X']);

    expect(
      finder.findPath(grid, const Point(0, 0), const Point(1, 1)),
      isEmpty,
    );
    expect(
      finder.findPath(grid, const Point(1, 1), const Point(2, 2)),
      isEmpty,
    );
  });

  test('handles the maximum grid size quickly', () {
    final List<String> rows = List<String>.generate(99, (int _) => '.' * 99);
    final Grid grid = Grid.fromRows(rows);

    final List<Point> path = finder.findPath(
      grid,
      const Point(0, 0),
      const Point(98, 98),
    );

    expect(path.length, 99);
  });
}
