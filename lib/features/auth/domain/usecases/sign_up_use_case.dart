import 'dart:io';

import 'package:bloc_architecture/core/db/app_db.dart';
import 'package:bloc_architecture/core/utils/app_result.dart';
import 'package:bloc_architecture/features/auth/domain/repository/i_auth_repository.dart';
import 'package:bloc_architecture/features/auth/models/request/sign_up_req_model.dart';
import 'package:bloc_architecture/features/auth/models/response/sign_up_response_model.dart';
import 'package:bloc_architecture/service/get_device_info.dart';
import 'package:bloc_architecture/values/app_constants.dart';
import 'package:bloc_architecture/values/extensions/string_extensions.dart';
import 'package:uuid/uuid.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository, this._deviceInfo);
  final IAuthRepository _repository;
  final DeviceInfo _deviceInfo;

  Future<AppResult<SignUpResponseModel>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final emailError = email.validateEmail;
    if (emailError != null) return Failure(emailError);

    final passwordError = password.validatePassword;
    if (passwordError != null) return Failure(passwordError);

    try {
      final response = await _repository.signUp(
        SignUpReqModel(
          businessName: AppConstants.defaultBusinessName,
          socialToken: const Uuid().v4(),
          otp: AppConstants.defaultOtp,
          loginType: AppConstants.defaultLoginType,
          firstName: firstName,
          lastName: lastName,
          email: email,
          userType: AppConstants.defaultUserType,
          deviceType: Platform.isAndroid ? 'A' : 'I',
          osVersion: _deviceInfo.osVersion,
          modelName: _deviceInfo.modelName,
          phoneNumber: int.tryParse(phoneNumber),
          password: password,
          deviceName: _deviceInfo.deviceName,
          uuid: _deviceInfo.uuid,
          ip: _deviceInfo.ip,
          deviceToken: const Uuid().v4(),
        ),
      );

      if (response.data != null && response.isOk) {
        appDB.user = response.data;
        appDB.token = response.data!.token ?? '';
        appDB.isLogin = true;
        return Success(response.data!);
      }

      return Failure(response.message ?? 'Sign up failed');
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
