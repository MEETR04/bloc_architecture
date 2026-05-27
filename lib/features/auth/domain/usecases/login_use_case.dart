import 'package:bloc_architecture/core/utils/app_result.dart';
import 'package:bloc_architecture/features/auth/domain/repository/i_auth_repository.dart';
import 'package:bloc_architecture/features/auth/models/request/login_request_model.dart';
import 'package:bloc_architecture/features/auth/models/response/login_response_model.dart';
import 'package:bloc_architecture/values/extensions/string_extensions.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);
  final IAuthRepository _repository;

  Future<AppResult<LoginResponseModel>> call({
    required String email,
    required String password,
  }) async {
    final emailError = email.validateEmail;
    if (emailError != null) return Failure(emailError);

    final passwordError = password.validatePassword;
    if (passwordError != null) return Failure(passwordError);

    try {
      final result = await _repository.login(
        LoginRequestModel(email: email, password: password),
      );

      if (result.token != null) {
        return Success(result);
      }
      return const Failure('Invalid response from server');
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
