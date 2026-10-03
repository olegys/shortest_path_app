import '../../domain/entities/grid.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/entities/point.dart';

class TaskDto {
  const TaskDto({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'].toString(),
      field: (json['field'] as List<Object?>)
          .map((Object? row) => row.toString())
          .toList(),
      start: _point(Map<String, dynamic>.from(json['start'] as Map)),
      end: _point(Map<String, dynamic>.from(json['end'] as Map)),
    );
  }

  final String id;
  final List<String> field;
  final Point start;
  final Point end;

  PathTask toDomain() =>
      PathTask(id: id, grid: Grid.fromRows(field), start: start, end: end);

  static Point _point(Map<String, dynamic> json) =>
      Point(_asInt(json['x']), _asInt(json['y']));

  static int _asInt(Object? value) =>
      value is num ? value.toInt() : int.parse(value.toString());
}
