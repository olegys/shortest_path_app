import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_app/features/path/data/dto/task_dto.dart';
import 'package:shortest_path_app/features/path/domain/entities/path_task.dart';
import 'package:shortest_path_app/features/path/domain/entities/point.dart';

void main() {
  test('parses a task response into domain values', () {
    final TaskDto task = TaskDto.fromJson({
      'id': 'task-1',
      'field': ['.X', '..'],
      'start': {'x': '0', 'y': 1},
      'end': {'x': 1, 'y': '0'},
    });

    final PathTask domainTask = task.toDomain();

    expect(domainTask.id, 'task-1');
    expect(domainTask.grid.width, 2);
    expect(domainTask.grid.height, 2);
    expect(domainTask.start, const Point(0, 1));
    expect(domainTask.end, const Point(1, 0));
  });
}
