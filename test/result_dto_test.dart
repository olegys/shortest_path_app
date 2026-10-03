import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_app/features/path/data/dto/result_dto.dart';
import 'package:shortest_path_app/features/path/domain/entities/grid.dart';
import 'package:shortest_path_app/features/path/domain/entities/path_result.dart';
import 'package:shortest_path_app/features/path/domain/entities/path_task.dart';
import 'package:shortest_path_app/features/path/domain/entities/point.dart';

void main() {
  test('serializes the result in the server format', () {
    final PathTask task = PathTask(
      id: 'task-1',
      grid: Grid.fromRows(['..', '..']),
      start: const Point(0, 0),
      end: const Point(1, 1),
    );
    final PathResult result = PathResult(
      task: task,
      steps: const [Point(0, 0), Point(1, 1)],
    );

    expect(resultToJson(result), {
      'id': 'task-1',
      'result': {
        'steps': [
          {'x': '0', 'y': '0'},
          {'x': '1', 'y': '1'},
        ],
        'path': '(0,0)->(1,1)',
      },
    });
  });
}
