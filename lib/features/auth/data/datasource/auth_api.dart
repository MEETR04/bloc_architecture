import 'package:bloc_architecture/core/api/api_endpoints.dart';
import 'package:bloc_architecture/features/auth/models/request/login_request_model.dart';
import 'package:bloc_architecture/features/auth/models/request/sign_up_req_model.dart';
import 'package:bloc_architecture/features/auth/models/response/login_response_model.dart';
import 'package:bloc_architecture/features/auth/models/response/sign_up_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'auth_api.g.dart';

@RestApi(baseUrl: APIEndPoints.baseUrl)
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  // reqres.in returns { token } directly — no BaseResponse wrapper
  @POST(APIEndPoints.login)
  Future<LoginResponseModel> login(@Body() LoginRequestModel body);

  // reqres.in returns { id, token } directly — no BaseResponse wrapper
  @POST(APIEndPoints.register)
  Future<SignUpResponseModel> register(@Body() SignUpReqModel body);
}
