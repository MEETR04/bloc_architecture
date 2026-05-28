part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class UserListLoadingState extends HomeState {}

final class UserListLoadedState extends HomeState {
  UserListLoadedState({required this.users});
  final List<ReqresUser> users;
}

final class UserListFailedState extends HomeState {
  UserListFailedState({required this.errorMessage});
  final String errorMessage;
}
