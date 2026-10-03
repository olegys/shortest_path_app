import 'grid.dart';
import 'point.dart';

class PathTask {
  const PathTask({
    required this.id,
    required this.grid,
    required this.start,
    required this.end,
  });

  final String id;
  final Grid grid;
  final Point start;
  final Point end;
}
