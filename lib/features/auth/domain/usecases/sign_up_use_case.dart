import 'package:bloc_architecture/core/utils/app_result.dart';
import 'package:bloc_architecture/features/auth/domain/repository/i_auth_repository.dart';
import 'package:bloc_architecture/features/auth/models/request/sign_up_req_model.dart';
import 'package:bloc_architecture/features/auth/models/response/sign_up_response_model.dart';
import 'package:bloc_architecture/values/extensions/string_extensions.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);
  final IAuthRepository _repository;

  Future<AppResult<SignUpResponseModel>> call({
    required String email,
    required String password,
  }) async {
    final emailError = email.validateEmail;
    if (emailError != null) return Failure(emailError);

    final passwordError = password.validatePassword;
    if (passwordError != null) return Failure(passwordError);

    try {
      final result = await _repository.signUp(
        SignUpReqModel(email: email, password: password),
      );

      if (result.token != null) {
        return Success(result);
      }
      return const Failure('Sign up failed');
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
