part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginButtonPressedEvent extends AuthEvent {
  LoginButtonPressedEvent({required this.email, required this.password});
  final String email;
  final String password;
}

// reqres.in register only needs email + password
class SignUpButtonPressedEvent extends AuthEvent {
  SignUpButtonPressedEvent({required this.email, required this.password});
  final String email;
  final String password;
}
