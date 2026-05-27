import 'package:bloc/bloc.dart';
import 'package:bloc_architecture/core/utils/app_result.dart';
import 'package:bloc_architecture/features/auth/domain/usecases/login_use_case.dart';
import 'package:bloc_architecture/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
  }) : _loginUseCase = loginUseCase,
       _signUpUseCase = signUpUseCase,
       super(AuthInitial()) {
    on<LoginButtonPressedEvent>(_onLogin);
    on<SignUpButtonPressedEvent>(_onSignUp);
  }
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;

  Future<void> _onLogin(
    LoginButtonPressedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );
    switch (result) {
      case Success():
        emit(LoginSuccessfulState(successMessage: 'Login Successful'));
      case Failure(:final message):
        emit(LoginFailedState(errorMessage: message));
    }
  }

  Future<void> _onSignUp(
    SignUpButtonPressedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _signUpUseCase(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      phoneNumber: event.phoneNumber,
    );
    switch (result) {
      case Success():
        emit(SignUpSuccessfulState(successMessage: 'Sign Up Successful'));
      case Failure(:final message):
        emit(SignUpFailedState(errorMessage: message));
    }
  }
}
