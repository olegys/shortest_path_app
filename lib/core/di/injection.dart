import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/path/data/data_sources/path_api.dart';
import '../../features/path/data/repositories/path_repository_impl.dart';
import '../../features/path/data/repositories/shared_prefs_url_storage.dart';
import '../../features/path/domain/repositories/path_repository.dart';
import '../../features/path/domain/repositories/url_storage.dart';
import '../../features/path/domain/services/path_finder.dart';
import '../../features/path/presentation/home/home_cubit.dart';
import '../../features/path/presentation/process/process_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  getIt
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton<Dio>(() {
      final Dio dio = Dio();
      dio.interceptors.add(PrettyDioLogger(requestBody: true));
      return dio;
    })
    ..registerLazySingleton<PathApi>(() => PathApi(getIt<Dio>()))
    ..registerLazySingleton<UrlStorage>(
      () => SharedPrefsUrlStorage(getIt<SharedPreferences>()),
    )
    ..registerLazySingleton<PathRepository>(
      () => PathRepositoryImpl(getIt<PathApi>()),
    )
    ..registerLazySingleton<PathFinder>(() => BfsPathFinder())
    ..registerFactory<HomeCubit>(() => HomeCubit(getIt<UrlStorage>()))
    ..registerFactory<ProcessBloc>(
      () => ProcessBloc(
        pathRepository: getIt<PathRepository>(),
        pathFinder: getIt<PathFinder>(),
        urlStorage: getIt<UrlStorage>(),
      ),
    );
}
