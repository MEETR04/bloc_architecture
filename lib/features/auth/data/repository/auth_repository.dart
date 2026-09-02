import 'package:bloc_architecture/core/api/exceptions/app_exception.dart';
import 'package:bloc_architecture/core/api/exceptions/dio_exception_utils.dart';
import 'package:bloc_architecture/features/auth/data/datasource/auth_api.dart';
import 'package:bloc_architecture/features/auth/domain/repository/i_auth_repository.dart';
import 'package:bloc_architecture/features/auth/models/request/login_request_model.dart';
import 'package:bloc_architecture/features/auth/models/request/sign_up_req_model.dart';
import 'package:bloc_architecture/features/auth/models/response/login_response_model.dart';
import 'package:bloc_architecture/features/auth/models/response/sign_up_response_model.dart';
import 'package:dio/dio.dart';

class AuthRepository implements IAuthRepository {
  const AuthRepository(this._authApi);
  final AuthApi _authApi;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      return await _authApi.login(request);
    } on DioException catch (e) {
      throw DioExceptionUtil.parseError(e);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<SignUpResponseModel> signUp(SignUpReqModel request) async {
    try {
      return await _authApi.register(request);
    } on DioException catch (e) {
      throw DioExceptionUtil.parseError(e);
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
