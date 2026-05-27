import 'package:bloc_architecture/core/api/base_response/base_response.dart';
import 'package:bloc_architecture/core/api/exceptions/app_exception.dart';
import 'package:bloc_architecture/features/auth/data/datasource/auth_api.dart';
import 'package:bloc_architecture/features/auth/domain/repository/i_auth_repository.dart';
import 'package:bloc_architecture/features/auth/models/request/login_request_model.dart';
import 'package:bloc_architecture/features/auth/models/request/sign_up_req_model.dart';
import 'package:bloc_architecture/features/auth/models/response/login_response_model.dart';
import 'package:bloc_architecture/features/auth/models/response/sign_up_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthRepository implements IAuthRepository {
  const AuthRepository(this._authApi);
  final AuthApi _authApi;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      return await _authApi.login(request);
    } on DioException catch (e) {
      final error = e.error;
      if (error is AppException) {
        throw error;
      }
      throw AppException(e.message ?? e.toString());
    }
  }

  @override
  Future<BaseResponse<SignUpResponseModel>> signUp(
    SignUpReqModel request,
  ) async {
    try {
      return await _authApi.register(request);
    } on DioException catch (e) {
      String? msg;
      final data = e.response?.data;
      if (data is Map) {
        msg = data['message']?.toString();
      }
      msg ??= e.message;
      throw AppException(msg ?? e.error?.toString());
    } catch (e) {
      debugPrint(e.toString());
      throw AppException(e.toString());
    }
  }
}
