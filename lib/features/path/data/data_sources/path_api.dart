import 'package:dio/dio.dart';

import '../../domain/entities/path_result.dart';
import '../dto/result_dto.dart';
import '../dto/task_dto.dart';

class PathApi {
  PathApi(this._dio);

  final Dio _dio;

  Future<List<TaskDto>> fetchTasks(
    String url, {
    void Function(double progress)? onProgress,
  }) async {
    final Response<Object?> response = await _dio.get<Object?>(
      url,
      onReceiveProgress: (int received, int total) {
        if (total > 0) {
          onProgress?.call((received / total).clamp(0, 1).toDouble());
        }
      },
    );
    final Object? body = response.data;
    if (body is! Map || body['data'] is! List) {
      throw const FormatException(
        'The server response does not contain a task list',
      );
    }

    return (body['data'] as List<Object?>).map((Object? item) {
      if (item is! Map) {
        throw const FormatException('A task has an invalid format');
      }
      return TaskDto.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  Future<void> sendResults(String url, List<PathResult> results) async {
    await _dio.post<Object?>(url, data: results.map(resultToJson).toList());
  }
}
