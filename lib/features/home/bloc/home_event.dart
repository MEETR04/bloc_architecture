part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

/// Triggers a category list fetch from the API.
class FetchCategoriesEvent extends HomeEvent {}
