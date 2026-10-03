import 'package:equatable/equatable.dart';

import '../../domain/entities/path_result.dart';

enum ProcessStatus { loading, calculating, ready, sending, sent, loadFailed }

class ProcessState extends Equatable {
  const ProcessState({
    this.status = ProcessStatus.loading,
    this.downloadProgress,
    this.completedTasks = 0,
    this.totalTasks = 0,
    this.results = const [],
    this.error,
  });

  final ProcessStatus status;

  final double? downloadProgress;
  final int completedTasks;
  final int totalTasks;
  final List<PathResult> results;
  final String? error;

  double get calculationProgress =>
      totalTasks == 0 ? 0 : completedTasks / totalTasks;

  ProcessState copyWith({
    ProcessStatus? status,
    double? downloadProgress,
    int? completedTasks,
    int? totalTasks,
    List<PathResult>? results,
    String? error,
    bool clearError = false,
  }) {
    return ProcessState(
      status: status ?? this.status,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      results: results ?? this.results,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    status,
    downloadProgress,
    completedTasks,
    totalTasks,
    results,
    error,
  ];
}
