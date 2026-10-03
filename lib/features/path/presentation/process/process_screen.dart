import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/primary_button.dart';
import 'process_bloc.dart';
import 'process_state.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProcessBloc>()..add(const ProcessStarted()),
      child: const _ProcessView(),
    );
  }
}

class _ProcessView extends StatelessWidget {
  const _ProcessView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProcessBloc, ProcessState>(
      listenWhen: (ProcessState previous, ProcessState current) =>
          current.status == ProcessStatus.sent &&
          previous.status != ProcessStatus.sent,
      listener: (BuildContext context, ProcessState state) =>
          context.push(AppRoutes.results, extra: state.results),
      child: Scaffold(
        appBar: AppBar(title: const Text('Calculation')),
        body: SafeArea(
          child: BlocBuilder<ProcessBloc, ProcessState>(
            builder: (BuildContext context, ProcessState state) =>
                _ProcessContent(state: state),
          ),
        ),
      ),
    );
  }
}

class _ProcessContent extends StatelessWidget {
  const _ProcessContent({required this.state});

  final ProcessState state;

  double? get _visibleProgress => switch (state.status) {
    ProcessStatus.loading => state.downloadProgress,
    ProcessStatus.calculating => state.calculationProgress,
    ProcessStatus.ready ||
    ProcessStatus.sent => state.totalTasks == 0 ? null : 1,
    ProcessStatus.loadFailed =>
      state.totalTasks > 0
          ? state.calculationProgress
          : state.downloadProgress ?? 0,
    ProcessStatus.sending => null,
  };

  String get _title => switch (state.status) {
    ProcessStatus.loading => 'Connecting to the server',
    ProcessStatus.calculating => 'Finding the shortest paths',
    ProcessStatus.ready => state.totalTasks == 0 ? 'No tasks found' : 'All set',
    ProcessStatus.sending => 'Sending results',
    ProcessStatus.sent => 'Results sent',
    ProcessStatus.loadFailed => 'Could not finish',
  };

  String get _description => switch (state.status) {
    ProcessStatus.loading => 'Receiving the task list',
    ProcessStatus.calculating =>
      'Task ${state.completedTasks} of ${state.totalTasks}',
    ProcessStatus.ready =>
      state.totalTasks == 0
          ? 'The server returned an empty task list.'
          : '${state.totalTasks} ${state.totalTasks == 1 ? 'route is' : 'routes are'} ready to send.',
    ProcessStatus.sending => 'Uploading your calculated routes',
    ProcessStatus.sent => 'Opening your results',
    ProcessStatus.loadFailed => 'Check the connection and try again.',
  };

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final ProcessBloc bloc = context.read<ProcessBloc>();
    final double? progress = _visibleProgress;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              state.status == ProcessStatus.ready
                  ? Icons.check_rounded
                  : state.status == ProcessStatus.loadFailed
                  ? Icons.warning_amber_rounded
                  : Icons.alt_route_rounded,
              size: 42,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            _title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            _description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 0,
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: colors.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          state.status == ProcessStatus.loading
                              ? 'Server response'
                              : state.status == ProcessStatus.sending
                              ? 'Uploading'
                              : state.status == ProcessStatus.loadFailed &&
                                    state.totalTasks == 0
                              ? 'Server response'
                              : 'Calculation progress',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (progress != null)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          builder:
                              (
                                BuildContext context,
                                double value,
                                Widget? child,
                              ) => Text(
                                '${(value * 100).round()}%',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress ?? 0),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    builder:
                        (BuildContext context, double value, Widget? child) =>
                            LinearProgressIndicator(
                              value: progress == null ? null : value,
                              minHeight: 9,
                              borderRadius: BorderRadius.circular(8),
                            ),
                  ),
                  if (state.status == ProcessStatus.calculating) ...[
                    const SizedBox(height: 12),
                    Text(
                      '${state.completedTasks} of ${state.totalTasks} tasks completed',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (state.error != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.errorContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                state.error!,
                style: TextStyle(color: colors.onErrorContainer),
              ),
            ),
          ],
          const SizedBox(height: 28),
          if (state.status == ProcessStatus.loadFailed)
            PrimaryButton(
              label: 'Try again',
              icon: Icons.refresh_rounded,
              onPressed: () => bloc.add(const ProcessStarted()),
            ),
          if ((state.status == ProcessStatus.ready ||
                  state.status == ProcessStatus.sending) &&
              state.results.isNotEmpty)
            PrimaryButton(
              label: state.status == ProcessStatus.sending
                  ? 'Sending results'
                  : 'Send results',
              icon: Icons.cloud_upload_outlined,
              isLoading: state.status == ProcessStatus.sending,
              onPressed: state.status == ProcessStatus.ready
                  ? () => bloc.add(const ProcessSendPressed())
                  : null,
            ),
          if (state.status == ProcessStatus.loading ||
              state.status == ProcessStatus.calculating)
            Text(
              'This can take a moment',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}
