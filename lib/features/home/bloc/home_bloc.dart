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
    on<SortUsersEvent>(_onSortUsers);
  }
  final GetUsersUseCase _getUsersUseCase;
  bool _isAscending = true;

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(UserListLoadingState());
    final result = await _getUsersUseCase(page: event.page);
    switch (result) {
      case Success(:final data):
        final sorted = List<ReqresUser>.from(data);
        _sortList(sorted);
        emit(UserListLoadedState(users: sorted, isAscending: _isAscending));
      case Failure(:final message):
        debugPrint('[HomeBloc] $message');
        emit(UserListFailedState(errorMessage: message));
    }
  }

  void _onSortUsers(SortUsersEvent event, Emitter<HomeState> emit) {
    _isAscending = event.isAscending;
    final currentState = state;
    if (currentState is UserListLoadedState) {
      final sorted = List<ReqresUser>.from(currentState.users);
      _sortList(sorted);
      emit(UserListLoadedState(users: sorted, isAscending: _isAscending));
    }
  }

  void _sortList(List<ReqresUser> list) {
    if (_isAscending) {
      list.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else {
      list.sort((a, b) => b.fullName.compareTo(a.fullName));
    }
  }
}
