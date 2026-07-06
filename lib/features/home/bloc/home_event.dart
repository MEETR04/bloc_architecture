part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class FetchUsersEvent extends HomeEvent {
  FetchUsersEvent({this.page = 1});
  final int page;
}

class SortUsersEvent extends HomeEvent {
  SortUsersEvent({required this.isAscending});
  final bool isAscending;
}
