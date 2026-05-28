part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class FetchUsersEvent extends HomeEvent {
  FetchUsersEvent({this.page = 1});
  final int page;
}
