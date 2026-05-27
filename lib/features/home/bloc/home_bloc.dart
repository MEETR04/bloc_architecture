import 'package:bloc/bloc.dart';
import 'package:bloc_architecture/core/utils/app_result.dart';
import 'package:bloc_architecture/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:bloc_architecture/features/home/models/response/category_list_response_model.dart';
import 'package:flutter/foundation.dart' hide Category;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetCategoriesUseCase getCategoriesUseCase})
    : _getCategoriesUseCase = getCategoriesUseCase,
      super(HomeInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
  }
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _onFetchCategories(
    FetchCategoriesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(CategoryListLoadingState());
    final result = await _getCategoriesUseCase();
    switch (result) {
      case Success(:final data):
        emit(CategoryListLoadedState(categories: data));
      case Failure(:final message):
        debugPrint('[HomeBloc] $message');
        emit(CategoryListFailedState(errorMessage: message));
    }
  }
}
