import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_app/features/path/domain/entities/grid.dart';
import 'package:shortest_path_app/features/path/domain/entities/point.dart';

void main() {
  test('parses blocked and free cells', () {
    final Grid grid = Grid.fromRows(['.X', '..']);

    expect(grid.width, 2);
    expect(grid.height, 2);
    expect(grid.isBlocked(const Point(1, 0)), isTrue);
    expect(grid.isBlocked(const Point(0, 0)), isFalse);
  });

  test('cells outside the grid are blocked', () {
    final Grid grid = Grid.fromRows(['..', '..']);

    expect(grid.isBlocked(const Point(-1, 0)), isTrue);
    expect(grid.isBlocked(const Point(2, 0)), isTrue);
  });

  test('a corner cell has 3 neighbours', () {
    final Grid grid = Grid.fromRows(['...', '...', '...']);

    expect(grid.neighbors(const Point(0, 0)).length, 3);
    expect(grid.neighbors(const Point(1, 1)).length, 8);
  });

  test('throws on rows of different length', () {
    expect(() => Grid.fromRows(['..', '.']), throwsFormatException);
  });

  test('throws on empty input', () {
    expect(() => Grid.fromRows(<String>[]), throwsFormatException);
  });
}
