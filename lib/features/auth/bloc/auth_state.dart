part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class LoginSuccessfulState extends AuthState {
  LoginSuccessfulState({required this.successMessage});
  final String successMessage;
}

final class LoginFailedState extends AuthState {
  LoginFailedState({required this.errorMessage});
  final String errorMessage;
}

final class SignUpSuccessfulState extends AuthState {
  SignUpSuccessfulState({required this.successMessage});
  final String successMessage;
}

final class SignUpFailedState extends AuthState {
  SignUpFailedState({required this.errorMessage});
  final String errorMessage;
}
