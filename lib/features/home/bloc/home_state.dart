part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class CategoryListLoadingState extends HomeState {}

final class CategoryListLoadedState extends HomeState {
  CategoryListLoadedState({required this.categories});
  final List<Category> categories;
}

final class CategoryListFailedState extends HomeState {
  CategoryListFailedState({required this.errorMessage});
  final String errorMessage;
}
