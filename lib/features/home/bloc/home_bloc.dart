import 'package:bloc/bloc.dart';
import 'package:bloc_architecture/core/utils/app_result.dart';
import 'package:bloc_architecture/features/home/domain/usecases/get_users_use_case.dart';
import 'package:bloc_architecture/features/home/models/response/reqres_user_model.dart';
import 'package:flutter/foundation.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetUsersUseCase getUsersUseCase})
      : _getUsersUseCase = getUsersUseCase,
        super(HomeInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
  }
  final GetUsersUseCase _getUsersUseCase;

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(UserListLoadingState());
    final result = await _getUsersUseCase(page: event.page);
    switch (result) {
      case Success(:final data):
        emit(UserListLoadedState(users: data));
      case Failure(:final message):
        debugPrint('[HomeBloc] $message');
        emit(UserListFailedState(errorMessage: message));
    }
  }
}
