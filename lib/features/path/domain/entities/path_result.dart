import 'path_task.dart';
import 'point.dart';

class PathResult {
  const PathResult({required this.task, required this.steps});

  final PathTask task;
  final List<Point> steps;

  bool get hasPath => steps.isNotEmpty;

  String get pathString => steps.join(' -> ');

  String get apiPathString =>
      steps.map((Point point) => '(${point.x},${point.y})').join('->');
}
