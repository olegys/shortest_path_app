import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_exception.dart';
import '../../domain/entities/path_result.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/entities/point.dart';
import '../../domain/repositories/path_repository.dart';
import '../../domain/repositories/url_storage.dart';
import '../../domain/services/path_finder.dart';
import 'process_state.dart';

sealed class ProcessEvent {
  const ProcessEvent();
}

class ProcessStarted extends ProcessEvent {
  const ProcessStarted();
}

class ProcessSendPressed extends ProcessEvent {
  const ProcessSendPressed();
}

class ProcessBloc extends Bloc<ProcessEvent, ProcessState> {
  final PathRepository pathRepository;
  final PathFinder pathFinder;
  final UrlStorage urlStorage;

  ProcessBloc({
    required this.pathRepository,
    required this.pathFinder,
    required this.urlStorage,
  }) : super(const ProcessState()) {
    on<ProcessStarted>(_onStarted);
    on<ProcessSendPressed>(_onSendPressed);
  }

  Future<void> _onStarted(
    ProcessStarted event,
    Emitter<ProcessState> emit,
  ) async {
    final String? url = urlStorage.read();
    if (url == null) {
      emit(
        const ProcessState(
          status: ProcessStatus.loadFailed,
          error: 'API URL is not set',
        ),
      );
      return;
    }

    emit(const ProcessState());

    try {
      final List<PathTask> tasks = await pathRepository.fetchTasks(
        url,
        onProgress: (double progress) {
          if (!emit.isDone) {
            emit(state.copyWith(downloadProgress: progress));
          }
        },
      );
      emit(
        state.copyWith(
          status: ProcessStatus.calculating,
          completedTasks: 0,
          totalTasks: tasks.length,
        ),
      );

      final List<PathResult> results = <PathResult>[];
      for (int i = 0; i < tasks.length; i++) {
        final List<Point> steps = await _solve(pathFinder, tasks[i]);
        results.add(PathResult(task: tasks[i], steps: steps));
        emit(state.copyWith(completedTasks: i + 1));
        await Future<void>.delayed(Duration.zero);
      }

      emit(state.copyWith(status: ProcessStatus.ready, results: results));
    } on ApiException catch (e) {
      emit(state.copyWith(status: ProcessStatus.loadFailed, error: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProcessStatus.loadFailed,
          error: 'Unexpected error: $e',
        ),
      );
    }
  }

  Future<void> _onSendPressed(
    ProcessSendPressed event,
    Emitter<ProcessState> emit,
  ) async {
    if (state.status != ProcessStatus.ready) return;

    final String? url = urlStorage.read();

    if (url == null) {
      emit(state.copyWith(error: 'API URL is not set'));
      return;
    }

    emit(state.copyWith(status: ProcessStatus.sending, clearError: true));
    try {
      await pathRepository.sendResults(url, state.results);
      emit(state.copyWith(status: ProcessStatus.sent));
      emit(state.copyWith(status: ProcessStatus.ready));
    } on ApiException catch (e) {
      emit(state.copyWith(status: ProcessStatus.ready, error: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProcessStatus.ready,
          error: 'Unexpected error: $e',
        ),
      );
    }
  }

  static Future<List<Point>> _solve(PathFinder finder, PathTask task) {
    return Isolate.run(() => finder.findPath(task.grid, task.start, task.end));
  }
}
