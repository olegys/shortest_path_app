import 'dart:collection';

import '../entities/grid.dart';
import '../entities/point.dart';

abstract class PathFinder {
  const PathFinder();

  List<Point> findPath(Grid grid, Point start, Point end);
}

class BfsPathFinder extends PathFinder {
  const BfsPathFinder();

  @override
  List<Point> findPath(Grid grid, Point start, Point end) {
    if (grid.isBlocked(start) || grid.isBlocked(end)) return const [];
    if (start == end) return [start];

    final int size = grid.width * grid.height;
    final List<int> parent = List<int>.filled(size, -1);
    final List<bool> visited = List<bool>.filled(size, false);
    final Queue<int> queue = Queue<int>();

    final int startIndex = grid.indexOf(start);
    final int endIndex = grid.indexOf(end);

    visited[startIndex] = true;
    queue.add(startIndex);

    while (queue.isNotEmpty) {
      final int current = queue.removeFirst();
      if (current == endIndex) break;

      for (final Point next in grid.neighbors(grid.pointAt(current))) {
        final int index = grid.indexOf(next);
        if (visited[index]) continue;
        visited[index] = true;
        parent[index] = current;
        queue.add(index);
      }
    }

    if (!visited[endIndex]) return const [];

    final List<Point> path = <Point>[];

    for (int i = endIndex; i != -1; i = parent[i]) {
      path.add(grid.pointAt(i));
    }

    return path.reversed.toList();
  }
}
