import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/url_validator.dart';
import '../../domain/repositories/url_storage.dart';

class HomeState extends Equatable {
  const HomeState({this.initialUrl = '', this.error, this.proceed = false});

  final String initialUrl;
  final String? error;

  final bool proceed;

  @override
  List<Object?> get props => [initialUrl, error, proceed];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._storage)
    : super(HomeState(initialUrl: _storage.read() ?? ''));

  final UrlStorage _storage;

  Future<void> submit(String input) async {
    final String url = input.trim();
    final String? error = UrlValidator.validate(url);
    if (error != null) {
      emit(HomeState(initialUrl: state.initialUrl, error: error));
      return;
    }

    await _storage.save(url);
    emit(HomeState(initialUrl: url, proceed: true));
    emit(HomeState(initialUrl: url));
  }

  void clearError() {
    if (state.error != null) {
      emit(HomeState(initialUrl: state.initialUrl));
    }
  }
}
