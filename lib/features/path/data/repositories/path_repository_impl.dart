import 'package:dio/dio.dart';

import '../../../../core/error/api_exception.dart';
import '../../domain/entities/path_result.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/repositories/path_repository.dart';
import '../data_sources/path_api.dart';
import '../dto/task_dto.dart';

class PathRepositoryImpl implements PathRepository {
  PathRepositoryImpl(this._api);

  final PathApi _api;

  @override
  Future<List<PathTask>> fetchTasks(
    String url, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final List<TaskDto> tasks = await _api.fetchTasks(
        url,
        onProgress: onProgress,
      );
      return tasks.map((dto) => dto.toDomain()).toList();
    } on FormatException catch (e) {
      throw ApiException('Unexpected server data: ${e.message}');
    } on TypeError {
      throw const ApiException('Unexpected server data');
    } on DioException catch (e) {
      throw ApiException(_messageFor(e));
    }
  }

  @override
  Future<void> sendResults(String url, List<PathResult> results) async {
    try {
      await _api.sendResults(url, results);
    } on DioException catch (e) {
      throw ApiException(_messageFor(e));
    }
  }

  String _messageFor(DioException error) {
    if (error.response != null) {
      final Object? responseData = error.response!.data;
      if (responseData is Map && responseData['message'] is String) {
        return responseData['message'] as String;
      }
      return 'Server error (${error.response!.statusCode})';
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'The request timed out. Please try again.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Could not connect to the server. Check the URL and your connection.';
    }
    return 'The request failed. Please try again.';
  }
}
