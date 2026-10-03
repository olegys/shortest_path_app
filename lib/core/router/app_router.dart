import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/path/domain/entities/path_result.dart';
import '../../features/path/presentation/home/home_screen.dart';
import '../../features/path/presentation/preview/preview_screen.dart';
import '../../features/path/presentation/process/process_screen.dart';
import '../../features/path/presentation/results/result_list_screen.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String process = '/process';
  static const String results = '/results';
  static const String preview = '/preview';
}

final GoRouter routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.process,
      builder: (BuildContext context, GoRouterState state) =>
          const ProcessScreen(),
    ),
    GoRoute(
      path: AppRoutes.results,
      builder: (BuildContext context, GoRouterState state) =>
          ResultListScreen(results: state.extra! as List<PathResult>),
    ),
    GoRoute(
      path: AppRoutes.preview,
      builder: (BuildContext context, GoRouterState state) =>
          PreviewScreen(result: state.extra! as PathResult),
    ),
  ],
);
