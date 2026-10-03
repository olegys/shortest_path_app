import '../../domain/entities/path_result.dart';
import '../../domain/entities/point.dart';

Map<String, dynamic> resultToJson(PathResult result) {
  return {
    'id': result.task.id,
    'result': {
      'steps': [
        for (final Point p in result.steps)
          {'x': p.x.toString(), 'y': p.y.toString()},
      ],
      'path': result.apiPathString,
    },
  };
}
