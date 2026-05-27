import 'package:bloc_architecture/core/api/base_response/base_response.dart';
import 'package:bloc_architecture/features/auth/models/request/login_request_model.dart';
import 'package:bloc_architecture/features/auth/models/request/sign_up_req_model.dart';
import 'package:bloc_architecture/features/auth/models/response/login_response_model.dart';
import 'package:bloc_architecture/features/auth/models/response/sign_up_response_model.dart';

abstract interface class IAuthRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<BaseResponse<SignUpResponseModel>> signUp(SignUpReqModel request);
}
