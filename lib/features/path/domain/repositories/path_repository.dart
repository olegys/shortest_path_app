import '../entities/path_result.dart';
import '../entities/path_task.dart';

abstract class PathRepository {
  Future<List<PathTask>> fetchTasks(
    String url, {
    void Function(double progress)? onProgress,
  });

  Future<void> sendResults(String url, List<PathResult> results);
}
