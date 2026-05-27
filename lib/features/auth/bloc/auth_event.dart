part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginButtonPressedEvent extends AuthEvent {
  LoginButtonPressedEvent({required this.email, required this.password});
  final String email;
  final String password;
}

class SignUpButtonPressedEvent extends AuthEvent {
  SignUpButtonPressedEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
}
